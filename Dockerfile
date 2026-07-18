# syntax=docker/dockerfile:1.7

# ==========================================
# STAGE 1: Development & Build
# ==========================================
FROM --platform=$BUILDPLATFORM debian:bookworm AS development

ARG BUILDPLATFORM
ARG TARGETPLATFORM
ARG TARGETARCH

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    liblzma-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------
# Install Flutter
# ------------------------------------------------
RUN git clone --depth 1 -b stable https://github.com/flutter/flutter.git /flutter

ENV PATH="/flutter/bin:${PATH}"

RUN flutter --version

WORKDIR /app

# ------------------------------------------------
# Cache dependencies
# ------------------------------------------------
COPY pubspec.* ./
RUN flutter pub get

# ------------------------------------------------
# Copy application
# ------------------------------------------------
COPY . .

# ------------------------------------------------
# Build Flutter application
# ------------------------------------------------
RUN flutter build linux --release

RUN find build/linux -maxdepth 3 -type d

# ------------------------------------------------
# Select the correct bundle explicitly
# ------------------------------------------------
RUN set -eux; \
    case "${TARGETARCH}" in \
        amd64) BUILD_DIR="x64" ;; \
        arm64) BUILD_DIR="arm64" ;; \
        *) echo "Unsupported architecture: ${TARGETARCH}"; exit 1 ;; \
    esac; \
    echo "Target Architecture : ${TARGETARCH}"; \
    echo "Using Build Folder  : ${BUILD_DIR}"; \
    test -d build/linux/${BUILD_DIR}/release/bundle; \
    mkdir -p /bundle; \
    cp -a build/linux/${BUILD_DIR}/release/bundle/. /bundle/

# ==========================================
# STAGE 2: Production Runtime
# ==========================================
FROM debian:bookworm-slim AS production

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    libgtk-3-0 \
    libglib2.0-0 \
    libstdc++6 \
    libx11-6 \
    libasound2 \
    libwayland-client0 \
    libwayland-cursor0 \
    libwayland-egl1 \
    libegl1 \
    libgles2 \
    libgl1 \
    libgl1-mesa-dri \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m appuser

WORKDIR /app

# ------------------------------------------------
# Copy application bundle
# ------------------------------------------------
COPY --from=development /bundle/ .

# ------------------------------------------------
# GUI configuration
# ------------------------------------------------
ENV GDK_BACKEND=wayland
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

RUN chown -R appuser:appuser /app

USER appuser

CMD ["./scout_display", "fullscreen"]