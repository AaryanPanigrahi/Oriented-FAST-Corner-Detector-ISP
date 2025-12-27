# FAST Corner Detection Image Signal Processor (ISP)

A hardware image signal processor that denoises an image with a 2D Gaussian filter and then runs a FAST corner detector to produce a corner feature map suitable for real-time computer vision pipelines.[1]

***

<p align="center">
  <!-- Main system block diagram / aesthetic render -->
</p>

***

## Project Overview

This project implements a corner-detecting **image signal processor** that takes an input frame over AHB, performs Gaussian de-noising and optional downscaling, runs the FAST corner detection algorithm, applies non-maximum suppression (NMS), and exposes both the processed image and feature maps back over AHB. The design targets ASIC-style RTL with explicit SRAM-backed image buffers, making it a realistic prototype for ISP blocks used in embedded vision and SLAM pipelines.[1]

The ISP is organized as a set of modular processing stages—Gaussian, FAST, NMS, and visualization—connected by well-defined SRAM interfaces, enabling independent verification, pipelining, and future feature growth.[2][1]

***

## System Architecture & Data Flow

At a high level, the ISP receives a frame through an AHB subordinate interface, stores it into on‑chip memory, processes it through Gaussian and FAST pipelines, optionally applies NMS and visualization, and then returns image and feature outputs via a defined memory map. Memory-mapped regions hold the input image, feature array, output image, and configuration registers that control resolution and output mode.[1]

Core flow (baseline path):[2][1]
- AHB → Input SRAM (raw image)  
- Gaussian convolution + optional downscaling → Denoised / downscaled image SRAM  
- FAST corner detection → Feature map SRAM  
- NMS → Refined corner map SRAM  
- Visualization → Output image SRAM with highlighted corners

### Memory Map (Top-Level View)

| Region                         | Address Range     | Role                                                                 |
|--------------------------------|-------------------|----------------------------------------------------------------------|
| Input Image                    | `0x00000–0x1C1FF` | Raw image up to 720×1280 pixels, bottom-left oriented.[1]      |
| Feature Array                  | `0x1C200–0x383FF` | 720×1280 bit map of corner presence (1 = corner).[1]           |
| Output Image                   | `0x38400–0x545FF` | Post-processed / visualized image frame.[1]                    |
| Configuration Register         | `0x54600–0x54603` | Width, height, output mode, and control bits.[1]               |

An internal controller steers read/write traffic between the processing stages and the appropriate SRAM banks, ensuring that Gaussian, FAST, and NMS see consistent pixel data and that intermediate results can be reused without redundant transfers.[2][1]

***

<p align="center">
  <!-- Dataflow diagram: AHB → SRAM → Gaussian → FAST → NMS → Visualizer -->
</p>

---

## Gaussian Convolution Subsystem

The Gaussian stage implements a 2D convolution-based low-pass filter to suppress high-frequency aliasing and noise before corner detection. This improves FAST feature quality by smoothing spurious contrast variations while preserving underlying structural edges.[3][1]

### Conceptual Behavior

- A 2D Gaussian kernel \(G(x,y)\) is synthesized for a given kernel size and standard deviation \(\sigma\), then normalized so that its coefficients sum to 1.[1]
- The kernel is convolved over the image tensor, conceptually per-channel for RGB but applied on a grayscale stream in the baseline corner detector path.[1]
- Border handling uses padded zeros via the SRAM-to-2D abstraction so that out-of-bounds accesses yield 0, effectively implementing zero padding.[2]

The Matlab reference pipeline generates kernels, applies convolution on test images of varying resolutions, and produces ground truth outputs used for RTL verification.[3][1]

### RTL Structure

The Gaussian pipeline is decomposed into several reusable RTL blocks, each with a narrow, testable contract:[2]

- **InitializeKernel.sv**  
  - Inputs: `clk`, `nrst`, `start`, `sigma`, `SIZE`.[2]
  - Outputs: `kernel[SIZE×SIZE]`, `sum`, `done`.[2]
  - Function: Computes and normalizes the fixed-point Gaussian kernel coefficients for the requested kernel size and variance; asserts `done` when the kernel is ready.[2]

