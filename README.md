# ComfyUI
The most powerful and modular stable diffusion GUI and backend. This repository is for NVIDIA GPUs only.

For detailed command-line flags, see [Official instructions](https://github.com/comfyanonymous/ComfyUI).

## Usage

Basic example:
```
docker run --gpus all --restart unless-stopped -p 8188:8188 --name comfyui -d universonic/comfyui
```

Use SSL/TLS:
```
docker run --gpus all --restart unless-stopped -p 8188:8188 \
  -v /my/key.pem:/app/key.pem \
  -v /my/cert.pem:/app/cert.pem \
  --name comfyui -d universonic/comfyui --tls-keyfile /app/key.pem --tls-certfile /app/cert.pem
```

### Where to Store Data

It is recommended to create a data directory on the host system (outside the container) and mount this to a directory visible from inside the container. This places the data files (including: extensions, models, outputs, etc.) in a known location on the host system, and makes it easy for tools and applications on the host system to access the files. The downside is that the user needs to make sure that the directory exists, and that e.g. directory permissions and other security mechanisms on the host system are set up correctly. 

We will simply show the basic procedure here:
1. Create a data directory on a suitable volume on your host system, e.g. `/my/own/datadir`.
2. Start your `comfyui` container like this:
```
docker run --gpus all --restart unless-stopped -p 8188:8188 \
  -v /my/own/datadir/checkpoints:/app/comfyui/models/checkpoints \
  -v /my/own/datadir/output:/app/comfyui/output \
  -v /my/own/datadir/input:/app/comfyui/input \
  --name comfyui -d universonic/comfyui
```
3. Troubleshooting with the following command if you encountered problems:
```
docker logs -f comfyui
```

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
