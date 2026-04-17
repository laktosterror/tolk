FROM crystallang/crystal:latest-alpine AS builder

WORKDIR /app
COPY shard.yml shard.lock ./
RUN shards install --production
COPY src/ ./src/
RUN shards build --release --static --no-debug -Dpreview_mt -Dexecution_context --progress --stats --link-flags '-O3 -march=neoverse-n1'
FROM cgr.dev/chainguard/static:latest

COPY --from=builder /app/bin/tolk /tolk
EXPOSE 3000
ENTRYPOINT ["/tolk"]
