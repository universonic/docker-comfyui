#!/usr/bin/env bash

pushd /app/comfyui
source venv/bin/activate
python3 main.py "$@"
popd
