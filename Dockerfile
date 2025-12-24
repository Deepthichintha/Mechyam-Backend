# Stage 1 — Build the application
FROM maven:3.9.4-eclipse-temurin-17 AS build

# Set working directory
WORKDIR /app

# Copy maven config and project files
COPY pom.xml .
COPY .mvn/ .mvn/
COPY mvnw .
RUN chmod +x mvnw

# Download dependencies only (caching benefit)
RUN mvn dependency:go-offline -B

# Copy full source code
COPY src ./src

# Build the application (creates jar)
RUN mvn clean package -DskipTests

# Stage 2 — Run the application
FROM eclipse-temurin:17-alpine

# Create app dir
WORKDIR /app

# Copy the jar from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port that your app runs on (change if different)
EXPOSE 8080

# Run the JAR
ENTRYPOINT ["java","-jar","/app/app.jar"]
