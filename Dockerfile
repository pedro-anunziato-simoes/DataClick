FROM maven:3.9.4-eclipse-temurin-17 as build
WORKDIR /app
COPY backEnd/ ./
RUN mvn clean package -DskipTests
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
CMD ["java", "-jar", "app.jar"]
