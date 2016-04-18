FROM alpine
RUN apk update
RUN apk add mtr
RUN apk add nano
RUN apk add curl
RUN apk add rsync
