#!/bin/bash
# Run vllm docker image - Quantized with AWQ
# 
# Author: Jason A. Cox,
# Date: 27-Jan-2024
# https://github.com/jasonacox/TinyLLM

#LLM=TheBloke/Mixtral-8x7B-Instruct-v0.1-AWQ
#CONTAINER=vllm-mixtral
#QT=auto
LLM=TheBloke/Mistral-7B-Instruct-v0.1-AWQ
CONTAINER=vllm-mistral-awq
QT=auto

echo "Stopping and removing any previous $CONTAINER instance..."
docker stop $CONTAINER
docker rm $CONTAINER

echo "Starting new $CONTAINER instance..."

docker run -d \
  -p 8000:8000 \
  --shm-size=10.24gb \
  --gpus all \
  -e MODEL=$LLM \
  -e PORT=8000 \
  -e GPU_MEMORY_UTILIZATION=0.95 \
  -e QUANTIZATION=awq \
  -e DTYPE=$QT \
  -e NUM_GPU=1 \
  -e SERVED_MODEL_NAME=tinyllm \
  -e HF_HOME=/app/models \
  -v ./models:/app/models \
  --restart unless-stopped \
  --name $CONTAINER \
  vllm

# Additional options: -e EXTRA_ARGS="" -e MAX_MODEL_LEN=xxxxx

echo "Printing logs (^C to quit)..."

docker logs $CONTAINER -f