- **PropagateMatrix.sv**  
  - Inputs: `clk`, `nrst`, `inputbuffer`, `done`, `nextdir`.[2]
  - Outputs: `inputmatrix[SIZE×SIZE]`, `ready`.[2]
  - Function: Maintains the sliding \(N\times N\) overlap window over the 2D image, shifting horizontally and vertically in a “snake-like” scanning pattern derived from `nextdir`. Borders are zero buffered.[2]

- **MatrixIndex.sv**  
  - Inputs: `clk`, `nrst`, `curx`, `cury`, `kernel`, `in`, `enstrobe`.[2]
  - Outputs: `kernelv`, `pixelv`.[2]
  - Function: Walks over the kernel and overlap patches cell-by-cell, providing temporally serialized coefficient/pixel pairs into the MAC datapath.[2]

- **ComputeKernel.sv**  
  - Inputs: `clk`, `nrst`, `inputmatrix`, `kernel`, `start`.[2]
  - Outputs: `blurredpixel`, `done`.[2]
  - Function: Implements the multiply-accumulate path for one convolution result, truncating saturation at 255 on overflow and clearing the accumulator between pixels.[2]

- **convmemory.sv + sramimage.sv**  
  - `sramimage.sv` maps a 1D SRAM block into 2D coordinates and pads out-of-range access with 0.[2]
  - `convmemory.sv` prefetches upcoming pixels and keeps a rolling K×K working buffer synchronized with the scanning order.[2]

- **controllergaussian.sv**  
  - Bridges the Gaussian modules and SRAM interface, latching `maxx`, `maxy`, kernel size, and coordinating the `newtrans`, `newsamplereq`, `newsampleready`, and `nextdir` handshake between memory and computation.[2]

### Gaussian Pipelining and NextDir

The Gaussian pipeline is designed to minimize redundant memory reads by reusing overlapping pixels between successive convolution windows.[3][2]

Key ideas:[3][2]
- For an \(N\times N\) kernel, only the “new” N pixels entering the window on each shift need to be fetched; existing pixels are shifted within the buffer.[3][2]
- The scanning pattern is “snake-like”: rows alternate direction to avoid long horizontal resets and to align vertical shifts with the kernel buffer update pattern.[2]
- The `nextdir` signal encodes horizontal and vertical movement; the `pixelpos` logic coordinates when `currx` and `curry` stay fixed or step to the next location for consistent buffer updates.[2]

This transforms the naive \(O(N^2)\) pixel load cost per output into a more efficient scheme that amortizes accesses across neighboring windows, which is critical when targeting higher resolutions and larger kernels.[3][2]

***

<p align="center">
  <!-- Gaussian pipeline diagram: kernel init, overlap buffer, MAC, SRAM -->
</p>

---

## FAST Corner Detection Subsystem

The FAST (Features from Accelerated Segment Test) stage identifies corner-like structures in the denoised image by comparing the luminance of each pixel against a ring of surrounding pixels. It uses early-exit logic and pipelining to reduce the number of SRAM accesses and comparisons per pixel.[1][3][2]

### Algorithmic Behavior

- For each candidate pixel \(p\), a 16-point circle of surrounding pixels is sampled (e.g., using a Bresenham-like circle rasterization).[1]
- Each neighbor’s brightness is compared against \(p\) with a configurable threshold; neighbors significantly brighter or darker contribute to a contiguous run.[1]
- If at least 12 consecutive neighbors satisfy the threshold in the same direction, \(p\) is classified as a corner.[1][2]

To accelerate this process:[1][2]
- High-priority positions (e.g., 1, 5, 9, 13 on the circle) are checked first; if they fail requirements, the pixel can be rejected early without loading all 16 neighbors.[1]
- A mask-based representation of candidate matches allows partial contingency checks as the buffer is progressively filled.[2]

### RTL Structure

FAST corner detection is built around a pixel iterator, a neighborhood buffer, and a decision engine:[2]

