#!/bin/bash
MQTT_IMAGE=advigw4x86/mqtt-bus
MQTT_CONTAINER=mqtt
DOCKER_API_GW_IMAGE=ivan0124tw/docker_webmin
DOCKER_API_GW_CONTAINER=eis_webmin
ADVANTECH_NET=advigw_network
WSN_SETTING_FOLDER=advan_wsn_setting


#stop container
echo "======================================="
echo "[Step1]: Stop container......"
echo "======================================="
#sudo docker stop $MQTT_CONTAINER
sudo docker stop $DOCKER_API_GW_CONTAINER

#remove container
echo "======================================="
echo "[Step2]: Remove container......"
echo "======================================="
#sudo docker rm $MQTT_CONTAINER
sudo docker rm $DOCKER_API_GW_CONTAINER

#pull images
if [ "$1" == "restart" ] ; then
echo "======================================="
echo "[Step3]: Restart, don't pull container images......"
echo "======================================="
else 
echo "======================================="
echo "[Step3]: Pull container images......"
echo "======================================="
#sudo docker pull $MQTT_IMAGE
sudo docker pull $DOCKER_API_GW_IMAGE
fi

#create user-defined network `advantech-net`
NET=`sudo docker network ls | grep $ADVANTECH_NET | awk '{ print $2}'`
if [ "$NET" != "$ADVANTECH_NET" ] ; then
echo "======================================="
echo "[Step4]: $ADVANTECH_NET does not exist, create $ADVANTECH_NET network..."
echo "======================================="
sudo docker network create -d bridge --subnet 172.25.0.0/16 i$ADVANTECH_NET
else
echo "======================================="
echo "[Step4]: Found $ADVANTECH_NET network. $ADVANTECH_NET exist."
echo "======================================="
fi



#run container and join to `advantech-net` network
echo "======================================="
echo "[Step5]: Run container images......>>>"
echo "======================================="
#sudo docker run --network=$ADVANTECH_NET -itd --name $MQTT_CONTAINER -p 1883:1883 $MQTT_IMAGE
#sudo docker run --network=$ADVANTECH_NET -it --name $DOCKER_API_GW_CONTAINER $DOCKER_API_GW_IMAGE
sudo docker run --network=$ADVANTECH_NET -it --name $DOCKER_API_GW_CONTAINER -p 10000:10000 $DOCKER_API_GW_IMAGE

