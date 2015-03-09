FROM ubuntu:trusty

ENV OPENRESTY_VERSION="1.7.10.1" \
	LUAROCKS_VERSION="2.2.0"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
	curl \
	build-essential \
	libpcre3-dev \
	libssl-dev \
	libreadline-dev \
	libncurses5-dev \
	unzip \
	git \
	netcat


RUN curl -SL http://openresty.org/download/ngx_openresty-${OPENRESTY_VERSION}.tar.gz  | \
	tar xzvf - && \
	cd ngx_openresty-${OPENRESTY_VERSION} && \
	./configure && \
	make && \
	make install


RUN curl -SL http://keplerproject.github.io/luarocks/releases/luarocks-${LUAROCKS_VERSION}.tar.gz | \
	tar xzvf - && \
	cd luarocks-${LUAROCKS_VERSION} && \
	./configure --prefix=/usr/local/openresty/luajit \
		--with-lua=/usr/local/openresty/luajit \
		--with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1 \
		--lua-suffix=jit-2.1.0-alpha && \
	make && \
	make bootstrap


RUN /usr/local/openresty/luajit/bin/luarocks install busted && \
	/usr/local/openresty/luajit/bin/luarocks install luacrypto 

RUN apt-get clean

