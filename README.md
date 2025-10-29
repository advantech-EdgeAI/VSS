# Title: VSS (Video-Search-and-Summarization) - A Video Analytics AI Agents at the Edge

Unlock insights from petabytes of visual data with video analytics AI
agents on NVIDIA Jetson Thor

## Demo Overview

The NVIDIA VSS (Video search and summarizatio) provides
developers with the reference architecture to build and deploy video
analytics AI agents to perform contextualized video summarization, Q&A,
and real-time alerts by analyzing large quantities of live camera stream
and recorded video.

## VSS Key Points

-   VSS enables AI agents across all industries

-   4 main capabilities including 
    > Summarization, Q&A, Event Verification, Low Latency Alerts

-   A new feature in 2.4 allows VSS to be used as an intelligent add-on to any computer vision pipeline for event verification.

-   An enterprise co-pilot to automate collection + understanding of analytics

-   We have examples of VSS partner applications for smart cities, warehouses, and live broadcasting.

-   Deploy on the edge (Jetson Thor in this case).


## 
## Technical Details 

The demo consists of two main parts-

1)  Computer Vision Pipeline

2)  VSS

The computer vision pipeline is an example DeepStream detection pipeline
using GroundDino that will take in a video, run detection and then
output clips when the number of detected objects is greater than a set
threshold. The purpose of this pipeline is to find the most important
events from the video that need to be inspected by VSS with a Vision
Language Model.

VSS will then process each small clip using the VLM Cosmos Reason 1.1 by
answering a set of yes/no questions defined by the user. These responses
are converted to True/False states for each question and can be used to
generate low latency alerts to a user. In this demo they will be
displayed on a web dashboard. Once the short clip has been processed by
VSS, you can ask more detailed follow questions.

When the demo is launched, there will be two web UIs to interact with
it. One Web UI will control the detection pipeline to generate clips of
interest from the input video and the other will be the VSS UI to
receive the VLM based alerts and insights on the short clips.

## Setup & Installation

**Software Setup**

After flashing your Thor, if JetPack is not already installed, then install through apt.

```bash
sudo apt update
sudo apt install
nvidia-jetpack
```

Then configure docker to run without sudo.

```bash
sudo usermod -aG docker $USER
newgrp docker
```

Download all demo content, and place them into ~/vss_demo_downloads folder.

```bash
mkdir -p ~/vss_demo_downloads
sudo docker run --name share-volume-vss ispsae/share-volume-vss
sudo docker cp share-volume-vss:/data/. ~/vss_demo_downloads

```

Load the docker images

```bash
docker load -i ~/vss_demo_downloads/alert-inspector-ui.tar.gz
docker load -i ~/vss_demo_downloads/cv-ui.tar.gz
docker load -i ~/vss_demo_downloads/nv-cv-event-detector.tar.gz
docker load -i ~/vss_demo_downloads/via-engine.tar.gz
```

Setup the demo folder and Cosmos-Reason model

```bash
tar -xzf ~/vss_demo_downloads/vss_demo.tar.gz -C ~/
tar -xzf ~/vss_demo_downloads/Cosmos-Reason1.1-7B.tar.gz -C ~/vss_demo/models/
```

Inside the ~/vss_demo folder is a .env. Open this file and verify the
MODEL_ROOT_DIR and MODEL_PATH environment variables are pointing to
valid paths to access the Cosmos-Reason1.1-7B model weights. No change
is needed if your user is set to "ubuntu".

### Launching the demo

Docker compose will be used to run the demo. This will bring up all the
containers to run the web UIs, computer vision pipeline and VSS.

```bash
cd ~/vss_demo
docker compose up
```

It may take 15-20 minutes to fully load the demo the first time it is launched.

Once the CV UI has launched, the demo should be fully loaded. Check your terminal output for the following lines to verify the CV UI has launched.

```
cv-ui-1                 | *Running on local URL:  <http://0.0.0.0:7862>
cv-ui-1                 |* To create a public link, set `share=True` in `launch()`.
via-server-1            | INFO:     127.0.0.1:47148 - "GET /health/live HTTP/1.1" 200 OK
nv-cv-event-detector-1  | INFO:     127.0.0.1:47026 - "GET /health HTTP/1.1" 200 OK
```

### Running the demo

Two web UIs are used to interact with the demo. These web UIs can be
accessed directly from the Thor through a web browser or from a separate
system connected to the same network.

----------------------------------
##### CV UI - http://\<jetson_ip\>:7862/
----------------------------------- 
##### VSS UI - http://\<jetson_ip\>:7860/
-----------------------

