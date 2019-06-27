FROM node:12.4-alpine AS builder
WORKDIR /usr/src/app
LABEL stage=intermediate

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --production

COPY . ./

FROM node:12.4-alpine
WORKDIR /usr/src/app
EXPOSE 8000

RUN apk add --no-cache tini

COPY --from=builder /usr/src/app ./

USER node
ENTRYPOINT ["/sbin/tini", "--"]
CMD [ "yarn", "start" ]
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "curl", "http://localhost:8000" ]
