# eTAPE 1 : Construction (Utilisation de Maven pour compiler avec JDK 11)
#FROM eclipse-temurin:11-jdk-focal AS build
FROM maven:3.9-jdk-11 AS build
# Definir le repertoire de travail
WORKDIR /app
# Copier les fichiers de dependance dabord (pour le cache Docker)
COPY pom.xml .
# Copier tout le code source
COPY . .
# Construire lapplication Spring Boot (cr le JAR dans target/)
RUN mvn clean package -DskipTests
# --------------------------------------------------------------------
# eTAPE 2 : Execution (Image legere contenant uniquement Java Runtime 11 et le JAR)
FROM eclipse-temurin:11-jre-focal
# Definir la variable denvironnement PORT (utilisee par Spring Boot)
ENV PORT 8081
# Exposer le port par defaut de Spring Boot
EXPOSE 8081
# Copier le JAR construit depuis letape de construction
COPY --from=build /app/target/*.jar app.jar
# Commande de dmarrage
ENTRYPOINT ["java", "-jar", "app.jar"]