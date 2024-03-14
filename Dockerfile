FROM node:20-alpine as build
WORKDIR /opt/app
ADD package*.json ./
RUN npm ci
ADD . .
RUN npx nx run api:build:production

FROM node:20-alpine
WORKDIR /opt/app
COPY --from=build /opt/app/dist/apps/api ./dist
RUN cd ./dist && npm ci --omit=dev
CMD [ "node", "./dist/main.js" ]