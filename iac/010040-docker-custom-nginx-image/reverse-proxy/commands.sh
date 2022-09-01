
cd ../..

# cd into the directory.
cd ./iac/010040-docker-custom-nginx-image/reverse-proxy

docker build -t avts/nginxvivekproxy:v1 .

docker run --name mynginxdefaultproxy -p 81:80 -d nginx

docker container ls -a

docker container stop mynginxdefaultproxy

docker container ls

dir

docker build -t avts/nginxvivekproxy:v1 .

docker run --name mynginx1 -p 81:80 -d avts/nginxvivekproxy:v1

# Now browse to localhost:81

# So to push the image, you first have to login. 
docker login

docker push avts/nginxvivekproxy:v1

