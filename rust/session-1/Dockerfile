# https://github.com/hseeberger/
# https://kerkour.com/rust-small-docker-image

ARG RUST_VERSION=1.82.0

FROM rust:${RUST_VERSION}-slim-bookworm AS builder
WORKDIR /app
COPY . .
RUN \
    --mount=type=cache,target=/app/target/ \
    --mount=type=cache,target=/usr/local/cargo/registry/ \
    cargo build --release && \
    cp ./target/release/simple-api /


FROM gcr.io/distroless/cc-debian12 AS final
USER nonroot:nonroot
COPY --from=builder /simple-api /usr/local/bin/
WORKDIR /opt/simple-api
ENTRYPOINT ["/usr/local/bin/simple-api"]
EXPOSE 8080/tcp
