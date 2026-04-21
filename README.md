# Video Search and Summarization (VSS)

The NVIDIA VSS project provides a reference architecture for building and deploying intelligent video analytics AI agents on edge devices. This system allows you to manage large amounts of video data by providing summaries, answering questions about video content, and sending real-time alerts.

## Key Features

* **Video Summarization**: Automatically creates text summaries for long video files and live camera streams.
* **Natural Language Q&A**: Allows users to ask specific questions about what is happening in the video (e.g., "What color was the car that entered at 2 PM?").
* **Real-time Alerts**: Sends low-latency notifications based on user-defined events or "Yes/No" questions.
* **VLM Integration**: Uses the **Cosmos-Reason2** Vision Language Model (VLM) for deep visual understanding and reasoning.
* **Context-Aware RAG**: Employs a Retrieval-Augmented Generation (RAG) system with vector and graph databases to provide accurate and detailed answers.

## System Architecture

The system is built with two main pipelines that work together to process video data:

### 1. Ingestion Pipeline
This pipeline extracts visual information from the video.
* **Sampling**: The system samples frames from video chunks.
* **Captioning**: The VLM analyzes these frames to generate "dense captions" or scene descriptions.
* **Metadata**: If enabled, a computer vision pipeline (using Grounding DINO) adds object IDs and masks to the visual data to improve accuracy.

### 2. Retrieval Pipeline
This pipeline manages the information extracted by the ingestion process.
* **Indexing**: Captions and metadata are stored in vector and graph databases.
* **Processing**: When you request a summary or ask a question, the system retrieves relevant data from the databases.
* **Response Generation**: An LLM (Large Language Model) combines the retrieved information to produce a final summary or answer.

![](media/images/overview.png)

**Workflow**

1.  **Ingestion**: Video files or RTSP live streams are processed into small chunks.
2.  **Analysis**: The VLM generates detailed descriptions for every part of the video.
3.  **Storage**: These descriptions are indexed and stored for fast searching.
4.  **Interaction**: Users can generate a complete summary of the video or use the chat interface to gain specific insights.
5.  **Alerting**: The system monitors the video for specific events and triggers alerts immediately when those events are detected.

## Installation Guide

### 1. Install JetPack and Docker

```bash
# Install JetPack if needed
sudo apt update
echo -e '\nPackage: nvidia-l4t-*\nPin: version 38.2.0-20250821174705\nPin-Priority: 999' | sudo tee -a /etc/apt/preferences.d/nvidia-repo-pin
sudo apt install -y nvidia-jetpack
```

Follow [the guide](https://github.com/advantech-EdgeAI/VSS/issues/2) to install Docker.

### 2. Clone the Repository

```bash
git clone https://github.com/advantech-EdgeAI/VSS.git
cd VSS
```

### 3. Download Docker Images

Download all docker images at once.

```bash
# run the docker pull scripts
./docker-pull.sh
```

## Usage / Quick Start

### 1. Start the Application

##### First-Time VSS Setup

If this is your first time running VSS on your device, please connect to the internet and run the following commands:

```bash
export HF_HUB_OFFLINE=0
export TRANSFORMERS_OFFLINE=0
```

Next, open the `VSS/local_deployment_single_gpu/.env` file and uncomment the line to enable your Hugging Face token:

```bash
# export NGC_API_KEY=abc123*** #api key to pull model from NGC. Add this if you are not using the jupyter notebooks
# export NVIDIA_API_KEY="noapikeyset" #need a random string here to avoid bug in endpoint client library; actual key not needed as the endpoint is local
export HF_TOKEN=<your_hugging_face_token> # <- Uncomment and update this line with your token.

(remaining .env lines)
```
Once updated, follow the steps below to launch VSS.

> Once VSS has successfully run for the first time, you can safely remove your Hugging Face token from the `.env` file and comment out the line. VSS no longer requires Hugging Face access, allowing you to run the application entirely offline. 

##### Bring Up VSS

Go to VSS folder, and bring it up.

```bash
cd local_deployment_single_gpu/
docker compose up
```
Launch the entire pipeline using Docker Compose. 
Note that the first launch may take 5-6 minutes to fully load.

Check your terminal output. When you see the following logs, it shows VSS is ready.
```
via-server-1         | ***********************************************************
via-server-1         | VIA Server loaded
via-server-1         | Backend is running at http://0.0.0.0:8100
via-server-1         | Frontend is running at http://0.0.0.0:9100
via-server-1         | Press ctrl+C to stop
via-server-1         | ***********************************************************
```


### 2. Access the Web UI

A web interface is available to interact with the demo:

- **VSS UI (Full Function Version)**: `http://<jetson_ip>:9100/`

### 3. Stop VSS and Clean Out Cache Data

```bash
ctrl-c # stop vss
docker compose down
sudo ./sys_cache_cleaner.sh
# wait for 5 sec
ctrl-c # exit cleaner
```

## Troubleshooting

### Memory Issues

If you see errors about "KV cache" or "GPU memory utilization" when starting VSS, you need to change the `VLLM_GPU_MEMORY_UTILIZATION` value in your `.env` file.

This number (from `0.0` to `1.0`) tells the system how much GPU memory to reserve for the AI model. Default: `0.3` (30% of your GPU memory).

- If you see "KV cache memory not enough": 
    - Increase the value (e.g., change `0.3` to `0.4` or `0.5`). This gives the model more memory to work with.
- If you see "Free memory is less than desired":
    - Decrease the value (e.g., change `0.5` to `0.4` or `0.3`). This leaves more free space for the system to boot up.