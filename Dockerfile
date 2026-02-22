FROM golang:1.22-alpine AS builder

RUN apk add --no-cache gcc musl-dev

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=1 GOOS=linux go build -o /parcel-tracker

FROM alpine:latest

RUN apk add --no-cache sqlite libc6-compat

WORKDIR /app

COPY --from=builder /parcel-tracker .

COPY tracker.db .

CMD ["./parcel-tracker"]
