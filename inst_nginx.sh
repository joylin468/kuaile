yum install -y unzip automake gcc autoconf libtool
yum install -y pcre-devel zlib-devel

mkdir /work/source -p
cd /work/source

#1.下载ngx_cache_purge
#wget https://github.com/FRiCKLE/ngx_cache_purge/archive/master.zip 
#unzip master.zip 

# 2.OpenSSL
## 由于系统自带的 OpenSSL 库往往不够新，推荐在编译 Nginx 时指定 OpenSSL 源码目录，而不是使用系统自带的版本，这样更可控。
## https://github.com/openssl/openssl/archive/OpenSSL-fips-2_0_16.tar.gz
wget https://github.com/openssl/openssl/archive/OpenSSL_1_1_0f.tar.gz
tar zxf OpenSSL_1_1_0f.tar.gz
mv openssl-OpenSSL_1_1_0f openssl

#3.编译并安装 Nginx
wget http://nginx.org/download/nginx-1.14.2.tar.gz
tar vxf nginx-1.14.2.tar.gz
cd nginx-1.14.2

useradd -M -r -s /sbin/nologin -d /usr/local/nginx/ www

mkdir -p /usr/local/nginx/client/
mkdir -p /usr/local/nginx/proxy/
mkdir -p /usr/local/nginx/fcgi/

./configure \
 --prefix=/usr/local/nginx \
 --error-log-path=/usr/local/nginx/log/nginx/error.log \
 --http-log-path=/usr/local/nginx/log/nginx/access.log \
 --pid-path=/usr/local/nginx/log/nginx.pid  \
 --user=www \
 --group=www \
 --with-openssl=../openssl --with-openssl-opt='enable-weak-ssl-ciphers' \
 --with-http_v2_module \
 --with-http_ssl_module \
 --with-http_gzip_static_module \
 --with-http_stub_status_module \
 --http-client-body-temp-path=/usr/local/nginx/client/ \
 --http-proxy-temp-path=/usr/local/nginx/proxy/ \
 --http-fastcgi-temp-path=/usr/local/nginx/fcgi/ \
 --http-uwsgi-temp-path=/usr/local/nginx/uwsgi/  \


make -j 4
make install


