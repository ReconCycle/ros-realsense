FROM ros:kinetic

LABEL maintainer="iory ab.ioryz@gmail.com"

ENV ROS_DISTRO kinetic

RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

RUN apt -q -qq update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    software-properties-common \
    wget \
    apt-transport-https

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE \
    && add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u
# RUN add-apt-repository -y "deb https://librealsense.intel.com/Debian/apt-repo xenial main"
RUN apt-get update -qq
RUN apt-get install librealsense2-dkms --allow-unauthenticated -y
RUN apt-get install librealsense2-dev --allow-unauthenticated -y

RUN apt -q -qq update && \
  DEBIAN_FRONTEND=noninteractive apt install -y --allow-unauthenticated \
  python-rosinstall \
  python-catkin-tools \
  ros-${ROS_DISTRO}-jsk-tools \
  ros-${ROS_DISTRO}-rgbd-launch \
  ros-${ROS_DISTRO}-image-transport-plugins \
  ros-${ROS_DISTRO}-image-transport \
  ros-${ROS_DISTRO}-aruco-ros

RUN rosdep update

RUN mkdir -p /catkin_ws/src && cd /catkin_ws/src && \
  git clone https://github.com/IntelRealSense/realsense-ros.git && \
  cd realsense-ros && \
  git checkout tags/2.3.2
# RUN mkdir -p /catkin_ws/src && cd /catkin_ws/src && \
#   git clone --depth 1 -b ros1-legacy https://github.com/IntelRealSense/realsense-ros.git
RUN cd /catkin_ws/src && \
  git clone --depth 1 https://github.com/pal-robotics/ddynamic_reconfigure
RUN cd catkin_ws;
RUN mv /bin/sh /bin/sh_tmp && ln -s /bin/bash /bin/sh
RUN source /opt/ros/${ROS_DISTRO}/setup.bash; cd catkin_ws; catkin build -DCATKIN_ENABLE_TESTING=False -DCMAKE_BUILD_TYPE=Release
RUN rm /bin/sh && mv /bin/sh_tmp /bin/sh
RUN touch /root/.bashrc && \
  echo "source /catkin_ws/devel/setup.bash\n" >> /root/.bashrc && \
  echo "rossetip\n" >> /root/.bashrc && \
  echo "rossetmaster localhost"

RUN rm -rf /var/lib/apt/lists/*

COPY rs_camera_and_aruco.launch /catkin_ws/src/realsense-ros/realsense2_camera/launch/
COPY rs_camera.launch /catkin_ws/src/realsense-ros/realsense2_camera/launch/

COPY ./ros_entrypoint.sh /
ENTRYPOINT ["/ros_entrypoint.sh"]

CMD ["bash"]
