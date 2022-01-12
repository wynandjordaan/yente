FROM ubuntu:21.04
ENV DEBIAN_FRONTEND noninteractive

LABEL org.opencontainers.image.title "OpenSanctions SanctionSearch"
LABEL org.opencontainers.image.licenses MIT
LABEL org.opencontainers.image.source https://github.com/opensanctions/yente

RUN apt-get -qq -y update \
    && apt-get -qq -y upgrade \
    && apt-get -qq -y install locales ca-certificates curl python3-pip python3-icu python3-crypto \
    && apt-get -qq -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && groupadd -g 1000 -r app \
    && useradd -m -u 1000 -s /bin/false -g app app

ENV LANG='en_US.UTF-8'

RUN mkdir -p /app
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -e /app

USER app:app
CMD ["/usr/local/bin/uvicorn", "osapi.app:app", "--proxy-headers", "--port", "8000", "--host", "0.0.0.0"]