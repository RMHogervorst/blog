---
title: Pytorch on an AMD gpu (frame.work 13)
description: This post describes how I got pytorch running on the (i)gpu of an amd computer. The frame.work 13.
subtitle: ""
date: 2024-03-12
preview: ""
draft: false
tags:
    - hardware
    - pytorch
categories:
    - blog
difficulty: advanced
post-type: walkthrough
share_img: ""
image: ""
type: default
---

I have a frame.work laptop. it is really nice! it looks awesome and is easily repairable. 
I chose an AMD type, which as an integated GPU. 
the [AMD Ryzen 7 7840U](https://www.notebookcheck.net/AMD-Ryzen-7-7840U-Processor-Benchmarks-and-Specs.716412.0.html)

You can actually use this GPU with pytorch!

But you need to perform a few steps, I write them down here for future use. (I'm using ubuntu on this device)

- allocate more VRAM to GPU with a bios setting [(go into bios and change setting GPU to gaming mode or something, see this link)](https://community.frame.work/t/vram-allocation-for-the-7840u-frameworks/36613/9
)
- start a virtual environment in your project
- install the right versions of pytorch packages; go to https://pytorch.org/get-started/locally/ and click the right versions together to make the correct link, I came out to `pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm5.7`
- set an env var to point pytorch in the right direction. in my case `export HSA_OVERRIDE_GFX_VERSION=11.0.0`

I don't think it is particularily fast, but using the gpu is often faster than cpu. 

## Will it run large deep learning models like LLMs?
According to this benchmark https://llm-tracker.info/howto/AMD-GPUs#bkmrk-amd-apu LLMs could be slightly faster than on cpu


## What about torch, for R?
It does not yet work for torch on R, see this issue https://github.com/mlverse/torch/issues/907
