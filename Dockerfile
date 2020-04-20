FROM oracle/graalvm-ce:20.0.0-java8 as graalvm
# For JDK 11
#FROM oracle/graalvm-ce:20.0.0-java11 as graalvm
RUN gu install native-image

COPY . /home/app/krf-app
WORKDIR /home/app/krf-app

RUN native-image --no-server -cp build/libs/krf-app-*-all.jar

FROM frolvlad/alpine-glibc
RUN apk update && apk add libstdc++
EXPOSE 8080
COPY --from=graalvm /home/app/krf-app/krf-app /app/krf-app
ENTRYPOINT ["/app/krf-app"]
