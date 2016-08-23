FROM debian:stretch
MAINTAINER Tim Düsterhus

RUN	apt-get update \
&&	apt-get install --no-install-recommends -y knot=2.3.0-3 \
&&	rm -rf /var/lib/apt/lists/*

COPY	knot.conf /etc/knot/knot.conf

COPY *.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["knotd"]
