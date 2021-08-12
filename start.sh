docker build -t overrider .
docker run -it --mount src=`pwd`,target=/root/override,type=bind overrider