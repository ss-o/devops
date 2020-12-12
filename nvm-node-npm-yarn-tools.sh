#!/usr/bin/env bash
CDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CDIR}/utils.sh"

title "Installing NVM"
[[ -d "$HOME/.nvm" ]] && sudo rm -r "$HOME/.nvm"
mkdir -p ~/.nvm
source ~/.bashrc
notify "Cloning NVM"

git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
cd "$NVM_DIR"
git checkout v${versionNvm}
. "$NVM_DIR/nvm.sh"
cd - >/dev/null 2>&1

source ~/.bashrc

notify "Installing node"
nvm install v${versionNode}

notify "Installing npm"
nvm install-latest-npm

notify "Installing yarn"
npm install -g yarn

source ~/.bashrc

notify "Installing Yarn tools"
yarn global add babel-eslint
yarn global add bash-language-server
yarn global add cloc
yarn global add create-component-app
yarn global add create-nuxt-app
yarn global add create-react-app
yarn global add dockerfile-language-server-nodejs
yarn global add esbuild-linux-64
yarn global add eslint
yarn global add eslint-cli
yarn global add eslint-config-vue
yarn global add eslint-plugin-react
yarn global add eslint-plugin-vue@next
yarn global add expo-cli
yarn global add firebase-tools
yarn global add fx
yarn global add gulp
yarn global add gulp-cli
yarn global add heroku
yarn global add indium
yarn global add intelephense
yarn global add javascript-typescript-langserver
yarn global add jshint
yarn global add logo.svg
yarn global add @marp-team/marp-cli
yarn global add mermaid
yarn global add mermaid.cli
yarn global add netlify-cli
yarn global add ngrok
yarn global add now
yarn global add prettier
yarn global add parcel-bundler
yarn global add typescript-language-server
yarn global add @vue/cli
yarn global add vue-language-server
yarn global add vue-native-cli
yarn global add webpack

yarn global upgrade

breakLine