- **fastpixelpos.sv**  
  - Inputs: `clk`, `nrst`, `currx`, `curry`, `SRAMin`, `start`.[2]
  - Outputs: `xaddr`, `yaddr`, `xaddr4`, `yaddr4`, `updatesample`, `writeSRAM4`.[2]
  - Function:  
    - Walks the image grid in lockstep with the Gaussian pipeline using a shared snake-like addressing scheme.[2]
    - Generates the addresses needed to read the center pixel and surrounding circle from SRAM.[2]
    - Asserts `updatesample` once a pixel has been either accepted as a corner or definitively rejected (allowing upstream controllers to advance).[2]
    - Asserts `writeSRAM4` only when a corner is detected, writing a 1 into the feature SRAM for that location.[2]

- **FAST core logic** (within the controllerfast/FAST cluster):  
  - Maintains a small buffer for the center pixel and up to 16 neighbor values, loaded over multiple cycles from SRAM.[2]
  - Performs threshold comparisons as each neighbor arrives, updating a contiguous-run mask.[2]
  - Applies early exit when it is impossible to reach 12 contiguous positives, immediately asserting `updatesample` and resetting to load the next center.[2]

- **controllerfast.sv**  
  - Coordinates SRAM interfaces: reads from Gaussian output SRAM, writes to FAST feature SRAM, and keeps `maxx`, `maxy`, and pipeline timing aligned with the Gaussian stage.[2]
  - Ensures that FAST never overtakes Gaussian by gating its enable until sufficient lines of Gaussian output are available.[2]

### Timing and Early-Exit Behavior

The design explicitly constrains latency per pixel by:[2]
- Limiting neighborhood fetch cycles (e.g., up to 3 cycles to load each value into the registered buffer in the worst case).[2]
- Allowing early exit when enough neighbors fail to meet the brightness condition, skipping the remaining loads.[2]
- Keeping `currx` and `curry` stable until `updatesample` is asserted, avoiding drift between the address generator and Gaussian pipeline.[2]

This makes runtime proportional to the number of “corner-like” pixels rather than the full image area, which is crucial for dense high-resolution inputs where corners are sparse.[1][2]

***

<p align="center">
  <!-- FAST neighborhood circle illustration + buffer/timing diagram -->
</p>

***

## Top-Level Corner Detector & AHB Interface

### cornerdetector.sv (Top-Level ISP)

The `cornerdetector` module stitches together Gaussian denoising, FAST detection, SRAM banks, and the external AHB interface to form a complete corner-detecting ISP.[2]

High-level responsibilities:[1][2]
- Acts as the root RTL module for synthesis and integration, exposing image parameters, SRAM signals, and control/status signals.  
- Instantiates `controllergaussian`, `controllerfast`, and SRAM abstractions for raw image, denoised image, and feature maps.[2]
- Orchestrates multi-line pipelining: FAST starts on a line only after Gaussian has fully processed the corresponding region (and, if configured, the required lookahead lines).[2]

Interfaces are partitioned as:[2]
- **Image Params / AHB:** Address, data, and control signals for reading input and writing outputs through the memory map.[1]
- **Image SRAM Input:** Coordinates (`xaddrimg`, `yaddrimg`), enables (`renimg`, `wenimg`), and data lines to the raw input buffer.[2]
- **Gaussian De-noised SRAM:** Similar interface for the intermediate blurred image.[2]
- **FAST Features SRAM:** Read/write interface for the binary corner map.[2]

### AHB Subordinate Interface

The ISP behaves as an AHB subordinate, exposing:[1]
- A memory-mapped image buffer for the host/master to write input frames and read back results.  
- Configuration registers encoding image width, height, and output mode (e.g., raw feature map, visualized overlay).[1]
- A transfer scheme that interlaces input and output so that the ISP can process frame \(n\) while frame \(n+1\) is being loaded, amortizing bus usage and hiding processing latency.[1]

The AHB master (e.g., SoC CPU or ML-based controller) can update computation regions, configure downscaling factors, and control which visualization or processing path is active, enabling dynamic tradeoffs between accuracy and throughput.[1]

***

<p align="center">
  <!-- Top-level architecture / bus interface diagram -->
</p>

***

## Enhanced Processing Features

