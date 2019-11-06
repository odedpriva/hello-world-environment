FROM alpine:3.8.4

LABEL vendor=viz.ai
LABEL harden-image=true

ARG VERSION
ARG GIT_COMMIT

ENV APPLICATION_USER=application
ENV APPLICATION_GROUP=application

ENV APPLICATION_HOME_DIRECTORY=/home/application/
ENV APPLICATION_BIN_DIRECTORY=/home/application/bin
ENV APPLICATION_LOG_DIRECTORY=/home/application/log
ENV APPLICATION_LIB_DIRECTORY=/home/application/lib
ENV LANG C.UTF-8

RUN apk add --no-cache ca-certificates && \
    rm -r /var/cache/apk && \
    rm -r /usr/share/man

RUN addgroup -g 1000 -S ${APPLICATION_GROUP} && \
    adduser -u 1000 -S ${APPLICATION_USER} -G ${APPLICATION_GROUP}

RUN install -d -D  -o ${APPLICATION_USER} -g ${APPLICATION_GROUP} ${APPLICATION_HOME_DIRECTORY}/bin \
    ${APPLICATION_HOME_DIRECTORY}/lib \
    ${APPLICATION_HOME_DIRECTORY}/log 

RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

USER application

COPY --chown=application:application artifacts/main ${APPLICATION_BIN_DIRECTORY}/application
RUN chmod +x ${APPLICATION_BIN_DIRECTORY}/application

CMD [ "sh", "-c", "${APPLICATION_BIN_DIRECTORY}/application" ]