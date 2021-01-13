docker build -t centos_sshd:latest .
cd
docker run -dit \
    --name 'centos' --hostname 'centos' \
    -v /etc/localtime:/etc/localtime:ro \
    -p 2122:22 \
    -p 2180:80 \
    -p 21443:443 \
    centos_sshd:latest
docker cp centos:/root/.ssh/id_rsa centos_ssh_id_rsa
# ssh-keygen -f "/home/guodong/.ssh/known_hosts" -R "$(docker inspect --format='{{.NetworkSettings.IPAddress}}' centos)"
ssh -i centos_ssh_id_rsa -oStrictHostKeyChecking=no root@$(docker inspect --format='{{.NetworkSettings.IPAddress}}' centos) bash -c "cat /etc/system-release && uname -a"
