FROM smebberson/alpine-nginx-nodejs

EXPOSE 80

# build frontend

WORKDIR /usr/src/app

RUN npm install --global create-elm-app

COPY package.json /usr/src/app
RUN npm --quiet install

COPY . /usr/src/app
RUN elm-app build

# copy artifacts to nginx

COPY dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf