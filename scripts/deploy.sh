#!/bin/bash

# Скрипт для деплоя в Kubernetes с подстановкой переменных
set -e

ENVIRONMENT=$1
VERSION=$2
IMAGE=$3
BUILD_NUMBER=$4

if [ -z "$ENVIRONMENT" ] || [ -z "$IMAGE" ]; then
    echo "Usage: $0 <environment> <version> <image> <build_number>"
    exit 1
fi

K8S_DIR="k8s/$ENVIRONMENT"

if [ ! -d "$K8S_DIR" ]; then
    echo "Environment directory $K8S_DIR not found!"
    exit 1
fi

echo "Deploying to $ENVIRONMENT..."
echo "Image: $IMAGE"
echo "Version: $VERSION"
echo "Build: $BUILD_NUMBER"

# Подготовка манифестов с подстановкой переменных
for file in $K8S_DIR/*.yaml; do
    if [ -f "$file" ]; then
        sed -e "s|{{IMAGE}}|$IMAGE|g" \
            -e "s|{{VERSION}}|$VERSION|g" \
            -e "s|{{BUILD_NUMBER}}|$BUILD_NUMBER|g" \
            "$file" | kubectl apply -f -
    fi
done

echo "Deployment to $ENVIRONMENT completed!"
