# syntax=docker/dockerfile:1.5

FROM debian:trixie AS src
SHELL ["/bin/bash", "-exo", "pipefail", "-c"]
WORKDIR /src
COPY . .
ENV DEBIAN_FRONTEND=noninteractive
RUN <<eof
	apt-get update
	apt-get install -y --no-install-recommends \
		build-essential pkg-config libtracefs-dev libzstd-dev \
		libtraceevent-dev git
eof

FROM src AS builder
RUN make prefix=/tmp/trace-cmd install

FROM scratch AS releaser
COPY --from=builder /tmp/trace-cmd/* /
