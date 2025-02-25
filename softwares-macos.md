<!-- TOC -->

- [MacOS](#macos)
  - [Homebrew](#homebrew)
  - [Essentials](#essentials)
- [asdf](#asdf)
- [awscli](#awscli)
- [docker](#docker)
- [docker-compose](#docker-compose)
- [terraform e tfenv](#terraform-e-tfenv)

<!-- TOC -->

# MacOS

## Homebrew

Install Homebrew with the following command:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> "/Users/$USER/.bash_profile"

eval "$(/opt/homebrew/bin/brew shellenv)"
```

Reference: https://brew.sh/

## Essentials

Run the following commands:

```bash
software --install rosetta --agree-to-license

brew install vim telnet netcat git elinks curl wget net-tools python3 openjdk jq make coreutils visual-studio-code

echo 'export PATH="/opt/homebrew/opt/curl/bin:\$PATH"' >> "/User/$USER/.bash_profile"

export LDFLAGS="-L/opt/homebrew/opt/curl/lib"
export CPPFLAGS="-I/opt/homebrew/opt/curl/include"

sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

echo 'export PATH="/opt/homebrew/opt/openjdk/bin:\$PATH"' >> "/User/$USER/.bash_profile"

export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

echo 'export PATH="/opt/homebrew/opt/make/libexec/gnubin:\$PATH"' >> "/User/$USER/.bash_profile"

export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"

alias python=python3
alias pip=pip3
```

Install python3-pip following the instructions on the page: https://docs.brew.sh/Homebrew-and-Python

Install the following software:

- Google Chrome: https://support.google.com/chrome/answer/95346?hl=pt-BR&co=GENIE.Platform%3DDesktop#zippy=%2Cmac
  - Plugins for Visual Code
  - Instructions to export/import plugins: https://stackoverflow.com/questions/35773299/how-can-you-export-the-visual-studio-code-extension-list
  - docker: https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker (Requires installation of the docker command shown in the following sections).
  - gitlens: https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens (Requires installation of the git command shown in the previous section).
  - Markdown-all-in-one: https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one
  - Markdown-lint: https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint
  - Markdown-toc: https://marketplace.visualstudio.com/items?itemName=CharlesWan.markdown-toc
  - python: https://marketplace.visualstudio.com/items?itemName=ms-python.python (Requires installation of the python3 command shown in the previous section).
  - terraform: https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform (Requires installation of the terraform command shown in the following sections).
  - YAML: https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml
  - Theme for VSCode:
    - https://code.visualstudio.com/docs/getstarted/themes
    - https://dev.to/thegeoffstevens/50-vs-code-themes-for-2020-45cc
    - https://vscodethemes.com/

# asdf

Run the following commands:

> Attention!!! To update ``asdf``, ONLY use the following command:

```bash
asdf update
```

> If you try to reinstall or update by changing the version in the following commands, you will need to reinstall all plugins/commands installed before, so it is very important to back up the ``$HOME/.asdf`` directory.

```bash
ASDF_VERSION="v0.15.0"
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch $ASDF_VERSION

# Adding $HOME/.bashrc
echo ". \"\$HOME/.asdf/asdf.sh\"" >> ~/.bash_profile
echo ". \"\$HOME/.asdf/completions/asdf.bash\"" >> ~/.bash_profile
source ~/.bash_profile
```

Reference: https://asdf-vm.com/guide/introduction.html

# awscli

Install ``awscli`` using ``asdf``:

> Before continuing, if you have awscli installed, remove it with the following commands:

```bash
sudo rm /usr/local/bin/aws
sudo rm -rf /usr/local/aws-cli
# ou
sudo rm -rf /usr/local/aws
```

> Before proceeding, make sure you have installed the command [asdf](#asdf).

```bash
AWS_CLI_V2="2.23.11"

asdf plugin list all | grep aws
asdf plugin add awscli https://github.com/MetricMike/asdf-awscli.git
asdf latest awscli

asdf install awscli $AWS_CLI_V2
asdf list awscli

# Setting the global version
asdf global awscli $AWS_CLI_V2
asdf list awscli

# Creating symbolic link
sudo ln -s $HOME/.asdf/shims/aws /usr/local/bin/aws
```

Reference:
* https://asdf-vm.com/guide/introduction.html
- https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html
* https://computingforgeeks.com/how-to-install-and-use-aws-cli-on-linux-ubuntu-debian-centos/

# docker

Install Docker CE (Community Edition) following the instructions on the page: https://docs.docker.com/desktop/install/mac-install/.

Run the following commands:

> Before proceeding, make sure you have installed the command [Homebrew](#homebrew).

```bash
brew install --cask docker
brew install docker-machine
```

Reference: https://stackoverflow.com/questions/44084846/cannot-connect-to-the-docker-daemon-on-macos

# docker-compose

More info: https://docs.docker.com/compose/install/

Run the following command:

> Before proceeding, make sure you have installed the command [Homebrew](#homebrew).

```bash
brew install docker-compose
```

# terraform e tfenv

Run the following commands to install ``tfenv``, Terraform version controller.

Documentation: <https://github.com/tfutils/tfenv>

> Before proceeding, make sure you have installed the command [Homebrew](#homebrew).

```bash
brew install tfenv
```

List versions that can be installed:

```bash
tfenv list-remote
```

Instale as seguiInstall the following versions of Terraform using tfenv:

```bash
tfenv install 1.10.5
```

Set the following version as the default:

```bash
tfenv use 1.10.5
```

To uninstall a terraform version with tfenv, use the following command:

```bash
tfenv uninstall <VERSAO>
```

List the installed versions:

```bash
tfenv list
```

Only when developing code that uses terraform can you force the project to use a specific version:

Create the ``.terraform-version`` file in the project root with the desired version number. Example:

```bash
cat .terraform-version
1.10.5
```
