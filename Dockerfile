FROM qnib/alpn-supervisor

ENV CONSUL_VER=0.6.4 \
    CT_VER=0.15.0 \
    TERM=xterm \
    QNIB_CONSUL=0.1.2
EXPOSE 8500 8301 8300 8400
RUN apk add --update curl unzip jq bc nmap ca-certificates openssl \
 && curl -fso /tmp/consul.zip https://releases.hashicorp.com/consul/${CONSUL_VER}/consul_${CONSUL_VER}_linux_amd64.zip \
 && cd /usr/local/bin/ \
 && unzip /tmp/consul.zip \
 && rm -f /tmp/consul.zip \
 && mkdir -p /opt/consul-web-ui \
 && curl -Lso /tmp/consul-web-ui.zip https://releases.hashicorp.com/consul/${CONSUL_VER}/consul_${CONSUL_VER}_web_ui.zip \
 && cd /opt/consul-web-ui \
 && unzip /tmp/consul-web-ui.zip \
 && rm -f /tmp/consul-web-ui.zip \
 && curl -Lso /tmp/consul-template.zip https://releases.hashicorp.com/consul-template/${CT_VER}/consul-template_${CT_VER}_linux_amd64.zip \
 && cd /usr/local/bin/ \
 && unzip /tmp/consul-template.zip \
 && mkdir -p /opt/qnib/ \
 && curl -fsL https://github.com/qnib/consul-content/releases/download/${QNIB_CONSUL}/consul.tar |tar xf - -C /opt/qnib/ \
 && wget -qO /usr/local/bin/go-github https://github.com/qnib/go-github/releases/download/0.2.2/go-github_0.2.2_Linux \
 && chmod +x /usr/local/bin/go-github \
 && wget -qO - $(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo consul-cli --regex ".*alpine" --limit 1) |tar xfz - -C /tmp/ \
 && apk del openssl \
 && mv /tmp/consul-cli_*_alpine/consul-cli /usr/local/bin/ && \
    rm -rf /var/cache/apk/* /tmp/* /usr/local/bin/go-github \
 && rm -f /tmp/consul-template.zip /var/cache/apk/* \
 && echo "consul members" >> /root/.bash_history
ADD etc/consul.d/agent.json \
    etc/consul.d/consul.json \
    /etc/consul.d/
ADD etc/supervisord.d/consul.ini /etc/supervisord.d/
