FROM node:14.17.6-alpine AS base

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM node:14.17.6-alpine AS application

WORKDIR /app

ENV NODE_ENV=production

COPY --from=base /app/package*.json ./
COPY --from=base /app/dist ./dist
RUN npm ci

USER node
EXPOSE 4000

CMD ["node", "dist/main.js"]
