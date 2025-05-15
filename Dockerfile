# Stage 1: Build the application using Gradle official image
FROM gradle:7.6.1-jdk11 AS build

WORKDIR /home/gradle/project

# Copy only necessary files for dependency resolution first
COPY settings.gradle build.gradle gradle.properties version.gradle version.txt ./
COPY gradle gradle

# Copy all source code
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

# Build the project without running tests
RUN gradle clean build -x test --no-daemon --stacktrace

# Stage 2: Create a lightweight image for running the app
FROM openjdk:11-jre-slim

WORKDIR /app

# Copy the built jar from the build stage
COPY --from=build /home/gradle/project/axelor-core/build/libs/axelor-core.jar ./axelor-core.jar

# Expose the default port (adjust if needed)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "axelor-core.jar"]
