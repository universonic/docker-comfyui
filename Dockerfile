FROM nvidia/cuda:12.1.1-base-ubuntu22.04 as minimal

COPY entrypoint.sh /app/entrypoint.sh

RUN apt update && \
    apt install -y python3 python3-pip python3-venv git wget libgl1-mesa-dev libglib2.0-0 libsm6 libxrender1 libxext6 libgoogle-perftools4 libtcmalloc-minimal4 libcusparse11 && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd -g 1000 comfyui && \
    useradd -m -s /bin/bash -u 1000 -g 1000 --home /app comfyui && \
    ln -s /app /home/comfyui && \
    chown -R comfyui:comfyui /app && \
    chmod +x /app/entrypoint.sh

USER comfyui
WORKDIR /app

RUN git clone https://github.com/comfyanonymous/ComfyUI.git comfyui

WORKDIR /app/comfyui


FROM minimal as nvidia

RUN python3 -m venv venv && \
    . venv/bin/activate && \
    pip install torch torchvision torchaudio timm simpleeval accelerate --extra-index-url https://download.pytorch.org/whl/cu121 && \
    pip install -r requirements.txt

VOLUME /app/comfyui/output
VOLUME /app/comfyui/input
VOLUME /app/comfyui/models/checkpoints
VOLUME /app/comfyui/models/clip
VOLUME /app/comfyui/models/clip_vision
VOLUME /app/comfyui/models/controlnet
VOLUME /app/comfyui/models/diffusers
VOLUME /app/comfyui/models/embeddings
VOLUME /app/comfyui/models/gligen
VOLUME /app/comfyui/models/hypernetworks
VOLUME /app/comfyui/models/loras
VOLUME /app/comfyui/models/photomaker
VOLUME /app/comfyui/models/style_models
VOLUME /app/comfyui/models/unet
VOLUME /app/comfyui/models/upscale_models
VOLUME /app/comfyui/models/vae
VOLUME /app/comfyui/models/vae_approx

EXPOSE 8188

ENTRYPOINT ["/app/entrypoint.sh", "--listen", "0.0.0.0", "--port", "8188", "--preview-method", "auto"]
