FROM botwayorg/botway:alpine-glibc

RUN apk update && \
	apk add --no-cache --virtual build-dependencies build-base gcc git ffmpeg curl

# Add packages you want
# RUN apk add PACKAGE_NAME

COPY . .

RUN botway init --docker

RUN deno cache deps.ts

ENTRYPOINT ["deno", "run", "--allow-all", "main.ts"]
