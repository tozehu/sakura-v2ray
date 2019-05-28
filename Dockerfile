FROM v2ray/official:lzatest@sha256:558cb532c6f6aa91667dbc7804f94127b74c4ffee0a2f75e151d05e3525aaadb as V2ray

FROM alpine:3.9.4@sha256:769fddc7cc2f0a1c35abb2f91432e8beecf83916c421420e6a6da9f8975464b6

COPY --from=V2ray /usr/bin/v2ray /usr/bin/v2ray
ENV PATH=$PATH:/usr/bin/v2ray

COPY v2ray /v2ray
RUN chmod +x /v2ray/docker-entrypoint.sh

ENV DOCKER_ENV=true
ENTRYPOINT [ "/v2ray/docker-entrypoint.sh" ]

WORKDIR /v2ray

CMD [ "v2ray", "-config", "/etc/v2ray/config.jsonc" ]
