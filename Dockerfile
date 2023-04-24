# Stage 1: Build
FROM golang:1.20.3-alpine AS builder

# Cria um diretório para o projeto
RUN mkdir /app

# Define o diretório de trabalho
WORKDIR /app

# Copia todos os arquivos .go para o diretório de trabalho
COPY *.go /app/

# Inicializa o Go Modules e cria o arquivo go.mod
RUN go mod init myapp

# Compila o programa
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /app/myapp

# Stage 2: Create a minimal image
FROM scratch

# Cria um diretório para o projeto
WORKDIR /app

# Copia o binário compilado do stage 1 (builder)
COPY --from=builder /app/myapp /app/

# Executa o programa
CMD ["/app/myapp"]

# Expor a porta 8080 (se o programa precisar)
EXPOSE 8080
