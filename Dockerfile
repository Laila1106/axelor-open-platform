# Stage 1: Build the application using Gradle
FROM gradle:7.6.1-jdk11 AS build

WORKDIR /home/gradle/project

# Copie des fichiers de configuration nécessaires
COPY settings.gradle build.gradle gradle.properties version.gradle version.txt ./
COPY gradle ./gradle

# Copie du code source
COPY axelor-common ./axelor-common
COPY axelor-core ./axelor-core
COPY axelor-front ./axelor-front
COPY axelor-gradle ./axelor-gradle
COPY axelor-test ./axelor-test
COPY axelor-tomcat ./axelor-tomcat
COPY axelor-tools ./axelor-tools
COPY axelor-web ./axelor-web
COPY buildSrc ./buildSrc
COPY changelogs ./changelogs
COPY documentation ./documentation
# Nettoyage manuel des dossiers build (souvent résout les erreurs de ZIP corrompu)
RUN rm -rf /home/gradle/project/**/build
# Construction de l’application sans exécuter les tests
RUN gradle clean build -x test --no-daemon --warning-mode all --refresh-dependencies --no-parallel
# Stage 2: Image légère pour l'exécution
FROM openjdk:11-jre-slim

WORKDIR /app

# Copie du fichier JAR généré
COPY --from=build /home/gradle/project/axelor-core/build/libs/axelor-core.jar ./axelor-core.jar

# Exposition du port
EXPOSE 8080

# Commande de lancement
ENTRYPOINT ["java", "-jar", "axelor-core.jar"]
