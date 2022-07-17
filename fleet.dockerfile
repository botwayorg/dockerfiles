FROM botwayorg/botway:latest AS bw

COPY . .

RUN botway init --docker

FROM rust:alpine

ENV PACKAGES "build-dependencies build-base curl openssl openssl-dev musl-dev libressl-dev gcc git lld clang libsodium ffmpeg opus autoconf automake libtool m4 youtube-dl"

RUN apk update && \
	apk add --no-cache --virtual ${PACKAGES}

# Add packages you want
# RUN apk add PACKAGE_NAME

RUN set -eux; \
    apkArch="$(apk --print-arch)"; \
    case "$apkArch" in \
    x86_64) rustArch='x86_64-unknown-linux-musl' ;; \
    aarch64) rustArch='aarch64-unknown-linux-musl' ;; \
    *) echo >&2 "unsupported architecture: $apkArch"; exit 1 ;; \
    esac; \
    \
    url="https://static.rust-lang.org/rustup/dist/${rustArch}/rustup-init"; \
    wget "$url"; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --default-toolchain nightly; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;

RUN cargo install fleet-rs

COPY --from=bw /root/.botway /root/.botway

COPY . .

RUN fleet build --release --bin bot

ENTRYPOINT ["./target/release/bot"]
