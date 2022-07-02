FROM botwayorg/botway:latest AS bw

COPY . .

RUN botway init --docker

FROM dart:stable AS build

COPY . .

RUN dart pub get

COPY --from=bw /root/.botway /root/.botway

RUN dart compile exe src/main.dart -o bot

EXPOSE 8000

CMD ["./bot"]
