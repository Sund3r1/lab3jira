# Мульти-стадийная сборка
FROM maven:3.8.4-openjdk-11 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# Финальный образ
FROM openjdk:11-jre-slim
WORKDIR /app

# Безопасность: создаем непривилегированного пользователя
RUN groupadd -r spring && useradd -r -g spring spring
USER spring:spring

COPY --from=builder /app/target/*.jar app.jar

# Метаданные
LABEL maintainer="demo@example.com"
LABEL version="1.0"
LABEL description="CI/CD Demo Application"

EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]
