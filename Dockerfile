FROM openjdk:17-slim AS build

WORKDIR /app

COPY . /app

RUN ./gradlew assemble

FROM alpine:3.21

RUN apk add --no-cache openjdk17 gettext

ENV TRACCAR_VERSION=6.6
ENV DB_HOST=db
ENV DB_PORT=3306
ENV DB_USER=traccar
ENV DB_PASSWORD=traccar

WORKDIR /app

COPY --from=build /app /app
COPY conf/traccar.xml.template /app/conf/traccar.xml.template
COPY entrypoint.sh /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh

EXPOSE 8082

ENTRYPOINT ["/app/entrypoint.sh"]
