FROM nginx:stable

EXPOSE 80

# setup node

RUN apt-get update && apt-get install -y \
	curl \
	python \
	make \
	g++

RUN \
 curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
 apt-get install -y nodejs

# build frontend

WORKDIR /usr/src/app
RUN npm install --global create-elm-app
COPY package.json /usr/src/app
RUN npm --quiet install

COPY . /usr/src/app
RUN elm-app build

# copy artifacts to nginx

COPY /usr/src/app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf