FROM ros:noetic
#SHELL ["/bin/bash"]
LABEL maintainer="iory ab.ioryz@gmail.com"

ENV ROS_DISTRO noetic
ENV CATKIN_WS=/root/catkin_ws
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

RUN apt -q -qq update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    software-properties-common \
    wget \
    curl \
    git \
    neovim \
    apt-transport-https

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE \
    && add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u
# RUN add-apt-repository -y "deb https://librealsense.intel.com/Debian/apt-repo xenial main"
RUN apt-get update -qq
RUN apt-get install librealsense2-dkms --allow-unauthenticated -y
RUN apt-get install librealsense2-dev --allow-unauthenticated -y

RUN apt -q -qq update && \
  DEBIAN_FRONTEND=noninteractive apt install -y --allow-unauthenticated \
  python3-rosinstall \
  python3-catkin-tools \
  ros-${ROS_DISTRO}-jsk-tools \
  ros-${ROS_DISTRO}-rgbd-launch \
  ros-${ROS_DISTRO}-image-transport-plugins \
  ros-${ROS_DISTRO}-image-transport \
  ros-${ROS_DISTRO}-aruco-ros

RUN rosdep update

RUN mkdir -p /catkin_ws/src && cd /catkin_ws/src && \
  git clone --depth 1 -b ros1-legacy https://github.com/IntelRealSense/realsense-ros.git && \
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

#COPY rs_camera_and_aruco.launch /catkin_ws/src/realsense-ros/realsense2_camera/launch/
WORKDIR   /catkin_ws/src/realsense-ros/realsense2_camera/launch/
RUN wget https://raw.githubusercontent.com/gaspersavle/realsense-utils/main/rs_camera_and_aruco.launch
RUN chmod +x rs_camera_and_aruco.launch


WORKDIR /
#RUN wget https://raw.githubusercontent.com/gaspersavle/realsense-utils/main/ros_entrypoint.sh
#RUN wget https://github.com/gaspersavle/basler-calibs/blob/master/entrypoint.sh
RUN curl https://raw.githubusercontent.com/gaspersavle/realsense-utils/main/ros_entrypoint.sh -O
RUN chmod +x /ros_entrypoint.sh
RUN echo "source /ros_entrypoint.sh" >> /root/.bashrc
#WORKDIR /catkin_ws

#COPY ./ros_entrypoint.sh /
ENTRYPOINT ["/ros_entrypoint.sh"]

CMD ["bash"]
