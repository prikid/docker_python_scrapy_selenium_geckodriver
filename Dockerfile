# docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t prikid/docker_python_scrapy_selenium_geckodriver:alpine --push .

FROM --platform=$BUILDPLATFORM rust:alpine AS geckodriver
RUN apk add curl build-base \
    && GECKODRIVER_VERSION=`curl https://github.com/mozilla/geckodriver/releases/latest | grep -oE '[0-9]+.[0-9]+.[0-9]+'` \
    && wget https://github.com/mozilla/geckodriver/archive/refs/tags/v$GECKODRIVER_VERSION.tar.gz -O geckodriver.tar.gz \
    && tar -zxf geckodriver.tar.gz \
    && cd geckodriver-$GECKODRIVER_VERSION \
    && cargo build --release \
    && cp target/release/geckodriver /

FROM --platform=$BUILDPLATFORM python:3.9-alpine
ENV PYTHONUNBUFFERED=1 \
    WEBDRIVER_PATH="/usr/local/bin/geckodriver" \
    FIREFOX_BIN="/usr/bin/firefox"
COPY --from=geckodriver /geckodriver /usr/local/bin
RUN apk add --update --no-cache --virtual .build-deps g++ gcc libxml2-dev libxslt-dev libffi-dev \
    && apk add --no-cache libxslt \
    && pip install --no-cache-dir Scrapy selenium scrapy-selenium itemloaders itemadapter  \
    && apk del .build-deps