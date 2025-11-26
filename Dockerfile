# ÉTAPE 1 : Construction (Utilisation de Maven pour compiler avec JDK 11)
# NOUVELLE LIGNE (tag standard pour Maven avec JDK 11)
#FROM maven:3.8.7-jdk-11 AS build
# OU, pour plus de fiabilité et si vous n'avez pas besoin de la version Maven spécifique :
FROM maven:3-jdk-11 AS build
# Définir le répertoire de travail
WORKDIR /app
# Copier les fichiers de construction
COPY pom.xml .
# Télécharger les dépendances pour une meilleure mise en cache
RUN mvn dependency:go-offline
# Copier tout le code source
COPY . .
# Construire l'application Spring Boot (crée le JAR dans target/)
# Assurez-vous que votre pom.xml utilise aussi <java.version>11</java.version>
RUN mvn clean package -DskipTests

# --------------------------------------------------------------------

# ÉTAPE 2 : Exécution (Image légère contenant uniquement Java Runtime 11 et le JAR)
# openjdk:11-jre-slim est plus léger et suffisant pour l'exécution
FROM openjdk:11-jre-slim-buster
# Définir la variable d'environnement PORT (utilisée par Spring Boot)
ENV PORT 8081
# Exposer le port par défaut de Spring Boot
EXPOSE 8081
# Copier le JAR construit depuis l'étape de construction
COPY --from=build /app/target/*.jar app.jar
# Commande de démarrage
ENTRYPOINT ["java", "-jar", "app.jar"]