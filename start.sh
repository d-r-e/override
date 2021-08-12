docker build -t overrider .
docker run -it \
    --mount src=`pwd`,target=/root/override,type=bind \
    --platform=linux/i386 \
    --security-opt seccomp=unconfined \
    overrider