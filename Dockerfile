FROM golang:1.17-bullseye AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -o /metricstarget

FROM gcr.io/distroless/base-debian11

WORKDIR /

COPY --from=build /metricstarget /metricstarget

EXPOSE 8080

USER nonroot:nonroot

CMD [ "/metricstarget" ]
