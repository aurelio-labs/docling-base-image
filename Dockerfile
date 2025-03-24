FROM python:3.12-slim-bookworm

ENV GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no"
ENV DOCKER_BUILDKIT=1

LABEL org.opencontainers.image.source=https://github.com/aurelio-labs/docling-base-image

RUN apt-get update \
    && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    libgl1-mesa-glx \
    curl \
    wget \
    git \
    procps \
    tesseract-ocr  \
    build-essential \
    && apt-get clean


# Install Tesseract language data (english and osd)
RUN mkdir -p /usr/local/share/tessdata && \
    cd /usr/local/share/tessdata && \
    curl -O https://github.com/tesseract-ocr/tessdata/raw/main/eng.traineddata && \
    curl -O https://github.com/tesseract-ocr/tessdata/raw/main/osd.traineddata


# This will install torch with *only* cpu support
# Remove the --extra-index-url part if you want to install all the gpu requirements
# For more details in the different torch distribution visit https://pytorch.org/.
RUN pip install --no-cache-dir docling==2.28.0 --extra-index-url https://download.pytorch.org/whl/cpu \
    rapidocr-onnxruntime



ENV HF_HOME=/tmp/
ENV TORCH_HOME=/tmp/

# docling-tools models download
RUN docling-tools models download
# RUN python -c 'from deepsearch_glm.utils.load_pretrained_models import load_pretrained_nlp_models; load_pretrained_nlp_models(verbose=True);'
# RUN python -c 'from docling.pipeline.standard_pdf_pipeline import StandardPdfPipeline; StandardPdfPipeline.download_models_hf(force=True);'

# On container environments, always set a thread budget to avoid undesired thread congestion.
# Will set in the application
# ENV OMP_NUM_THREADS=4

# On container shell:
# > cd /root/
# > python minimal.py