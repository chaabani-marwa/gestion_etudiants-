# ÉTAPE 1 : Construction (Utilisation de Maven pour compiler avec JDK 11)
# ÉTAPE 1 : Construction
# Utilisez le JDK 11 de Temurin pour la construction
FROM eclipse-temurin:11-jdk-focal AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY . .
RUN mvn clean package -DskipTests

# --------------------------------------------------------------------

# ÉTAPE 2 : Exécution (Image légère contenant uniquement Java Runtime 11 et le JAR)
# openjdk:11-jre-slim est plus léger et suffisant pour l'exécution
# ÉTAPE 2 : Exécution
# Utilisez le JRE 11 (plus léger) de Temurin pour l'exécution
FROM eclipse-temurin:11-jre-focal# <-- Ligne corrigée et robuste
ENV PORT 8081
EXPOSE 8081
COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]