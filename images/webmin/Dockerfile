FROM alpine:latest

RUN apk --update add perl tar
RUN wget http://prdownloads.sourceforge.net/webadmin/webmin-1.560.tar.gz
RUN tar -xvzf webmin-1.560.tar.gz
RUN mv webmin-1.560 /var/webmin

CMD ["/var/webmin/setup.sh"]
