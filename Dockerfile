FROM alpine:3.21


LABEL image_name="git-sync"

RUN apk update && \
    apk add --no-cache git rsync

WORKDIR /app

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]

