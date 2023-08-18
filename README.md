# Docker ROS container for Realsense d415/d435 cameras

This is a version of the ros-realsense docker that was modified for deployment usage with a container orchestration service, therefore it has been de-volumised. The launch/config/entrypoint files are stored in my personal github repo and will be made available on the reconcycle github page as soon as we come up with a sufficiently clean approach

 1. Connect d415 or d435 to your pc.

2. Change `ROS_MASTER_URI` and `ROS_IP` in the docker-compose.yml file.

3. Run `docker-compose up`.
