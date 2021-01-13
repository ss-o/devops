FROM centos:latest
RUN yum update -y \
    && yum install openssh-server -y \
    && mkdir -p ~/.ssh /run/sshd \
    && ssh-keygen -A \
    && ssh-keygen -N "" -f ~/.ssh/id_rsa \
    && cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys
EXPOSE 22 80 443
CMD ["/usr/sbin/sshd", "-D"]