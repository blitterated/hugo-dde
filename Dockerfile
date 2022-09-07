FROM dde

ARG HUGO_VERSION=0.102.3

RUN (cd /tmp && curl -LO "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz") && \
    tar -C /usr/bin -zxvf "/tmp/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz" && \
    rm -rf /tmp/*

COPY type /etc/s6-overlay/s6-rc.d/hugo/type
COPY run /etc/s6-overlay/s6-rc.d/hugo/run
COPY finish /etc/s6-overlay/s6-rc.d/hugo/finish
COPY hugo /etc/s6-overlay/s6-rc.d/user/contents.d/hugo

CMD ["/usr/bin/env", "bash"]
