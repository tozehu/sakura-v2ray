FROM v2ray/official:latest@sha256:558cb532c6f6aa91667dbc7804f94127b74c4ffee0a2f75e151d05e3525aaadb as V2ray

FROM alpine:3.9.4@sha256:769fddc7cc2f0a1c35abb2f91432e8beecf83916c421420e6a6da9f8975464b6 as Base

RUN set -e \
  # && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
  && apk add --no-cache caddy nodejs npm

COPY --from=V2ray /usr/bin/v2ray /usr/bin/v2ray

FROM Base

ENV NODE_ENV=production

WORKDIR /tmp/pkg
COPY pkg-deps.json /tmp/pkg/package.json
RUN npm i --registry=https://registry.npm.taobao.org
# RUN npm i

COPY npm-pack.tgz /tmp/npm-pack.tgz
RUN set -x \
  && tar -xzf /tmp/npm-pack.tgz -C /tmp \
  && mv /tmp/package /app \
  && mv /tmp/pkg/node_modules /app

RUN rm -rf /tmp/npm-pack.tgz /tmp/pkg $(npm config get cache)

ENV PATH=$PATH:/usr/bin/v2ray

WORKDIR /app

CMD [ "npm", "start" ]
