<!-- TOC -->

- [Ubuntu](#ubuntu)
  - [Essential](#essential)
  - [Optionals](#optionals)
- [Git](#git)
- [asdf](#asdf)
- [awscli](#awscli)
- [docker](#docker)
- [docker-compose](#docker-compose)
- [gcloud](#gcloud)
- [Helm](#helm)
- [helm-docs](#helm-docs)
- [helm-diff - Plugin](#helm-diff---plugin)
- [helm-secrets - Plugin](#helm-secrets---plugin)
- [kubectl](#kubectl)
- [Kubectl plugins](#kubectl-plugins)
  - [krew](#krew)
  - [kubectx e kubens](#kubectx-e-kubens)
- [Custom Terminal Prompt](#custom-terminal-prompt)
  - [bash\_prompt](#bash_prompt)
- [Sops](#sops)
- [terraform e tfenv](#terraform-e-tfenv)
- [terraform-docs](#terraform-docs)
- [terragrunt e tgenv](#terragrunt-e-tgenv)
  - [Known issue](#known-issue)
- [\[OPTIONAL\] Aliases](#optional-aliases)
  - [bashrc](#bashrc)
- [\[OPTIONAL\] kind](#optional-kind)
- [\[OPTIONAL\] trivy](#optional-trivy)
  - [Installing trivy using Docker](#installing-trivy-using-docker)

<!-- TOC -->

# Ubuntu

## Essential

Run the following commands on Ubuntu 24.04/22.02:

```bash
sudo apt install -y vim traceroute telnet netcat-openbsd git tcpdump elinks curl wget openssl net-tools python3 python3-pip meld python3-venv default-jdk jq make gnupg
```

For Python "3.10.*" run the following command to create the symbolic link:

```bash
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1
```

For Python "3.12.*" run the following command to create the symbolic link:

```bash
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1
```

## Optionals

Install the following software:

- Firefox
- Google Chrome
- WPS: https://br.wps.com/download/
- Visual Code: https://code.visualstudio.com
  - Instalação no Ubuntu: https://code.visualstudio.com/docs/setup/linux
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
  - Helm Intellisense: https://marketplace.visualstudio.com/items?itemName=Tim-Koehler.helm-intellisense
  - Theme for VSCode:
    - https://code.visualstudio.com/docs/getstarted/themes
    - https://dev.to/thegeoffstevens/50-vs-code-themes-for-2020-45cc
    - https://vscodethemes.com/

# Git

Create directory ``~/git`` directory.

```bash
mkdir ~/git
```

Download ``updateGit.sh`` script:

```bash
cd ~
wget https://gist.githubusercontent.com/aeciopires/2457cccebb9f30fe66ba1d67ae617ee9/raw/8d088c6fadb8a4397b5ff2c7d6a36980f46d40ae/updateGit.sh
chmod +x ~/updateGit.sh
```

Now you can clone all git repositories and save inside ``~/git`` directory.

At the beginning of the daily workday, update all git repositories at once with the following command.

```bash
cd ~
./updateGit.sh git/
```

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

# Adicionando no $HOME/.bashrc
echo ". \"\$HOME/.asdf/asdf.sh\"" >> ~/.bashrc
echo ". \"\$HOME/.asdf/completions/asdf.bash\"" >> ~/.bashrc
source ~/.bashrc
```

Fonte: https://asdf-vm.com/guide/introduction.html

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

Fonte:
* https://asdf-vm.com/guide/introduction.html
- https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html
* https://computingforgeeks.com/how-to-install-and-use-aws-cli-on-linux-ubuntu-debian-centos/

# docker

Install Docker CE (Community Edition) following the instructions on the page: <https://docs.docker.com/engine/install/ubuntu/>.

```bash
sudo apt update
sudo apt install -y acl
curl -fsSL https://get.docker.com -o get-docker.sh;
sudo sh get-docker.sh;
# Utilizando docker sem sudo
sudo usermod -aG docker $USER;
sudo setfacl -m user:$USER:rw /var/run/docker.sock
```

Reference: <https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot>

# docker-compose

Documentation: <https://docs.docker.com/compose/>

```bash
sudo su
COMPOSE_VERSION=1.29.2

sudo curl -L "https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

/usr/local/bin/docker-compose version

exit
```

# gcloud

> Before continuing, if you have awscli installed, remove it with the following commands:

```bash
sudo apt remove google-cloud-sdk
sudo rm /etc/apt/sources.list.d/google-cloud-sdk.list
```

> Before proceeding, make sure you have installed the command [asdf](#asdf).

```bash
VERSION="508.0.0"

asdf plugin list all | grep gcloud
asdf plugin add gcloud https://github.com/jthegedus/asdf-gcloud.git
asdf latest gcloud

asdf install gcloud $VERSION
asdf list gcloud

# Definindo a versão padrão
asdf global gcloud $VERSION
asdf list gcloud

#Login using gcloud:
gcloud init

gcloud auth login
gcloud auth application-default login
```

References:
- https://cloud.google.com/sdk/install
- https://cloud.google.com/sdk/docs/downloads-apt-get
- https://cloud.google.com/docs/authentication/gcloud
- https://cloud.google.com/docs/authentication/getting-started
- https://console.cloud.google.com/apis/credentials/serviceaccountkey
- https://cloud.google.com/sdk/gcloud/reference/config/set
- https://code-maven.com/gcloud
- https://gist.github.com/pydevops/cffbd3c694d599c6ca18342d3625af97
- https://blog.realkinetic.com/using-google-cloud-service-accounts-on-gke-e0ca4b81b9a2
- https://www.the-swamp.info/blog/configuring-gcloud-multiple-projects/

# Helm

Run the following commands to install helm:

> Before continuing, if you have helm installed via apt, remove it with the following commands:

```bash
sudo apt remove helm
# ou
sudo rm /usr/local/bin/helm
sudo rm /etc/apt/sources.list.d/helm-stable-debian.list
```

> Before proceeding, make sure you have installed the command [asdf](#asdf).

Documentation: <https://helm.sh/docs/>

```bash
VERSION="3.17.0"

asdf plugin list all | grep helm
asdf plugin add helm https://github.com/Antiarchitect/asdf-helm.git
asdf latest helm

asdf install helm $VERSION
asdf list helm

# Definindo a versão padrão
asdf global helm $VERSION
asdf list helm
```

# helm-docs

Run the following commands to install helm-docs.

> Before continuing, if you have helm-docs installed, remove it with the following command:

```bash
sudo rm /usr/local/bin/helm-docs
```

> Before proceeding, make sure you have installed the command [asdf](#asdf).

Documentation: <https://github.com/norwoodj/helm-docs>

```bash
VERSION="1.14.2"

asdf plugin list all | grep helm-docs
asdf plugin add helm-docs https://github.com/sudermanjr/asdf-helm-docs.git
asdf latest helm-docs

asdf install helm-docs $VERSION
asdf list helm-docs

# Definindo a versão padrão
asdf global helm-docs $VERSION
asdf list helm-docs
```

The documentation generated by helm-docs is based on the contents of the ``values.yaml`` and ``Chart.yaml`` files. It tries to overwrite the contents of the ``README.md`` file within the chart directory.

To avoid this problem, run the ``helm-docs --dry-run`` command (inside the directory of each chart) and manually copy the content displayed on the standard output into the ``README.md`` file, avoiding loss of data.

# helm-diff - Plugin

Run the following commands to install the helm plugin, helm-diff.

Documentation: <https://github.com/databus23/helm-diff>

```bash
helm plugin install https://github.com/databus23/helm-diff --version v3.9.14
```

# helm-secrets - Plugin

Run the following commands to install the helm plugin, helm-secrets.

Documentation: <https://github.com/jkroepke/helm-secrets>

```bash
helm plugin install https://github.com/jkroepke/helm-secrets --version v4.6.2
```

# kubectl

Run the following shell function to install kubectl.

Documentation: <https://kubernetes.io/docs/reference/kubectl/overview/>

```bash
VERSION_OPTION_1="1.32.1"

asdf plugin list all | grep kubectl
asdf plugin add kubectl https://github.com/asdf-community/asdf-kubectl.git
asdf latest kubectl

asdf install kubectl $VERSION_OPTION_1
asdf list kubectl

asdf global kubectl $VERSION_OPTION_1
asdf list kubectl

sudo ln -s $HOME/.asdf/shims/kubectl /usr/local/bin/kubectl
```

# Kubectl plugins

Listed below are some useful plugins for Kubectl.

## krew

Documentation:

- <https://github.com/kubernetes-sigs/krew/>
- <https://krew.sigs.k8s.io/docs/user-guide/setup/install/>

```bash
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

cat << FOE >> ~/.bashrc

#krew
export PATH="\${KREW_ROOT:-\$HOME/.krew}/bin:\$PATH"
FOE
```

## kubectx e kubens

Documentation: <https://github.com/ahmetb/kubectx#installation>

```bash
git clone https://github.com/ahmetb/kubectx.git ~/.kubectx

COMPDIR=$(sudo pkg-config --variable=completionsdir bash-completion)
sudo ln -sf ~/.kubectx/completion/kubens.bash $COMPDIR/kubens
sudo ln -sf ~/.kubectx/completion/kubectx.bash $COMPDIR/kubectx
cat << FOE >> ~/.bashrc

#kubectx and kubens
export PATH=~/.kubectx:\$PATH
FOE
```

Useful commands:

```bash
kubectx -u # logout of the cluster
kubectx # list the clusters registered on the local machine
kubectx NOME_DO_CLUSTER # login a cluster previously registered on the local machine
kubectx -d NOME_DO_CLUSTER # remove a cluster previously registered on the local machine
kubens # list the namespaces of a cluster
kubens NAMESPACE # switch to a previously created namespace in the cluster with the ``kubectl create ns NAMESPACE`` command
```

# Custom Terminal Prompt

To show the branch name, current directory, authenticated k8s cluster and namespace in use, there are several open source projects that provide this and you can choose the one you like best.

zsh:

- <https://ohmyz.sh/>
- <https://www.2vcps.io/2020/07/02/oh-my-zsh-fix-my-command-prompt/>

bash:

- <https://github.com/ohmybash/oh-my-bash>
- <https://github.com/jonmosco/kube-ps1>

## bash_prompt

```bash
curl -o ~/.bash_prompt https://gist.githubusercontent.com/aeciopires/6738c602e2d6832555d32df78aa3b9bb/raw/b96be4dcaee6db07690472aecbf73fcf953a7e91/.bash_prompt
chmod +x ~/.bash_prompt
echo "source ~/.bash_prompt" >> ~/.bashrc 
source ~/.bashrc
exec bash
```

Result:

1. **lilac (or purple) color**: the username and hostname;
2. **In yellow**: the path of the current directory;
3. **green color**: the name of the branch, will only be displayed if the current directory is related to a git repository;
4. **color red**: the name of the Kubernetes cluster (k8s), to which you are authenticated;
5. **blue color**: the name of the selected namespace in the k8s cluster. If the default namespace is selected, the name will not be displayed.

# Sops

Documentation: <https://github.com/getsops/sops/>

> Before continuing, if you have sops installed, remove it with the following command:

```bash
sudo rm /usr/local/bin/sops
```

> Antes de prosseguir, certifique-se de ter instalado o comando [asdf](#asdf).

```bash
VERSION="3.9.4"

asdf plugin list all | grep sops
asdf plugin add sops https://github.com/feniix/asdf-sops.git
asdf latest sops

asdf install sops $VERSION
asdf list sops

asdf global sops $VERSION
asdf list sops
sops --version
```

An example of the sops configuration file that should be in ``$HOME/.sops.yaml`` file.

```yaml
creation_rules:
# Para ambientes testing/staging
-   path_regex: .*/testing|staging/.*
    kms: arn:aws:kms:us-east-1:4564546546454:key/adsfasdfd-8c6c-sdfsadfdas
    aws_profile: default
# Para ambientes production
-   kms: arn:aws:kms:sa-east-1:4123745646545:key/asdfsdfdsa-8a5b-sdafasdf
    aws_profile: default
```

# terraform e tfenv

Run the following commands to install ``tfenv``, Terraform version controller.

Documentation: <https://github.com/tfutils/tfenv>

```bash
cd $HOME
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
sudo ln -s ~/.tfenv/bin/* /usr/local/bin
```

List versions that can be installed:

```bash
tfenv list-remote
```

Install the following versions of Terraform using tfenv:

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

# terraform-docs

Run the following commands to install terraform-docs.

Documentation: <https://github.com/segmentio/terraform-docs>

```bash
VERSION=v0.19.0

curl -Lo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/$VERSION/terraform-docs-$VERSION-$(uname)-amd64.tar.gz
tar -xzf terraform-docs.tar.gz terraform-docs
chmod +x terraform-docs
sudo mv terraform-docs /usr/local/bin/terraform-docs

rm terraform-docs.tar.gz
terraform-docs --version
```

# terragrunt e tgenv

Run the following commands to install tgenv, Terragrunt's version controller.

Documentation:

- <https://github.com/cunymatthieu/tgenv>
- <https://blog.gruntwork.io/how-to-manage-multiple-versions-of-terragrunt-and-terraform-as-a-team-in-your-iac-project-da5b59209f2d>

```bash
cd $HOME
git clone https://github.com/cunymatthieu/tgenv.git ~/.tgenv
sudo ln -s ~/.tgenv/bin/* /usr/local/bin
```

## Known issue

There is an issue in tgenv versions where very old versions of terragrunt are not remotely installed/listed. This occurs due to a query used in the code <https://github.com/cunymatthieu/tgenv/blob/master/libexec/tgenv-list-remote#L12> that uses GitHub's API. For this, we have two possible workarounds

Workaround 3 (Fix proposed and revised in open PR):
<https://github.com/cunymatthieu/tgenv/pull/15/files>

Change the file ``~/.tgenv/libexec/tgenv-list-remote`` so that it looks exactly like the following:

```bash
#!/usr/bin/env bash
set -e

[ -n "${TGENV_DEBUG}" ] && set -x
source "${TGENV_ROOT}/libexec/helpers"

if [ ${#} -ne 0 ];then
  echo "usage: tgenv list-remote" 1>&2
  exit 1
fi

GITHUB_API_HEADER_ACCEPT="Accept: application/vnd.github.v3+json"

temp=`basename $0`
TMPFILE=`mktemp /tmp/${temp}.XXXXXX` || exit 1

function rest_call {
    curl --tlsv1.2 -sf $1 -H "${GITHUB_API_HEADER_ACCEPT}" | sed -e 's/^\[$//g' -e 's/^\]$/,/g' >> $TMPFILE
}

# single page result-s (no pagination), have no Link: section, the grep result is empty
last_page=`curl -I --tlsv1.2 -s "https://api.github.com/repos/gruntwork-io/terragrunt/tags?per_page=100" -H "${GITHUB_API_HEADER_ACCEPT}" | grep '^link:' | sed -e 's/^link:.*page=//g' -e 's/>.*$//g'`

# does this result use pagination?
if [ -z "$last_page" ]; then
    # no - this result has only one page
    rest_call "https://api.github.com/repos/gruntwork-io/terragrunt/tags?per_page=100"
else
    # yes - this result is on multiple pages
    for p in `seq 1 $last_page`; do
        rest_call "https://api.github.com/repos/gruntwork-io/terragrunt/tags?per_page=100&page=$p"
    done
fi

return_code=$?
if [ $return_code -eq 22 ];then
  warn_and_continue "Failed to get list verion on $link_release"
  print=`cat ${TGENV_ROOT}/list_all_versions_offline`
fi

cat $TMPFILE | grep -o -E "[0-9]+\.[0-9]+\.[0-9]+(-(rc|beta)[0-9]+)?" | uniq
```

List the versions that can be installed:

```bash
tgenv list-remote
```

Install the following versions of Terragrunt using tgenv:

```bash
tgenv install 0.72.6
```

List the installed versions:

```bash
tgenv list
```

Set the default to a certain version:

```bash
tgenv use 0.72.6
```

To uninstall a terraform version with tfenv, use the following command:

```bash
tgenv uninstall <VERSAO>
```

Only when developing code that uses terragrunt can you force the project to use a specific version:

Create the ``.terragrunt-version`` file in the project root with the desired version number. Example:

```bash
cat .terragrunt-version
0.72.6
```

# [OPTIONAL] Aliases

## bashrc

Useful aliases to be registered in the ``$HOME/.bashrc`` file.

> After inclusion, run the command ``source ~/.bashrc`` to reflect the changes.

```bash
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias aws_docker='docker run --rm -ti -v ~/.aws:/root/.aws -v $(pwd):/aws public.ecr.aws/aws-cli/aws-cli:2.22.28'
alias bat='bat --theme ansi'
alias connect_eks='aws eks --region CHANGE_REGION update-kubeconfig --name CHANGE_CLUSTER --profile CHANGE_PROFILE'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias k='kubectl'
source <(kubectl completion bash)
export PATH="${PATH}:${HOME}/.krew/bin"
alias kubectl='kubecolor'
alias kmongo='kubectl run --rm -it mongoshell-$(< /dev/urandom tr -dc a-z-0-9 | head -c${1:-4}) --image=mongo:4.0.28 -n default -- bash'
alias kmysql5='kubectl run --rm -it mysql5-$(< /dev/urandom tr -dc a-z-0-9 | head -c${1:-4}) --image=mysql:5.7 -n default -- bash'
alias kmysql8='kubectl run --rm -it mysql8-$(< /dev/urandom tr -dc a-z-0-9 | head -c${1:-4}) --image=mysql:8.0 -n default -- bash'
alias kredis='kubectl run --rm -it redis-cli-$(< /dev/urandom tr -dc a-z-0-9 | head -c${1:-4}) --image=redis:latest -n default -- bash'
alias kpgsql14='kubectl run --rm -it pgsql14-$(< /dev/urandom tr -dc a-z-0-9 | head -c${1:-4}) --image=postgres:14 -n default -- bash'
alias kssh='kubectl run --rm -it ssh-agent-$(< /dev/urandom tr -dc a-z-0-9 | head -c${1:-4}) --image=kroniak/ssh-client -n default -- bash'
alias l='ls -CF'
alias la='ls -A'
alias live='curl parrot.live'
alias ll='ls -alF'
alias ls='ls --color=auto'
alias nettools='kubectl run --rm -it nettools-\$(< /dev/urandom tr -dc a-z-0-9 | head -c${1:-4}) --image=aeciopires/nettools:2.0.0 -n NAMESPACE'
alias randompass='< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16}'
# Ubuntu 22.04/24.04
alias set-dns-cabeado='sudo resolvectl dns enp7s0 1.1.1.1'
alias set-dns-wifi='sudo resolvectl dns wlp6s0 1.1.1.1'
alias show-hidden-files='du -sch .[!.]* * |sort -h'
alias ssm='aws ssm start-session --target CHANGE_EC2_ID --region CHANGE_REGION --profile CHANGE_PROFILE'
alias terradocs='terraform-docs markdown table . > README.md'
alias alertmanager='aws eks --region CHANGE_REGION update-kubeconfig --name CHANGE_CLUSTER --profile CHANGE_PROFILE && kubectl port-forward alertmanager-monitor-alertmanager-0 9093:9093 -n monitoring ; kubectx -'
alias prometheus='kubectl port-forward prometheus-monitor-prometheus-0 9090:9090 -n monitoring'
alias sc="source $HOME/.bashrc"
alias randompass='pwgen 16 1'
alias randompass2='date +%s | sha3sum | base64 | head -c 12; echo'
alias sc="source $HOME/.bashrc"
alias python=python3
alias pip=pip3
alias kubepug="kubectl-depreciations"
alias kind_create="kind create cluster --name kind-multinodes --config $HOME/kind-3nodes.yaml"
alias kind_delete="kind delete clusters \$(kind get clusters)"
```

# [OPTIONAL] kind

Kind (Kubernetes in Docker) is another alternative for running Kubernetes in a local environment for testing and learning, but it is not recommended for production use.

To install kind, run the following commands.

> Before continuing, if you have kind installed, remove it with the following command:

```bash
sudo rm /usr/local/bin/kind
```

> Before proceeding, make sure you have installed the command [asdf](#asdf).

```bash
VERSION="0.26.0"
asdf plugin list all | grep kind
asdf plugin add kind https://github.com/johnlayton/asdf-kind.git
asdf latest kind
asdf install kind $VERSION
asdf list kind
# Setting the global version
asdf global kind $VERSION
```

To create a cluster with multiple local nodes with Kind, create a YAML file to define the number and type of nodes in the cluster you want.

In the following example, the file ``$HOME/kind-3nodes.yaml`` will be created to specify a cluster with 1 master node (which will run the Kubernetes control plane) and 2 workers (which will run the Kubernetes data plane) .

```bash
cat << EOF > $HOME/kind-3nodes.yaml
# References:
# Kind release image: https://github.com/kubernetes-sigs/kind/releases
# Configuration: https://kind.sigs.k8s.io/docs/user/configuration/
# Metal LB in Kind: https://kind.sigs.k8s.io/docs/user/loadbalancer
# Ingress in Kind: https://kind.sigs.k8s.io/docs/user/ingress

# Config compatible with kind v0.26.0
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  podSubnet: "10.244.0.0/16"
  serviceSubnet: "10.96.0.0/12"
nodes:
  - role: control-plane
    image: kindest/node:v1.32.0@sha256:c48c62eac5da28cdadcf560d1d8616cfa6783b58f0d94cf63ad1bf49600cb027
    kubeadmConfigPatches:
    - |
      kind: InitConfiguration
      nodeRegistration:
        kubeletExtraArgs:
          node-labels: "nodeapp=loadbalancer"
    extraPortMappings:
    - containerPort: 80
      hostPort: 80
      listenAddress: "0.0.0.0" # Optional, defaults to "0.0.0.0"
      protocol: TCP
    - containerPort: 443
      hostPort: 443
      listenAddress: "0.0.0.0" # Optional, defaults to "0.0.0.0"
      protocol: TCP
  - role: worker
    image: kindest/node:v1.32.0@sha256:c48c62eac5da28cdadcf560d1d8616cfa6783b58f0d94cf63ad1bf49600cb027
  - role: worker
    image: kindest/node:v1.32.0@sha256:c48c62eac5da28cdadcf560d1d8616cfa6783b58f0d94cf63ad1bf49600cb027
EOF
```

Create a cluster called ``kind-multinodes`` using the specifications defined in the ``$HOME/kind-3nodes.yaml`` file.

```bash
kind create cluster --name kind-multinodes --config $HOME/kind-3nodes.yaml
```

To view your clusters using kind, run the following command.

```bash
kind get clusters
```

To destroy the cluster, run the following command which will select and remove all local clusters created in Kind.

```bash
kind delete clusters $(kind get clusters)
```

References:

- <https://github.com/badtuxx/DescomplicandoKubernetes/blob/master/day-1/DescomplicandoKubernetes-Day1.md#kind>
- <https://kind.sigs.k8s.io/docs/user/quick-start/>
- <https://github.com/kubernetes-sigs/kind/releases>
- <https://kubernetes.io/blog/2020/05/21/wsl-docker-kubernetes-on-the-windows-desktop/#kind-kubernetes-made-easy-in-a-container>

# [OPTIONAL] trivy

Installing trivy via asdf

> Before proceeding, make sure you have installed the command [asdf](#asdf).

```bash
VERSION="0.58.0"

asdf plugin list all | grep trivy
asdf plugin add trivy https://github.com/zufardhiyaulhaq/asdf-trivy.git
asdf latest trivy

asdf install trivy $VERSION
asdf list trivy

# Setting the global version
asdf global trivy $VERSION
asdf list trivy
```

## Installing trivy using Docker

To scan Docker images for vulnerabilities locally, before uploading to Docker Hub, ECR, GCR or another remote registry, you can use trivy: <https://github.com/aquasecurity/trivy>

The documentation on GitHub presents information about installation on Ubuntu and other GNU/Linux distributions and/or other operating systems, but it is also possible to run via Docker using the following commands:

```bash
mkdir /tmp/caches
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /tmp/caches:/root/.cache/ aquasec/trivy image IMAGE_NAME:IMAGE_TAG
```
