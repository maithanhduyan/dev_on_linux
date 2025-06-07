# dev_on_linux
Dev on Linux
Dưới đây là bộ cấu hình bao gồm `docker-compose.yml`, `Dockerfile`, và `.devcontainer.json` để tạo một môi trường phát triển ứng dụng giả lập Linux sử dụng **Ubuntu 24.04**.

---

### 📄 `docker-compose.yml`

```yaml
version: "3.8"

services:
  dev:
    build:
      context: .
      dockerfile: Dockerfile
    volumes:
      - .:/workspace:cached
    command: sleep infinity
    tty: true
```

---

### 📄 `Dockerfile`

```Dockerfile
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

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /workspace
```

---

### 📄 `.devcontainer.json`

```json
{
  "name": "Ubuntu 24.04 Dev",
  "dockerComposeFile": "docker-compose.yml",
  "service": "dev",
  "workspaceFolder": "/workspace",
  "settings": {
    "terminal.integrated.defaultProfile.linux": "bash"
  },
  "extensions": [
    "ms-vscode.cpptools",
    "ms-azuretools.vscode-docker",
    "esbenp.prettier-vscode"
  ],
  "postCreateCommand": "echo 'Welcome to Ubuntu 24.04 Dev Container!'"
}
```

---

## 🚀 Hướng dẫn sử dụng

### 📋 Yêu cầu hệ thống
- Docker Desktop (đã cài đặt và chạy)
- VS Code với extension Dev Containers
- Git (tùy chọn)

### 🛠️ Cách 1: Sử dụng với VS Code Dev Containers (Khuyến nghị)

1. **Chuẩn bị dự án:**
   ```bash
   git clone <repository-url>
   cd dev_on_linux
   ```
   hoặc tạo thư mục mới và copy các file cấu hình vào.

2. **Cài đặt extension:**
   - Mở VS Code
   - Cài đặt extension [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

3. **Khởi chạy container:**
   - Mở thư mục dự án trong VS Code
   - Nhấn `Ctrl+Shift+P` (hoặc `Cmd+Shift+P` trên Mac)
   - Chọn "Dev Containers: Reopen in Container"
   - Chờ container build và khởi động

### 🐳 Cách 2: Sử dụng Docker Compose

1. **Build và chạy container:**
   ```bash
   # Build image
   docker-compose build

   # Chạy container
   docker-compose up -d

   # Truy cập vào container
   docker-compose exec dev bash
   ```

2. **Dừng container:**
   ```bash
   docker-compose down
   ```

### 💻 Cách 3: Sử dụng Docker trực tiếp

1. **Build image:**
   ```bash
   docker build -t dev-on-linux .
   ```

2. **Chạy container:**
   ```bash
   docker run -it --rm -v ${PWD}:/workspace dev-on-linux
   ```

### 📦 Tính năng có sẵn

✅ **Môi trường phát triển hoàn chỉnh:**
- Ubuntu 24.04 LTS
- Build tools (gcc, make, cmake)
- Text editors (vim, nano)
- Version control (git)
- Network tools (curl, wget)

✅ **User không phải root:**
- Username: `devuser`
- Sudo privileges
- UID/GID: 1000 (tương thích với hầu hết hệ thống)

✅ **Volume mounting:**
- Code của bạn được mount vào `/workspace`
- Thay đổi được đồng bộ real-time

### 🔧 Tùy chỉnh môi trường

Để thêm các công cụ khác (Python, Node.js, etc.), chỉnh sửa `Dockerfile`:

```dockerfile
# Thêm vào phần RUN apt-get install
RUN apt-get update && apt-get install -y \
    # ...existing packages... \
    python3 \
    python3-pip \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*
```

### 🆘 Xử lý sự cố

**Container không khởi động được:**
- Kiểm tra Docker Desktop đã chạy chưa
- Thử rebuild: `docker-compose build --no-cache`

**Lỗi permission:**
- Đảm bảo Docker có quyền truy cập thư mục dự án
- Trên Windows: Enable file sharing trong Docker Desktop

**Extension không hoạt động:**
- Cài lại Dev Containers extension
- Restart VS Code

### 📚 Tài liệu tham khảo
- [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)
- [Docker Compose](https://docs.docker.com/compose/)
- [Ubuntu 24.04 Documentation](https://ubuntu.com/)
