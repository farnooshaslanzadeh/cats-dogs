#!/bin/sh

exec java -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -jar /worker-jar-with-dependencies.jar
