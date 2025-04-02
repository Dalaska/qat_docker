# Use the specified CUDA/cuDNN base image
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# Set up system environment
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    git \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh \
    && bash miniconda.sh -b -p /miniconda \
    && rm miniconda.sh

# Set up Conda and virtual environment
ENV PATH="/miniconda/bin:$PATH"
RUN conda create -y -n j6env python=3.10.0
ENV PATH="/miniconda/envs/j6env/bin:$PATH"

# Install PyTorch with CUDA 11.8
RUN pip install torch==2.3.0 torchvision==0.18.0 torchaudio==2.3.0 \
    --index-url https://download.pytorch.org/whl/cu118

# Install requirements and pycocotools
COPY requirements.txt .
RUN pip install -r requirements.txt 
#-i https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install pycocotools==2.0.3

# # Install Horizon packages
# COPY *.whl /tmp/
# RUN pip install /tmp/hbdk4_compiler-4.1.9-cp310-cp310-manylinux_2_17_x86_64.whl \
#     && pip install /tmp/horizon_tc_ui-3.3.4-cp310-cp310-linux_x86_64.whl \
#     && pip install /tmp/hmct_gpu-2.0.9-cp310-cp310-linux_x86_64.whl \
#     && pip install /tmp/horizon_plugin_pytorch-2.4.10+cu118.torch230-cp310-cp310-linux_x86_64.whl \
#     && pip install /tmp/hbdk4_runtime_x86_64_unknown_linux_gnu_nash-4.1.17-py3-none-any.whl \
#     && pip install /tmp/hbdnn-1.0.1-py3-none-any.whl \
#     && pip install /tmp/horizon_plugin_profiler-2.5.9-py3-none-any.whl

# # Cleanup
# RUN rm -rf /tmp/*.whl /var/lib/apt/lists/* /var/tmp/*

# Default command
CMD ["/bin/bash"]