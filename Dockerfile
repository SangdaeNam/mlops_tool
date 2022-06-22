ARG UBUNTU_VERSION=20.04

FROM ubuntu:${UBUNTU_VERSION} as base

ENV LANG C.UTF-8
ARG PYTHON=python3
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ="Asia/Seoul"
ENV http_proxy="http://proxy-dmz.intel.com:912/"
ENV https_proxy="http://proxy-dmz.intel.com:912/"
ENV no_proxy="127.0.0.1,localhost,intel.com"

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y wget git && \
    apt-get install -y ninja-build && \
    apt-get install -y cmake && \
    apt-get install -y build-essential && \
    apt-get install -y g++ && \
    apt-get install -y --no-install-recommends --fix-missing \
    ${PYTHON} \
    ${PYTHON}-pip \
    ${PYTHON}-dev 

RUN wget https://registrationcenter-download.intel.com/akdlm/irc_nas/18487/l_BaseKit_p_2022.1.2.146.sh && \
    bash ./l_BaseKit_p_2022.1.2.146.sh

RUN ${PYTHON} -m pip --no-cache-dir install --upgrade \
    pip \
    setuptools \
    psutil \
    scipy \
    pandas \
    numpy 

# Some TF tools expect a "python" binary
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python

ARG IPEX_VERSION=1.11.0
ARG PYTORCH_VERSION=1.11.0+cpu
ARG TORCHAUDIO_VERSION=0.11.0
ARG TORCHVISION_VERSION=0.12.0+cpu
ARG TORCH_CPU_URL=https://download.pytorch.org/whl/cpu/torch_stable.html
ARG IPEX_URL=https://www.intel.com/content/dam/develop/external/us/en/documents/ipex/whl-stable.html

RUN \
    python -m pip install --no-cache-dir \
    torch==${PYTORCH_VERSION} torchvision==${TORCHVISION_VERSION} torchaudio==${TORCHAUDIO_VERSION} -f ${TORCH_CPU_URL} && \
    python -m pip install --no-cache-dir \
    intel_extension_for_pytorch==${IPEX_VERSION}

# RUN pip install impi_rt impi-devel intel-fortran-rt intel-opencl-rt dpcpp-cpp-rt intel-openmp mkl onednn-cpu-gomp onednn-devel-cpu-gomp oneccl-devel 

RUN \
    git clone https://github.com/intel/torch-ccl.git && cd torch-ccl && \
    git submodule sync && \
    git submodule update --init --recursive && \
    python setup.py install --user
