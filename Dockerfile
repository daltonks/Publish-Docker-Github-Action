FROM docker:19.03.2 as runtime
LABEL "repository"="https://github.com/elgohr/Publish-Docker-Github-Action"
LABEL "maintainer"="Lars Gohr"

RUN echo >>/etc/apk/repositories "https://ftp.halifax.rwth-aachen.de/alpine/v3.10/main" \
  && apk update \
  && apk upgrade \
  && apk add --no-cache git

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

FROM runtime as testEnv
RUN apk add --no-cache coreutils bats
ADD test.bats /test.bats
ADD mock.sh /usr/local/bin/docker
ADD mock.sh /usr/bin/date
RUN /test.bats

FROM runtime
