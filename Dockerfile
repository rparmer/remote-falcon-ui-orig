FROM node:16.14.0-alpine as build
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json ./
COPY package-lock.json ./
RUN npm ci --silent
RUN npm install react-scripts@3.4.1 -g --silent
RUN npm install serve -g --silent
COPY . ./

ARG HOST_ENV
ARG VERSION
ARG REMOTE_FALCON_GATEWAY
ARG VIEWER_JWT_KEY
ARG GOOGLE_MAPS_KEY
ARG PUBLIC_POSTHOG_KEY
ARG GA_TRACKING_ID
ARG HOSTNAME_PARTS

RUN echo "HOST_ENV $HOST_ENV"
RUN echo "VERSION $VERSION"

ENV REACT_APP_HOST_ENV=$HOST_ENV
ENV REACT_APP_VERSION=$VERSION
ENV REACT_APP_REMOTE_FALCON_GATEWAY=$REMOTE_FALCON_GATEWAY
ENV REACT_APP_VIEWER_JWT_KEY=$VIEWER_JWT_KEY
ENV REACT_APP_GOOGLE_MAPS_KEY=$GOOGLE_MAPS_KEY
ENV REACT_APP_PUBLIC_POSTHOG_KEY=$PUBLIC_POSTHOG_KEY
ENV REACT_APP_GA_TRACKING_ID=$GA_TRACKING_ID
ENV REACT_APP_HOSTNAME_PARTS=$HOSTNAME_PARTS

RUN npm run build

# start the nginx web server
CMD ["serve", "-s", "/app/build"]
