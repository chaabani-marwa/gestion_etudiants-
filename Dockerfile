# ÉTAPE 1 : Construction (Utilisation de Maven pour compiler)
FROM maven:3.8.7-openjdk-17 AS build
# Définir le répertoire de travail
WORKDIR /app
# Copier les fichiers de construction (pom.xml) et télécharger les dépendances
COPY pom.xml .
RUN mvn dependency:go-offline
# Copier tout le code source
COPY . .
# Construire l'application Spring Boot (crée le JAR dans target/)
RUN mvn clean package -DskipTests

# --------------------------------------------------------------------

# ÉTAPE 2 : Exécution (Image légère contenant uniquement Java Runtime et le JAR)
FROM openjdk:17-jdk-slim
# Définir la variable d'environnement PORT (utilisée par Spring Boot)
ENV PORT 8081
# Exposer le port par défaut de Spring Boot
EXPOSE 8081
# Copier le JAR construit depuis l'étape de construction
COPY --from=build /app/target/*.jar app.jar
# Commande de démarrage
ENTRYPOINT ["java", "-jar", "app.jar"]