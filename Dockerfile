FROM elixir:1.10.3-alpine AS build

WORKDIR /tmp/cluster_test

COPY . .

RUN mix local.hex --force && \
  mix local.rebar --force && \
  mix deps.get
RUN MIX_ENV=prod mix release

FROM elixir:1.10.3-alpine

WORKDIR /cluster_test

RUN apk add --no-cache \
  bash \
  ca-certificates \
  ncurses-libs \
  curl \
  openssl

COPY --from=build /tmp/cluster_test/_build/prod/rel/cluster_test ./
COPY --from=build /tmp/cluster_test/script/start.sh ./bin

EXPOSE 4369
EXPOSE 4370

CMD [ "/bin/bash", "bin/start.sh" ]
