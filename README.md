# Docker ROS container for Realsense d415/d435 cameras

Most of the code is from [this repository](https://github.com/iory/docker-ros-realsense).

## Setup

1. Connect d415 or d435 to your pc.

2. Change `ROS_MASTER_URI` and `ROS_IP` in the docker-compose.yml file.

3. Run `docker-compose up -d`.