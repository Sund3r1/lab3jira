#!/bin/bash

# Скрипт для проверки здоровья деплоя
set -e

ENVIRONMENT=$1
SERVICE_NAME="ci-cd-demo-service-$ENVIRONMENT"
NAMESPACE=$ENVIRONMENT
TIMEOUT=300
INTERVAL=10

if [ -z "$ENVIRONMENT" ]; then
    echo "Usage: $0 <environment>"
    exit 1
fi

echo "Checking health of deployment in $ENVIRONMENT..."

START_TIME=$(date +%s)
while true; do
    CURRENT_TIME=$(date +%s)
    ELAPSED_TIME=$((CURRENT_TIME - START_TIME))
    
    if [ $ELAPSED_TIME -gt $TIMEOUT ]; then
        echo "Health check timeout after $TIMEOUT seconds!"
        exit 1
    fi
    
    # Проверяем статус deployment
    DEPLOYMENT_STATUS=$(kubectl get deployment ci-cd-demo-$ENVIRONMENT -n $NAMESPACE -o jsonpath='{.status.conditions[?(@.type=="Available")].status}' 2>/dev/null || echo "Unknown")
    
    if [ "$DEPLOYMENT_STATUS" = "True" ]; then
        echo "Deployment is healthy and available!"
        
        # Получаем URL для проверки
        if [ "$ENVIRONMENT" = "staging" ]; then
            echo "Staging URL: http://staging.demo.example.com"
        elif [ "$ENVIRONMENT" = "production" ]; then
            SERVICE_IP=$(kubectl get service $SERVICE_NAME -n $NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "")
            if [ -n "$SERVICE_IP" ]; then
                echo "Production URL: http://$SERVICE_IP"
            fi
        fi
        exit 0
    fi
    
    echo "Waiting for deployment to become available... (${ELAPSED_TIME}s elapsed)"
    sleep $INTERVAL
done
