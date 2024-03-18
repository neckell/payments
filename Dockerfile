# syntax=docker/dockerfile:1

##
## Build
##

FROM golang:1.20.2 AS build-stage

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -o /go-template

##
## Deploy
##

FROM gcr.io/distroless/base-debian11 AS build-release-stage

WORKDIR /

COPY --from=build-stage /go-template /go-template

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["/go-template"]