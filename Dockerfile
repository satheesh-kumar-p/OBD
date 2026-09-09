# syntax=docker/dockerfile:1.7

# ==========================================
# STAGE 1: Development & Build
# ==========================================
FROM --platform=$TARGETPLATFORM debian:bookworm AS development

ARG BUILDPLATFORM
ARG TARGETPLATFORM
ARG TARGETARCH

# Build arguments for app metadata
ARG APP_NAME=scout_obd
ARG APP_VERSION=dev

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

WORKDIR /app

# ------------------------------------------------
# Cache dependencies
# ------------------------------------------------
COPY pubspec.* ./
RUN flutter pub get

# ------------------------------------------------
# Copy application & Build with Dart Defines
# ------------------------------------------------
COPY . .

RUN flutter build linux --release \
    --dart-define=APP_NAME=${APP_NAME} \
    --dart-define=APP_VERSION=${APP_VERSION}

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
    mkdir -p /bundle; \
    cp -a build/linux/${BUILD_DIR}/release/bundle/. /bundle/


# ==========================================
# STAGE 2: Production Runtime
# ==========================================
FROM debian:bookworm-slim AS production

ARG APP_NAME=scout_obd
ARG APP_VERSION=dev

ENV APP_NAME=${APP_NAME}
ENV APP_VERSION=${APP_VERSION}

LABEL org.opencontainers.image.title="${APP_NAME}" \
      org.opencontainers.image.version="${APP_VERSION}"

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
    docker.io \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m appuser
WORKDIR /app

# Copy application bundle
COPY --from=development /bundle/ .

# GUI configuration
ENV GDK_BACKEND=wayland
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

RUN chown -R appuser:appuser /app

USER appuser

CMD ["./scout_display", "fullscreen"]