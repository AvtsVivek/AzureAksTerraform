
cd ../..

# cd into the directory.
cd ./iac/010040-docker-custom-nginx-image

docker run --name mynginxdefault -p 81:80 -d nginx

docker container ls -a

docker container stop mynginxdefault

docker container ls

docker container ls -a

docker container rm mynginxdefault

docker container ls -a

dir

docker build -t avts/nginxvivek:v1 .

docker run --name mynginx1 -p 81:80 -d avts/nginxvivek:v1

# Now browse to localhost:81

# So to push the image, you first have to login. 
docker login

docker push avts/nginxvivek:v1

docker container stop mynginx1

docker container ls

docker container ls -a

docker container rm mynginx1

