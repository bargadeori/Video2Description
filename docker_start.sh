#!/bin/bash
echo "Starting container as development environment!!!"
docker container ls
docker container stop v2d
docker rm v2d
echo "Starting backend"
docker container run --name "v2d" -d -p 8080:5000 scopeinfinity/video2description:deploy /bin/bash -i -c 'python parser.py server -s -m /home/si/v2d/models/ResNet_D512L512_G128G64_D1024D0.20BN_BDGRU1024_D0.2L1024DVS_model.dat_4983_loss_2.350_Cider0.355_Blue0.353_Rouge0.571_Meteor0.247_TOTAL_1.558_BEST 2>&1 | tee /var/log/v2d/server.log'
echo "Starting web-ui"
docker container exec -d "v2d" /bin/bash -i -c 'python app.py 2>&1 | tee /var/log/v2d/app.log'
echo "Container Logs:"
docker container logs -f v2d
trap "docker container stop v2d" EXIT