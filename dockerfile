 FROM crystallang/crystal:latest-alpine AS builder

WORKDIR /app

COPY shard.yml shard.lock ./
RUN shards install --production

COPY src/ ./src/

RUN crystal build src/tolk.cr \
      --release \
      --static \
      --no-debug \
      -o bin/tolk

 
FROM scratch

COPY --from=builder /app/bin/tolk /tolk

EXPOSE 3000

ENTRYPOINT ["/tolk"]
