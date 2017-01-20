FROM node:6-slim

# setup nginx
RUN \
	apt-get update && \
  apt-get install -y nginx && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  chown -R www-data:www-data /var/lib/nginx

# setup elm
RUN npm install -g elm@0.18.0

# build assets
WORKDIR /usr/src/app
COPY package.json /usr/src/app
RUN npm --quiet install

COPY . /usr/src/app

RUN npm run build

# copy to nginx
RUN cp -R /usr/src/app/dist/* /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN ln -sf /etc/nginx/conf.d/default.conf /etc/nginx/sites-enabled/default

CMD ["nginx"]
EXPOSE 80