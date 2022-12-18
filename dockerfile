# Stage 1: Build
FROM --platform=linux/amd64 node:12-alpine as build

WORKDIR /app

COPY package.json yarn.lock ./

RUN npm install     
RUN yarn

# Copies everything over to Docker environment
COPY . ./

RUN yarn build

# Stage 2
FROM --platform=linux/amd64 nginx:stable-alpine

WORKDIR /usr/share/nginx/html

# Remove default nginx static resources
# RUN rm -rf ./*

COPY --from=build /app/build .
COPY --from=build /app/env.sh /docker-entrypoint.d
COPY conf.d/default.conf /etc/nginx/conf.d

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
