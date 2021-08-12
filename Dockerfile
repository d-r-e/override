FROM debian:bullseye
LABEL maintainer darodrig
RUN apt update
RUN apt upgrade -y
RUN apt install -y gdb vim gcc make git
RUN mkdir /root/override
WORKDIR /root/override
CMD bash