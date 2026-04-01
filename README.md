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

## Quick Start Guide

### Prerequisites

Ensure JetPack and Docker are installed.

```bash
# Install JetPack if needed
sudo apt update
echo -e '\nPackage: nvidia-l4t-*\nPin: version 38.2.0-20250821174705\nPin-Priority: 999' | sudo tee -a /etc/apt/preferences.d/nvidia-repo-pin
sudo apt install -y nvidia-jetpack
```

Follow [the guide](https://github.com/advantech-EdgeAI/VSS/issues/2) to install Docker.

### Download docker images
Download all docker images at once.

```bash
# run the docker pull scripts
./docker-pull.sh
```

### Start the Application
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


### Access the Web UI

Two web interfaces are available to interact with the demo:
- **VSS UI (Full Function Version)**: `http://<jetson_ip>:9100/`

### Stop VSS and Clean out cache data
```bash
ctrl-c # stop vss
docker compose down
sudo ./sys_cache_cleaner.sh
# wait for 5 sec
ctrl-c # exit cleaner
```
