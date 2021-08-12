FROM debian:bullseye
LABEL maintainer darodrig
RUN apt update && apt upgrade -y
RUN apt install -y gdb vim gcc make git man
RUN apt install -y ssh sshpass zsh
COPY ./.zshrc /root/
WORKDIR /root/override
RUN git config --global user.email "darodrig@student.42madrid.com"
RUN git config --global user.name "d-r-e"
RUN mkdir -p /root/override
CMD /bin/zsh