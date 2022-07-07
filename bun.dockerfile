FROM botwayorg/botway:latest AS bw

COPY . .

RUN botway init --docker

FROM jarredsumner/bun:edge

COPY --from=bw /root/.botway /root/.botway

COPY . .

RUN bun i

EXPOSE 8000

ENTRYPOINT [ "bun", "dev" ]
