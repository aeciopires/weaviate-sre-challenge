<!-- TOC -->

- [Ubuntu](#ubuntu)
  - [Essential](#essential)
  - [Optionals](#optionals)
- [Git](#git)
- [asdf](#asdf)
- [awscli](#awscli)
- [docker](#docker)
- [docker-compose](#docker-compose)
- [Helm](#helm)
- [helm-docs](#helm-docs)
- [helm-diff - Plugin](#helm-diff---plugin)
- [helm-secrets - Plugin](#helm-secrets---plugin)
- [kubectl](#kubectl)
  - [kubectx e kubens](#kubectx-e-kubens)
- [Custom Terminal Prompt](#custom-terminal-prompt)
  - [bash\_prompt](#bash_prompt)
- [Sops](#sops)
- [terraform e tfenv](#terraform-e-tfenv)
- [terraform-docs](#terraform-docs)
- [kind](#kind)
- [Trivy](#trivy)

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

# kind

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

# Trivy

To scan Docker images for vulnerabilities locally, before uploading to Docker Hub, ECR, GCR or another remote registry, you can use trivy: <https://github.com/aquasecurity/trivy>

The documentation on GitHub presents information about installation on Ubuntu and other GNU/Linux distributions and/or other operating systems, but it is also possible to run via Docker using the following commands:

```bash
mkdir /tmp/caches
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /tmp/caches:/root/.cache/ aquasec/trivy image IMAGE_NAME:IMAGE_TAG
```
