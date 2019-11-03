#!/bin/bash

docker run --rm -it -v $(pwd):/code --workdir /code kperson/swift-5-dev /bin/bash -c "swift build --build-path .lambda-build -c release"