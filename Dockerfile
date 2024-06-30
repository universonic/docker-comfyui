FROM nvidia/cuda:12.1.1-base-ubuntu22.04 as minimal

COPY entrypoint.sh /app/entrypoint.sh

RUN apt update && \
    apt install -y python3 python3-pip python3-venv git wget && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd -g 1000 comfyui && \
    useradd -m -s /bin/bash -u 1000 -g 1000 --home /app comfyui && \
    ln -s /app /home/comfyui && \
    chown -R comfyui:comfyui /app && \
    chmod +x /app/entrypoint.sh

USER comfyui
WORKDIR /app

RUN git clone https://github.com/comfyanonymous/ComfyUI.git comfyui && \
    cd comfyui && \
    python3 -m venv venv && \
    . venv/bin/activate && \
    pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121 && \
    pip install -r requirements.txt

VOLUME /app/output
VOLUME /app/temp
VOLUME /app/input

EXPOSE 8188

ENTRYPOINT ["/app/entrypoint.sh", "--listen", "0.0.0.0", "--port", "8188", "--preview-method", "auto", "--output-directory", "/app/output", "--temp-directory", "/app/temp", "--input-directory", "/app/input"]

