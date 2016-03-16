FROM qnib/alpn-supervisor

ENV CONSUL_VER=0.6.3 \
    CT_VER=0.12.1
## Should remove curl and unzip after one big step
RUN apk update && apk upgrade && \
    apk add bc nmap curl unzip && \
    # consul
    curl -fso /tmp/consul.zip https://releases.hashicorp.com/consul/${CONSUL_VER}/consul_${CONSUL_VER}_linux_amd64.zip && \
    cd /usr/local/bin/ && \
    unzip /tmp/consul.zip && \
    rm -f /tmp/consul.zip && \
    mkdir -p /opt/consul-web-ui && \
    # consul-ui
    curl -Lso /tmp/consul-web-ui.zip https://releases.hashicorp.com/consul/${CONSUL_VER}/consul_${CONSUL_VER}_web_ui.zip && \
    cd /opt/consul-web-ui && \
    unzip /tmp/consul-web-ui.zip && \
    rm -f /tmp/consul-web-ui.zip && \
    # consul-template
    curl -Lso /tmp/consul-template.zip https://releases.hashicorp.com/consul-template/${CT_VER}/consul-template_${CT_VER}_linux_amd64.zip && \
    cd /usr/local/bin/ && \
    unzip /tmp/consul-template.zip && \
    rm -f /tmp/consul-template.zip && \
    apk del unzip && \
    rm -rf /var/cache/apk/*
ADD etc/consul.d/agent.json /etc/consul.d/
ADD etc/supervisord.d/consul.ini /etc/supervisord.d/
ADD opt/qnib/consul/bin/start.sh /opt/qnib/consul/bin/
ADD opt/qnib/consul/etc/bash_functions.sh /opt/qnib/consul/etc/
RUN echo "consul members" >> /root/.bash_history

