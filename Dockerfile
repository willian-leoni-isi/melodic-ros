# Base image
FROM osrf/ros:melodic-desktop

# Instalação de dependências
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential git

# Criação do diretório do workspace
RUN mkdir -p /root/ros_ws/src

# Navegação para o diretório do workspace e execução do catkin_make
RUN /bin/bash -c "source /opt/ros/melodic/setup.bash && cd /root/ros_ws && catkin_make"

# Configuração do ambiente
RUN echo "source /root/ros_ws/devel/setup.bash" >> /root/.bashrc

# Defina o diretório de trabalho
WORKDIR /root/ros_ws

# Comando padrão ao iniciar o contêiner
CMD ["bash"]
