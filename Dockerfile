FROM node:24-alpine

WORKDIR /app

COPY package.json ./
COPY server.js ./

USER node

EXPOSE 8080

ENV HOST=0.0.0.0
ENV PORT=8080

CMD ["node", "server.js"]