The design document outlines a set of advanced features that extend the ISP beyond the baseline grayscale Gaussian + FAST path. These are structured here as two major subsystems: color/format handling and visualization.[3][1][2]

### Grayscale & Color-Space Preprocessing

This subsystem focuses on reducing computational cost and supporting richer input formats via grayscale conversion, RGB/YCbCr handling, and optional downscaling.[3][1]

#### RGB to Weighted Grayscale

To reduce the dimensionality of the data path, the ISP converts color images into a single-luminance plane before running convolution and FAST. Using a perceptual weighting model preserves edge information while reducing arithmetic operations and memory bandwidth.[3]

Key aspects:[3]
- Input pixels are encoded in RGB; a naive average of R, G, B would distort perceived brightness.  
- A weighted combination is used instead, typically:
  \[
  \text{Gray} = 0.299 \cdot R + 0.587 \cdot G + 0.114 \cdot B
  \]
  with fixed-point scaling applied in hardware.[3]
- This reduces per-pixel convolution operations by a factor of ~3 (e.g., 12,000,000 operations → ~4,000,000 for a 400×400 image with a 5×5 kernel) without sacrificing corner detection quality.[3]

Internally, the grayscale converter can sit either:[3][1]
- Just after AHB input, writing grayscale pixels to the input SRAM, or  
- As a pre-processing stage that generates a separate luminance buffer for Gaussian and FAST while still retaining the original RGB frame for visualization overlays.

#### RGB/YCbCr Support and Downscaling

To handle more realistic camera pipelines, the ISP is designed to accept different color encodings and resolutions. This includes:[1]
- Supporting RGB and YCbCr image formats via a configurable front-end that can interpret the input layout and map it to internal luminance/chrominance planes.  
- Applying pre-Gaussian downscaling to larger images so that effective processing time remains within real-time budgets, while still preserving enough structure for FAST corner detection.[1]

Downscaling strategies:[1]
- Recursive pyramid downscaling: repeated blur+downsample operations to create multi-scale representations, with FAST running on one or more pyramid levels.  
- Resolution-dependent tuning: at high input resolutions, downscaling is applied more aggressively to meet 24 FPS goals; at lower resolutions, full-resolution processing can be kept.[1]

***

<p align="center">
  <!-- Grayscale conversion + downscaling pipeline diagram -->
</p>

---

### Feature Visualization & Overlay

The visualization subsystem converts the binary feature map into a human-interpretable overlay, allowing qualitative inspection of FAST performance and enabling downstream UX or analytics features.[1][2]

#### Corner Map Rendering & Overlay

The corner map visualization performs two main tasks:[1][2]
- **Overlay mode:** For each pixel, the module reads the original image and the feature map; where a corner is present, the output pixel is modified (e.g., recolored, brightened, or otherwise marked) to highlight the detected feature.[1]
- **Masking mode:** Non-corner regions can be zeroed out or desaturated, effectively isolating the corner structure for algorithm debugging or artistic effects.[1]

This involves reversing the addressing flow used by FAST: instead of reading from the denoised buffer, the module reads from the original or de-aliased image and merges it with the feature bits.[1][2]

#### Circle Rasterization for Feature Marking

For more expressive visualization, the system can draw circles around regions of high corner density using a hardware circle rasterizer. This employs variants of the Bresenham and Jesko algorithms:[1]
- The circle is computed for a single octant and mirrored across octants to cover 360 degrees while minimizing arithmetic operations.[1]
- Bresenham’s midpoint-based approach uses incremental error terms and only needs integer arithmetic and a small number of registers.[1]
- Jesko’s method further optimizes the step sequencing to keep the operation down to roughly five arithmetic operations per step in hardware.[1]

The circle-drawing logic is gated by a “true” signal that is asserted only when the feature map indicates a corner at `currx`, `curry`, preventing spurious overlays.[1][2]

#### Non-Maximum Suppression (NMS)

NMS is deployed as a post-processing stage after FAST to thin out dense clusters of adjacent detections. It:[1]
- Assigns each candidate a confidence score based on local intensity patterns or FAST response metrics.  
- Selects the strongest detection in a neighborhood and suppresses neighboring candidates whose Intersection-over-Union (IoU) overlap exceeds a threshold.[1]

