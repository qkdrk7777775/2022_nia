FROM ufoym/deepo:latest
RUN apt-get update && \
    apt-get upgrade -y

RUN apt-get install -y zsh && \
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN apt install curl dirmngr apt-transport-https \
    lsb-release ca-certificates -y && \
    apt install nodejs -y && \
    apt install npm -y 

RUN   curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh  && \
    apt install nodejs -y && \ 
    npm install -g npm  -y

RUN pip uninstall enum34 -y  && \
    pip install pytorch_lightning mxnet-cu112 deepchem wandb \
    typing_extensions tensorflow-gpu pylint pydantic \
    immutables astroid importlib-metadata \
    jedi jedi-language-server \
    jupyterlab_widgets jupyterlab-git \
    jupyterlab_latex  lckr-jupyterlab-variableinspector \
    jupyterlab-drawio jupyterlab-system-monitor \
    jupyterlab-kernelspy \
    jupyterlab_execute_time\
    ipyleaflet \
    jupyterlab-drawio 


RUN jupyter labextension update --all && \
    jupyter labextension install jupyterlab-kernelspy && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
    jupyter labextension install jupyterlab-drawio && \
    jupyter nbextension enable --py --sys-prefix ipyleaflet && \
    jupyter lab build


