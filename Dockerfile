# Sử dụng Ubuntu 24.04 làm base image
FROM ubuntu:24.04

# Cập nhật hệ thống và cài các công cụ cơ bản
RUN apt-get update && apt-get install -y \
    curl \
    git \
    vim \
    build-essential \
    sudo \
    locales \
    && locale-gen en_US.UTF-8

# Thiết lập môi trường
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Tạo người dùng không phải root để dev
ARG USERNAME=devuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME 2>/dev/null || true \
    && (useradd --uid $USER_UID --gid $USER_GID -m $USERNAME 2>/dev/null || \
        useradd -m $USERNAME 2>/dev/null || \
        usermod -d /home/$USERNAME -m $USERNAME 2>/dev/null || true) \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && usermod -aG sudo $USERNAME \
    && chown -R $USERNAME:$USERNAME /home \
    && chmod -R 755 /home

USER $USERNAME
WORKDIR /home/workspace
