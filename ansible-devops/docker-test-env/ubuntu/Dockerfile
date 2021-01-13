FROM ubuntu:latest
RUN apt-get update -y \
    && apt-get install openssh-server -y \
    && mkdir -p ~/.ssh /run/sshd \
    && ssh-keygen -N "" -f ~/.ssh/id_rsa \
    && cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys
EXPOSE 22 80 443
CMD ["/usr/sbin/sshd", "-D"]