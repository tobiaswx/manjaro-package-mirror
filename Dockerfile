FROM docker.io/library/alpine:3.14
COPY nginx.conf /etc/nginx/http.d/default.conf
COPY manjaro-mirror.sh /scripts/
COPY init.sh /scripts/
RUN apk add --no-cache rsync nginx bash && mkdir /srv/http && nginx

EXPOSE 80
VOLUME /srv/http/manjaro
ENV SOURCE_MIRROR=rsync://mirrorservice.org/repo.manjaro.org/repos/
ENV SLEEP=6h

CMD ["/scripts/init.sh"]
