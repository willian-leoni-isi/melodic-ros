# Use a imagem base do ROS Melodic
FROM osrf/ros:melodic-desktop-full

ARG USER=user
ARG DEBIAN_FRONTEND=noninteractive

# Instalação de dependências
RUN apt-get update && \
    apt-get install -y apt-utils && \
    apt-get install -y curl && \
    apt-get install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential git && \
    rm -f /etc/ros/rosdep/sources.list.d/20-default.list && \
    rosdep init && \
    rosdep update && \
    apt-get install -y \
        ros-melodic-catkin \
        ros-melodic-navigation \
        ros-melodic-joint-state-controller \
        ros-melodic-gazebo-ros-control \
        ros-melodic-effort-controllers && \
    apt-get install -y x11-apps && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Definir o diretório de trabalho
WORKDIR /home/${USER}

# Criação do workspace dentro do novo diretório de trabalho
RUN mkdir -p /home/${USER}/ros_ws/src

# Clonagem dos repositórios dentro do novo workspace
RUN cd /home/${USER}/ros_ws/src && \
    git clone -b melodic http://git.ece.ufrgs.br/arc_odometry.git && \
    git clone -b melodic http://git.ece.ufrgs.br/twil.git && \
    git clone -b melodic http://git.ece.ufrgs.br/linearizing_controllers.git && \
    git clone -b melodic http://git.ece.ufrgs.br/linearizing_controllers_msgs.git

# Instalação das dependências e construção do workspace
RUN /bin/bash -c "source /opt/ros/melodic/setup.bash; \
    cd /home/${USER}/ros_ws && \
    rosdep install --from-paths src --ignore-src -r -y && \
    catkin_make"

# Adicionar o ambiente do ROS ao .bashrc
RUN echo "source /home/${USER}/ros_ws/devel/setup.bash" >> /home/${USER}/.bashrc

# Definir o diretório de trabalho padrão para o usuário
WORKDIR /home/${USER}

# Definir o comando padrão para iniciar um bash shell
CMD ["bash"]
