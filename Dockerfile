FROM debian:bullseye
LABEL maintainer darodrig
RUN apt update
RUN apt upgrade -y
RUN apt install -y gdb vim gcc make git
#RUN git config pull.rebase false
WORKDIR /root/override
RUN git config --global user.email "darodrig@student.42madrid.com"
RUN git config --global user.name "d-r-e"
RUN mkdir -p /root/override
CMD bash