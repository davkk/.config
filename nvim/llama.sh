#!/usr/bin/env bash

llama-server \
    --hf-repo ggml-org/Qwen2.5-Coder-0.5B-Q8_0-GGUF \
    --hf-file qwen2.5-coder-0.5b-q8_0.gguf \
    --n-gpu-layers 999 \
    --batch-size 1024 \
    --ubatch-size 512 \
    --flash-attn on \
    --cache-reuse 256 \
    --port 8012
