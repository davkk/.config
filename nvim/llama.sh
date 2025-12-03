#!/usr/bin/env bash

llama-server \
    -hf ggml-org/Qwen2.5-Coder-0.5B-Q8_0-GGUF:Q8_0 \
    --n-gpu-layers 999 \
    --ctx-size 0 \
    --batch-size 2048 \
    --ubatch-size 1024 \
    --flash-attn on \
    --cache-reuse 32 \
    --port 8012
