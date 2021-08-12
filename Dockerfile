FROM i386/debian:buster
LABEL maintainer darodrig
RUN apt update && apt upgrade -y
RUN apt install -y gdb vim gcc make git man file
RUN apt install -y ssh sshpass zsh
COPY ./.zshrc /root/
WORKDIR /root/override
RUN mkdir -p /root/override
CMD /bin/zsh