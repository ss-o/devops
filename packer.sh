mkdir -p $(go env GOPATH)/src/github.com/hashicorp && cd $_
git clone https://github.com/hashicorp/packer.git ~/.packer
cd ~/.packer && make dev
