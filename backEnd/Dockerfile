FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY . .
RUN chmod +x ./mvnw \
  && ./mvnw clean package -DskipTests
CMD ["java", "-jar", "target/DataClick-0.0.1-SNAPSHOT.jar"]
