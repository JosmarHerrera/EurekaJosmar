# ========= Etapa 1: Build con Maven =========
FROM maven:3.9.4-eclipse-temurin-17 AS build

WORKDIR /app

# Copiar POM y descargar dependencias
COPY pom.xml .
RUN mvn -q dependency:go-offline

# Copiar el código fuente
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa 2: Imagen ligera final
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

# Railway inyecta PORT
EXPOSE 8761

ENTRYPOINT ["sh", "-c", "java -jar app.jar --server.port=${PORT} --server.address=0.0.0.0"]
