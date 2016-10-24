FROM alpine:3.4
MAINTAINER Victor Trac <victor@cloudkite.io>

ENV VERSION="1.25.1134.24"

# Build deps
RUN apk --no-cache add --update go git bzr wget py-pip \ 
    gcc python python-dev musl-dev linux-headers libffi-dev openssl-dev \
    py-setuptools openssl procps ca-certificates openvpn 
    
RUN pip install --upgrade pip 

# Pritunl Install
RUN export GOPATH=/go \
    && go get github.com/pritunl/pritunl-dns \
    && go get github.com/pritunl/pritunl-monitor \
    && go get github.com/pritunl/pritunl-web \
    && cp /go/bin/* /usr/bin/ 

RUN wget https://github.com/pritunl/pritunl/archive/${VERSION}.tar.gz \
    && tar zxvf ${VERSION}.tar.gz \
    && cd pritunl-${VERSION} \
    && python setup.py build \
    && pip install -r requirements.txt \
    && python2 setup.py install \
    && cd .. \
    && rm -rf *${VERSION}* \
    && rm -rf /tmp/* /var/cache/apk/*

ADD rootfs /

EXPOSE 443
EXPOSE 1194
ENTRYPOINT ["/init"]