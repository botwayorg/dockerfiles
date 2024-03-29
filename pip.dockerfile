FROM python:alpine
FROM botwayorg/botway:latest

ENV PACKAGES "build-dependencies build-base gcc abuild binutils py-pip binutils-doc gcc-doc python3-dev libffi-dev git binutils openssl-dev zlib-dev boost boost-dev"

COPY . .

RUN apk update && \
	apk add --no-cache --virtual ${PACKAGES}

# Add package(s) you want
# RUN apk add PACKAGE

RUN botway init --docker
RUN pip3 install -r requirements.txt

ENTRYPOINT ["python3", "./src/main.py"]
