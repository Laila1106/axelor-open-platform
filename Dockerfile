# Étape 1 : Build avec JDK 11
FROM openjdk:11-jdk-slim AS builder

LABEL maintainer="Laila Belokda <ton-email@example.com>"

# Installer dépendances
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Cloner le code source d’Axelor
RUN git clone https://github.com/axelor/axelor-open-platform.git

WORKDIR /app/axelor-open-platform

# Build avec Gradle (sans tests)
RUN ./gradlew clean build -x test --no-daemon --no-parallel

# Étape 2 : Image finale allégée
FROM openjdk:11-jre-slim

# Dossier de déploiement
WORKDIR /opt/axelor

# Copier le WAR généré (si utilisé avec Tomcat ou autre)
COPY --from=builder /app/axelor-open-platform/build/libs/*.war ./axelor.war

EXPOSE 8080

CMD ["java", "-jar", "axelor.war"]
