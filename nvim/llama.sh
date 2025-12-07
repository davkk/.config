#!/usr/bin/env bash

llama-server \
    -hf Qwen/Qwen2.5-Coder-0.5B-Instruct-GGUF:Q8_0 \
    --n-gpu-layers 99 \
    --ctx-size 0 \
    --batch-size 2048 \
    --ubatch-size 1024 \
    --flash-attn on \
    --mlock \
    --cache-reuse 32 \
    --port 8012
