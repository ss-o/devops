docker build -t ubuntu_sshd:latest .
cd
docker run -dit \
    --name 'ubuntu20' --hostname 'ubuntu20' \
    -v /etc/localtime:/etc/localtime:ro \
    -p 2022:22 \
    -p 2080:80 \
    -p 20443:443 \
    ubuntu_sshd:latest
docker cp ubuntu20:/root/.ssh/id_rsa ubuntu20_ssh_id_rsa
# ssh-keygen -f "/home/guodong/.ssh/known_hosts" -R "$(docker inspect --format='{{.NetworkSettings.IPAddress}}' ubuntu20)"
ssh -i ubuntu20_ssh_id_rsa -oStrictHostKeyChecking=no root@$(docker inspect --format='{{.NetworkSettings.IPAddress}}' ubuntu20) uname -a
