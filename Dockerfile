FROM alpine:3.21


LABEL image_name="git-sync"

RUN apk update && \
    apk add --no-cache git rsync

WORKDIR /app

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# Create a non-privileged user that the app will run under.
# See https://docs.docker.com/go/dockerfile-user-best-practices/
ARG UID=1000
ARG GID=2000
RUN addgroup --gid "${GID}" app \
    && adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    -G app \
    --uid "${UID}" \
    app

RUN chown app:app /app && chmod -R 777 /app
USER app:app

ENV RSYNC_ARGS="-vaz --exclude='.git' --delete"

ENTRYPOINT ["./entrypoint.sh"]

