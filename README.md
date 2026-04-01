# VSS Event Reviewer

The NVIDIA VSS (Video Search and Summarization) Event Reviewer helps developers create smart video AI agents for edge devices. This project is specifically for the NVIDIA Jetson Thor.

On the Jetson Thor, the system focuses on Event Review. It acts as a smart assistant for your existing computer vision pipelines. It helps you check if detected events are real and provides fast alerts.

## Key Features

- **Local Event Review**: Uses a Vision Language Model (VLM) to check video clips directly on the device.
- **Yes/No Reasoning**: The system answers simple "Yes" or "No" questions about what is happening in the video.
- **Low Latency Alerts**: Provides fast notifications when the VLM confirms a specific event.
- **VLM Integration**: Specifically uses the Cosmos-Reason1 model for advanced visual reasoning.

## System Architecture

The project has two main parts that work together:

- **Computer Vision (CV) Pipeline**: This part uses tools like Grounding DINO to find objects. When it detects something important, it creates a short video clip of the event.
- **VSS Event Reviewer**: This part receives the video clip. It uses the VLM to answer your specific questions (for example: "Is the worker wearing a safety helmet?").

**Workflow**

1. **Detection**: The CV pipeline monitors the stream and finds "clips of interest" based on your rules.
2. **Verification**: VSS analyzes the clip and answers your "Yes/No" questions to verify the event.
3. **Alert**: If the VLM confirms the event, an alert is sent to the dashboard for you to see.

> [!NOTE]<!-- NOTE ALERT -->
> For more information about system architecture of VSS, please refer to Nvidia's official manual for [VSS 2.4.0](https://docs.nvidia.com/vss/2.4.0/).

<a href="https://youtu.be/sddRzZQ7aKM"><img src="./media/images/demo.gif"></a>

## Installation Guide

### 1. Prerequisites

Ensure JetPack and Docker are installed.

```bash
# Install JetPack if needed
sudo apt update
echo -e '\nPackage: nvidia-l4t-*\nPin: version 38.2.0-20250821174705\nPin-Priority: 999' | sudo tee -a /etc/apt/preferences.d/nvidia-repo-pin
sudo apt install -y nvidia-jetpack
```

Follow [the guide](https://github.com/advantech-EdgeAI/VSS/issues/2) to install Docker.

### 2. Download Essential Data

Create a directory for the demo and download the required container images and models.

```bash
# Create demo folder
mkdir -p ~/vss_demo_downloads

# Copy data from the shared volume (Example command)
sudo docker run --name share-volume-vss ispsae/share-volume-vss
sudo docker cp share-volume-vss:/data/. ~/vss_demo_downloads

# Load Docker images
docker load -i ~/vss_demo_downloads/alert-inspector-ui.tar.gz
docker load -i ~/vss_demo_downloads/cv-ui.tar.gz
docker load -i ~/vss_demo_downloads/nv-cv-event-detector.tar.gz
docker load -i ~/vss_demo_downloads/via-engine.tar.gz
```

### 3. Setup Demo Environment

Extract the demo scripts and model weights.

```bash
# Extract demo folder
tar -xzf ~/vss_demo_downloads/vss_demo.tar.gz -C ~/

# Extract Cosmos-Reason model
tar -xzf ~/vss_demo_downloads/Cosmos-Reason1.1-7B.tar.gz -C ~/vss_demo/models/
```

Note: Check the `.env` file in `~/vss_demo` to ensure `MODEL_ROOT_DIR` points to the correct path. No change is usually needed if the user is "ubuntu".

## Usage / Quick Start

### Start the Application

Launch the entire pipeline using Docker Compose. Note that the first launch may take 15-20 minutes to fully load.

```bash
cd ~/vss_demo
docker compose up
```

Check your terminal output. When you see `Running on local URL: http://0.0.0.0:7862`, the system is ready.

### Access the Web UI

Two web interfaces are available to interact with the demo:

- **CV UI (Control Pipeline)**: `http://<jetson_ip>:7862/`
    - Use this to generate clips of interest from the input video.
- **VSS UI (Insights & Alerts)**: `http://<jetson_ip>:7860/`
    - Use this to receive VLM-based alerts and ask detailed follow-up questions.