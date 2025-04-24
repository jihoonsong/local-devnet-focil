#!/bin/bash

./gradlew distDocker

docker tag consensys/teku:develop teku-focil:latest
