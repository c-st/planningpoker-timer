FROM smebberson/alpine-nginx-nodejs:latest

EXPOSE 80

# build frontend

WORKDIR /usr/src/app

COPY package.json /usr/src/app
RUN npm --quiet install

COPY . /usr/src/app
RUN node ./scripts/build.js

# copy artifacts to nginx

COPY dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf