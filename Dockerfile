# syntax=docker/dockerfile:1
ARG HUGO_VERSION=0.165.0
FROM ghcr.io/gohugoio/hugo:v${HUGO_VERSION} AS build

USER root
WORKDIR /src
COPY . .
RUN hugo --minify --gc --destination /out

FROM nginx:stable-alpine AS runtime
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /out/ /usr/share/nginx/html/
EXPOSE 80
