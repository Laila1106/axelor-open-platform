# Stage 1: Build the application using Gradle
FROM gradle:7.6.1-jdk11 AS build

WORKDIR /home/gradle/project

# Étape 1 : copier les fichiers nécessaires à la résolution des dépendances
COPY settings.gradle build.gradle gradle.properties version.gradle version.txt ./
COPY gradle gradle

# Étape 2 : copier les sources
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

# (Facultatif) Debug : afficher le contenu du répertoire
RUN ls -l /home/gradle/project

# Étape 3 : construire le projet
RUN gradle clean build -x test --no-daemon --stacktrace

# Stage 2: Runtime image
FROM openjdk:11-jre-slim

WORKDIR /app

# Copier le JAR construit
COPY --from=build /home/gradle/project/axelor-core/build/libs/axelor-core.jar ./axelor-core.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "axelor-core.jar"]
