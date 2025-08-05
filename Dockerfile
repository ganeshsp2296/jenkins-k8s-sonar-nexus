FROM openjdk:17-jdk-slim

ARG JAR_FILE
COPY ${JAR_FILE} /app/myapp.jar

WORKDIR /app

ENTRYPOINT ["java", "-jar", "myapp.jar"]
