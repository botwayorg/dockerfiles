FROM botwayorg/botway:latest AS bw

COPY . .

RUN botway init --docker

FROM brainboxdotcc/dpp:latest

WORKDIR /usr/src/bwbot

COPY --from=bw /root/.botway /root/.botway

COPY . .

WORKDIR /usr/src/bwbot/build

RUN cmake ..
RUN make -j$(nproc)

ENTRYPOINT [ "/usr/src/bwbot/build/bwbot" ]
