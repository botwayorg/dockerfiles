FROM botwayorg/botway:latest AS bw

COPY . .

RUN botway init --docker

FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build

ENV PACKAGES "build-dependencies build-base gcc git libsodium opus ffmpeg"

RUN apk update && \
	apk add --no-cache --virtual ${PACKAGES}

COPY . .

RUN dotnet restore

RUN dotnet publish -c Release -o out

COPY --from=bw /root/.botway /root/.botway

ENTRYPOINT ["dotnet", "./out/Main.dll"]
