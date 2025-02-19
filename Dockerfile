FROM openjdk:17-alpine AS build
WORKDIR /app

COPY . /app

RUN ./gradlew assemble

FROM openjdk:17-alpine

WORKDIR /app

COPY --from=build /app /app

CMD ["java", "-jar", "/app/target/tracker-server.jar"]

