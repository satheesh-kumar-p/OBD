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

# Install Flutter
RUN git clone --depth 1 -b stable https://github.com/flutter/flutter.git /flutter

ENV PATH="/flutter/bin:${PATH}"

RUN flutter --version

WORKDIR /app

# Cache dependencies
COPY pubspec.* ./
RUN flutter pub get

# Copy source
COPY . .

# Build Flutter application
RUN flutter build linux --release

# Normalize build output for all architectures
RUN mkdir -p /bundle && \
    cp -r build/linux/*/release/bundle/* /bundle/

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

# Copy normalized application bundle
COPY --from=development /bundle/ .

# GUI configuration
ENV GDK_BACKEND=wayland
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

RUN chown -R appuser:appuser /app

USER appuser

CMD ["./scout_display", "fullscreen"]