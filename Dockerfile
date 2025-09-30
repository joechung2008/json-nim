# ---- Builder stage ----
FROM debian:trixie-slim AS builder
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl git build-essential ca-certificates && \
    rm -rf /var/lib/apt/lists/*
ENV CHOOSENIM_NO_ANALYTICS=1
RUN curl https://nim-lang.org/choosenim/init.sh -sSf | sh -s -- -y
ENV PATH="/root/.nimble/bin:/root/.nimble/bin:/root/.choosenim/current/bin:$PATH"
WORKDIR /app
COPY . .
RUN nimble install_deps -y
RUN nimble build_static

# ---- Runner stage ----
FROM scratch
WORKDIR /app
COPY --from=builder /app/build/json_cli_static /app/json_cli
CMD ["/app/json_cli"]
