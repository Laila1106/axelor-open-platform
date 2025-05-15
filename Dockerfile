# Use OpenJDK 11 as base image
FROM openjdk:11-jdk-slim

# Set working directory inside the container
WORKDIR /app

# Copy Gradle wrapper and configuration files
COPY gradlew .
COPY gradle gradle
COPY settings.gradle .
COPY build.gradle .
COPY version.gradle .
COPY gradle.properties .

# Copy all project source code
COPY axelor-common axelor-common
COPY axelor-core axelor-core
COPY axelor-front axelor-front
COPY axelor-gradle axelor-gradle
COPY axelor-test axelor-test
COPY axelor-tomcat axelor-tomcat
COPY axelor-tools axelor-tools
COPY axelor-web axelor-web
COPY buildSrc buildSrc
COPY changelogs changelogs
COPY documentation documentation

# Make gradlew executable
RUN chmod +x gradlew

# Build the project using Gradle wrapper
RUN ./gradlew clean build -x test --no-daemon

# Expose the default port (adjust if needed)
EXPOSE 8080

# Set the entrypoint to run the application
CMD ["java", "-jar", "axelor-core/build/libs/axelor-core.jar"]
