# FAST Corner Detection ISP

A hardware image signal processor that denoises an image with a 2D Gaussian filter and then runs a FAST corner detector to produce a corner feature map suitable for real-time computer vision pipelines.

***

<p align="center">
  <img src="https://github.com/AaryanPanigrahi/Oriented-FAST-Corner-Detector-ISP/blob/main/documentation/images/DogPhotoCompare.png" width="700">
</p>

***

## Project Overview

This project implements a corner-detecting **image signal processor** that takes an input frame flashed onto SRAM, performs Gaussian de-noising and optional downscaling, runs the FAST corner detection algorithm, applies non-maximum suppression (NMS). The design targets explicit SRAM-backed image buffers, making it a realistic prototype for ISP blocks used in embedded vision and SLAM pipelines.

The ISP is organized as a set of modular processing stages - Gaussian de-blurring, FAST, NMS, and corner visualization - connected by SRAM interfaces, enabling independent verification, pipelining, and future feature growth.

***

## System Architecture & Data Flow

At a high level, the ISP receives a frame flashed onto SRAM, along with a seperate SRAM for image and processing parameters. The core pipepline involves first generating a kernel given parameters for kernel size (KxK) and variance values, then loading a (KxK) "working" image values from SRAM and storing them on local registers and performing gaussian convolution on the entire image. After de-noising is complete, a run of the FAST algoritim is run across the image per pixel and saved onto an output 1 bit SRAM 

<p align="center">
  <img src="https://github.com/AaryanPanigrahi/Oriented-FAST-Corner-Detector-ISP/blob/main/documentation/images/CorePipelineWorkflow.png" width="700">
</p>

---

## Gaussian Convolution Subsystem

The Gaussian stage implements a 2D convolution-based low-pass filter to suppress high-frequency aliasing and noise before corner detection. This improves FAST feature quality by smoothing spurious contrast variations while preserving underlying structural edges.

### Conceptual Behavior

- A 2D Gaussian kernel \(G(x,y)\) is synthesized for a given kernel size and standard deviation \(\sigma\), then normalized so that its coefficients sum to 1.
- The kernel is convolved over the image applied on a grayscale stream in the baseline corner detector path
- Border handling uses padded zeros via the SRAM-to-2D abstraction so that out-of-bounds accesses yield 0, effectively implementing zero padding

The Matlab reference pipeline generates kernels, applies convolution on test images of varying resolutions, and produces ground truth outputs used for RTL verification.

### Convolution of a 3x3 kernel over a 4 bit image
<div align="center">
  <video
    src="https://github.com/user-attachments/assets/a17b8fac-5327-4e39-9859-c9637499317e"
  ></video>
</div>

## Module Hierarchy & Design

The FAST ISP is composed of 25+ modular RTL blocks organized into logical subsystems: parameter extraction, image preprocessing, Gaussian convolution, FAST detection, visualization, and supporting utilities.[file:25][file:26]

### Top-Level Integration Modules

- **orb_fast_conv.sv**  
  The ultimate root module that orchestrates the complete pipeline. Instantiates `param_controller`, `ConvertBW`, `GaussianConv`, and `fast_top_level`. Manages the end-to-end flow from raw image input to visualized corner output.

- **param_controller.sv**  
  Extracts image metadata (dimensions, kernel size, Gaussian variance) from a parameter SRAM region (similar to PNG/BMP headers). Stores these values in accessible registers and asserts `new_trans` to kick off processing when a new frame loads. Uses an FSM to crawl through modes until `PROCESS_MODE`, then signals `done=1` for the next frame.

- **GaussianConv.sv**  
  Top-level Gaussian convolution controller. Waits for `new_trans`, attaches to grayscale input SRAM, outputs blurred image to output SRAM. Combines `CreateKernel`, `pixel_pos`, `conv_memory`, and `ComputeKernel`. Outputs `pixel_done` per pixel (for FAST sync) and `conv_done` for full image completion.

- **fast_top_level.sv**  
  Top-level FAST corner detection and visualization. Combines `pixel_pos`, `pipelined_buffer_loader`, `fast_controller`, and `draw_circle`. Interfaces input Gaussian SRAM, output FAST SRAM, and visualizer SRAM.

---

## Gaussian Convolution Pipeline

The Gaussian subsystem implements 2D convolution with kernel generation, overlap windowing, and pipelined memory access.

- **InitKernel.sv**  
  Initializes an unnormalized Gaussian kernel based on `kernel_size` and `variance` parameters.

