# Build stage
FROM golang:1.20.3 AS build

WORKDIR /src
#COPY go.mod go.sum ./
#RUN go get
COPY . .
# Accept build-time arguments for the architecture and OS
ARG TARGETARCH
ARG TARGETOS
RUN echo "Building for architecture: ${TARGETARCH}, OS: ${TARGETOS}"

RUN go env; CGO_ENABLED=0 go build -ldflags="-w -s" -o /app .

# Final stage
FROM scratch

COPY --from=build /app /app

ENTRYPOINT ["/app"]
