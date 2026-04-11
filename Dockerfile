FROM crystallang/crystal:latest-alpine AS builder

WORKDIR /app
COPY shard.yml shard.lock ./
RUN shards install --production
COPY src/ ./src/
RUN shards build --production --release --static --no-debug

FROM cgr.dev/chainguard/static:latest

COPY --from=builder /app/bin/tolk /tolk
EXPOSE 3000
ENTRYPOINT ["/tolk"]
