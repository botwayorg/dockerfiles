FROM botwayorg/botway:latest AS bw

COPY . .

RUN botway init --docker

FROM jarredsumner/bun:edge

COPY --from=bw /root/.botway /root/.botway

COPY . .

RUN bun i

ENTRYPOINT [ "bun", "dev" ]