- **CreateKernel.sv**  
  Normalizes the kernel from `InitKernel` using its computed sum, producing valid convolution weights.

- **ComputeKernel.sv**  
  Top-level kernel computation datapath. Orchestrates `pixel_pos`, `KernelAccumulator`, and `MatrixIndex` to convolve across the entire image.

- **KernelAccumulator.sv**  
  Multiplies current pixel and kernel values (from `MatrixIndex`), accumulates the result, and clears after each kernel position completes.

- **MatrixIndex.sv**  
  Combinatorially selects the current pixel/kernel pair from the overlap patch and kernel based on position counters.

- **conv_memory.sv**  
  Manages the rolling \(K\times K\) working buffer from SRAM. Uses `pixel_pos` for top-left tracking and `nextdir` to load only the new \(K\) pixels per shift (snake pattern: 0→x_max→y++→x_max→0). Asserts `new_sample_ready` when loaded; shifts on `new_sample_req` from `ComputeKernel`. Amortizes \(O(K^2)\) to \(O(K)\) memory accesses per output pixel.

---

## FAST Corner Detection Pipeline

The FAST subsystem implements accelerated corner detection with early-exit and pipelined neighborhood loading.

- **fast_controller.sv**  
  FAST FSM. Waits for Gaussian `pixel_done`, runs FAST detection, then triggers `draw_circle` visualization. Ensures pipeline synchronization.

- **pipelined_buffer_loader.sv**  
  Pipelined neighborhood buffer (16-pixel circle). Exploits SRAM read-post timing to address the next pixel while loading the current one into registers.

---

## Image Preprocessing & Format Handling

- **ConvertBW.sv**  
  Converts RGB input to weighted grayscale luminance plane. Applies perceptual weights (\(0.299R + 0.587G + 0.114B\)) to preserve edge structure while reducing channel count by 3x.

- **ComputeBW.sv**  
  Computes grayscale from RGB pixels, feeding the luminance stream into Gaussian.

---

## Visualization & Overlay

- **draw_circle.sv**  
  Overlays circles on a copy of the original RGB SRAM to highlight corners from the FAST output SRAM matrix. Uses hardware rasterization (Bresenham/Jesko variants).

---

## Core Utilities & Primitives

These foundational modules support addressing, memory, and counting across the pipeline.

### Addressing & Traversal

- **pixel_pos.sv**  
  Snake-like image traversal (two modes: snake vs. raster). At row end, holds `x`, increments `y`, reverses direction. Uses `flex_counter_dir`. Outputs `next_dir` for `conv_memory` synchronization and `endpos`.

### Memory Hierarchy

- **sram_model.sv**  
  Parameterized 1D dual-port SRAM primitive. Supports `rmh` for image file load/dump.

- **sram_image.sv**  
  2D SRAM wrapper around `sram_model`. Auto-pads out-of-bounds pixels with 0 (or optionally 0xFF white). Includes `load_img`/`dump_img` for testbench image flashing.

- **memory_reg.sv**  
  Simple parameterized register file. Loads values when `load_enable` is high.

### Counters

- **FlexCounter.sv**  
  Baseline up-counter.

- **flex_counter_dir.sv**  
  Directional flex counter (3 modes):  
  - Count-up: 0→`wrapval`→1 (wrapflag).  
  - Count-down: `wrapval`→1→`wrapval`.  
  - Up-down: 0→`wrapval`→0 (rolloverflag).

---

## Module Dependencies

<p align="center">
  <img src="https://github.com/AaryanPanigrahi/Oriented-FAST-Corner-Detector-ISP/blob/main/documentation/images/Top%20Level%20Hierarchy.png" width="700">
</p>

This hierarchy ensures each module has a single responsibility with clear SRAM/stream interfaces, enabling hierarchical verification and synthesis

***

## Verification & Reference Tooling

The design is accompanied by a structured verification plan and software reference models.

Key components:
- Matlab scripts for Gaussian kernel generation and convolution on sample images, used to derive expected blurred outputs.  
- Python/Matlab tooling to run FAST, NMS, and visualization on reference images and to compare them with Questasim RTL dumps.  
- Testbenches per module (e.g., `flexcounterdir`, `getpixel`, `srammodel`, Gaussian modules, FAST pixel iterator) that stress-reset behavior, edge cases, and mid-stream parameter changes.

This layered verification approach makes each module verifiable in isolation and then in full-chain integration, reducing debugging effort as features are added.

***

<p align="center">
  <!-- Space for verification waveforms / side-by-side RTL vs Matlab screenshots -->
</p>
