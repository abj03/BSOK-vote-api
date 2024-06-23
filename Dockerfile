#FROM image-registry.openshift-image-registry.svc:5000/openshift/golang:latest as builder
FROM registry.access.redhat.com/ubi8/go-toolset:1.17 as builder

WORKDIR /build
ADD . /build/
RUN mkdir /tmp/build

RUN export GARCH="$(uname -m)" && if [ "${GARCH}" = "x86_64" ]; then export GARCH="amd64"; fi && GOOS=linux GOARCH=${GARCH} CGO_ENABLED=0 go build -mod=vendor -o /tmp/build/api-server .

FROM scratch

WORKDIR /app
COPY --from=builder /tmp/build/api-server /app/api-server

CMD [ "/app/api-server" ]
