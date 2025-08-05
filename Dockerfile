FROM openjdk:17
COPY target/myapp-1.0.jar /app/myapp.jar
CMD ["java", "-jar", "/app/myapp.jar"]
