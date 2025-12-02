FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN mkdir -p static/data && cp -r .evidence/template/static/data/* static/data/

RUN npm run build

FROM nginx:alpine AS stage-1
WORKDIR /usr/share/nginx/html

COPY --from=builder /app/build .