This yields a cleaner and more interpretable corner map, which is particularly important for downstream SLAM or tracking algorithms that rely on sparse, distinctive keypoints.[1]

***

<p align="center">
  <!-- Visualization example: original vs overlay vs NMS-thinned corners -->
</p>

***

## Advanced Performance & Pipeline Enhancements

Beyond the core functionality, the project includes a set of performance and scalability enhancements aimed at achieving real-time behavior and flexible region-based processing.[1][2]

### Pipelined Corner Detection Across Gaussian Output

The corner detection pipeline is designed to run concurrently with Gaussian processing as long as data dependencies are respected.[2]

Core ideas:[2]
- FAST is allowed to start only after Gaussian has processed a minimum number of lines (e.g., 3 lines) to ensure its neighborhood window is valid.[2]
- A controller tracks line counts and uses `maxx` and `maxy` settings to determine when a row is safe to release to FAST.[2]
- FAST must never overtake the Gaussian front; it also must not lag too far behind, so counters regulate how many rows FAST can process per Gaussian line.[2]

This yields a line-buffer style pipeline where Gaussian and FAST operate on different regions of the same frame at the same time, increasing throughput and hiding computation latency.[1][2]

### Region-Based Gaussian & FAST

To scale to larger resolutions and specialized use cases:[1]
- The frame can be partitioned into tiles or sections, each processed independently by Gaussian and FAST.[1]
- Once tiles are processed, an optional stitching step can run on the borders to ensure seamless edges, which also opens the door to resolution upscaling via multi-tile synthesis.[1]

This approach can be used in tandem with downscaling and intensity-based Gaussian “spot blurring,” where only selected regions (faces, license plates, etc.) are blurred or processed for features, while other regions are left untouched to preserve performance.[1]

### Error Budgeting & Fixed-Point Precision

Gaussian convolution and subsequent processing stages rely on fixed-point arithmetic for kernel weights and intermediate sums, introducing quantization error compared to floating-point references. To manage this:[1]
- The kernel uses 8-bit fixed-point representation for decimal coefficients, targeting a bounded percent error (around a few percent) relative to double-precision Matlab outputs.  
- Testbenches run multiple matrix operations and compare results against Matlab outputs to ensure that blurring quality and brightness preservation remain within acceptable thresholds for both perception and FAST accuracy.[1][2]

Fine-tuning the fixed-point format and normalization logic allows trading off hardware complexity against visual fidelity and corner-detection robustness.[1][2]

***

<p align="center">
  <!-- Performance / pipeline timing diagram and possible FPS targets -->
</p>

***

## Verification & Reference Tooling

The design is accompanied by a structured verification plan and software reference models.[1][2]

Key components:[3][1][2]
- Matlab scripts for Gaussian kernel generation and convolution on sample images, used to derive expected blurred outputs.  
- Python/Matlab tooling to run FAST, NMS, and visualization on reference images and to compare them with Questasim RTL dumps.  
- Testbenches per module (e.g., `flexcounterdir`, `getpixel`, `srammodel`, Gaussian modules, FAST pixel iterator) that stress-reset behavior, edge cases, and mid-stream parameter changes.[2]

This layered verification approach makes each module verifiable in isolation and then in full-chain integration, reducing debugging effort as features are added.[2]

***

<p align="center">
  <!-- Space for verification waveforms / side-by-side RTL vs Matlab screenshots -->
</p>

[1](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/83555559/609b187f-834e-48fd-92f2-cfa27d1447b6/ECE-337-CDL-Project-Outline.pdf)
[2](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/83555559/03a9f937-23dd-4842-89bc-8a19704bf69c/FAST-ISP-Verification-Plan.pdf)
[3](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/83555559/b127a5b5-bc1c-4db3-931f-aafccdeef315/ECE337-CDL-Demo-Slides.pdf)
[4](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/83555559/f2e96332-0f31-4d3f-9b3c-1f2c94ed6260/Readme.md)
