FROM botwayorg/botway:latest AS bw

COPY . .

RUN botway init --docker

FROM crystallang/crystal:nightly-alpine

ENV PACKAGES "build-dependencies build-base gcc git libsodium opus ffmpeg"

RUN apk update && \
	apk add --no-cache --virtual ${PACKAGES}

# Add packages you want
# RUN apk add PACKAGE_NAME

COPY --from=bw /root/.botway /root/.botway

COPY . .

RUN shards install --production -v

ENTRYPOINT [ "crystal", "run", "src/main.cr" ]
