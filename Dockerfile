FROM debian:latest

EXPOSE 53
EXPOSE 53/udp

RUN apt-get update && apt-get install -y apt-transport-https wget gnupg && \
		wget -qO - https://nextdns.io/repo.gpg | apt-key add - && \
		echo "deb https://nextdns.io/repo/deb stable main" | tee /etc/apt/sources.list.d/nextdns.list && \
		apt-get update && apt-get install -y nextdns dnsmasq dnsutils

COPY root/ /

RUN chmod +r /etc/dnsmasq.conf

HEALTHCHECK --interval=60s --timeout=10s --start-period=5s --retries=1 \
	CMD dig +time=20 @127.0.0.1 -p 53 probe-test.dns.nextdns.io && dig +time=20 @127.0.0.1 -p 8053 probe-test.dns.nextdns.io

CMD /usr/bin/nextdns run -config-file "/var/nextdns/config"
