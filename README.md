# Intorduction into Using Micronaut with GraalVM Native Image

## Getting Started with Micronaut

Micronaut is a micro service / web Java framework that is able to target GraalVM native Image out of the box.

It is able to do this because it doesn't rely on reflection or dynamic class loading to configure applications. The link below goes into a detail about how Micronaut acheives this:

[Micronaut for GraalVM](https://docs.micronaut.io/latest/guide/index.html#graal)

These choices are not only great for Native Image, they also make your Java app faster :)

You can create a Micronaut projet that is designed to produce a native image using the tooling supplied by micronaut:

```
$ mn create-app hello-world --features graal-native-image
```

That is how I created this project. Some things to note:

1. They provide you witha Dockerfile to build and run the native image from within. This is a 2 step Dockerfile, the first step builds an environment that can build the native image and then builds it, and the second step is a lightweight runtime container with the native image in it. This is what will get run.
2. The Dockerfile they generate uses a Community Edition of GraalVM. You don't need to stick with this. We will soon have Enterprise Edition images on Docker Hub, you can use these or create your own!

The process for building is as follows:

```
./gradlew assemble
./docker-build.sh
# Note the -d, if you dont do this it will be hard to get your terminal back!
docker run -d --rm -p 8080:8080 krf-app
curl http://localhost:8080/
# kill the container with docker stop
```

Try out the above app running it is a Java app and as native image:

```
# What start up time does Micronaut report?
java -jar ./build/libs/krf-app-0.1-all.jar

# Compare this with starting a native image in the container, note that the container itself has an associated startup time
docker run --rm -d -p 8080:8080 krf-app
```

We can also just build the native image locally.

```
$ native-image --no-server --class-path ./build/libs/krf-app-0.1-all.jar
```

Try the startup times now.

## Library Support

Everything within the core Micronaut libraries should work with GraalVM, but for libraries that you will use you need to make sure that they work with native image.

Mor and more libraries are doing this, by providing native image specific configuration, but for those that don't we need to look to provide specific configuration (think reflection json files etc that are generated with the tracing agent).

For some libraires other fixes need to supply.

An excellent blog post that looks at just this issue, with netty, is:

[Instant Netty Startup using GraalVM Native Image Generation](https://medium.com/graalvm/instant-netty-startup-using-graalvm-native-image-generation-ed6f14ff7692)

## A More Complete Example

The github repo below was developed outside of Oracle, but shows a fairly complete, if simple, GraalVM + Micronaut example. The app supports talking to a DB, grafana etc.

[Mongonaut](https://github.com/dekstroza/mongonaut)

