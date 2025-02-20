FROM openjdk:17-slim AS build

WORKDIR /app

COPY . /app

RUN ./gradlew assemble

FROM openjdk:17-slim

ENV DB_HOST=db
ENV DB_PORT=3306
ENV DB_USER=traccar
ENV DB_PASSWORD=traccar

WORKDIR /app

COPY --from=build /app /app

CMD ["java", "-jar", "/app/target/tracker-server.jar", "/app/conf/traccar.xml"]
