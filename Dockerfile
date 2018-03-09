FROM jupyter/pyspark-notebook

USER root
# Add SSL
RUN mkdir -p /etc/ssl/secrets
COPY secrets/ /etc/ssl/secrets/
# Add essential packages
RUN apt-get update
RUN apt-get install -y build-essential libtool pkg-config libzmq-dev autoconf automake git curl nano
RUN apt-get install -y python-rpy2
RUN conda install -c r r-essentials r-rjson
# Update Node and NPM
RUN conda install -c conda-forge nodejs
RUN node --version
RUN npm --version
# Add password
COPY jupyter/jupyter_notebook_config.json /home/jovyan/.jupyter/
RUN chmod -R 777 /home/jovyan/

USER $NB_USER
# Install Scala kernel
RUN git clone https://github.com/jupyter-scala/jupyter-scala.git
WORKDIR /home/jovyan/jupyter-scala
RUN ./jupyter-scala
RUN jupyter kernelspec list
# Install NodeJS kernel
RUN git clone https://github.com/notablemind/jupyter-nodejs.git ~/jupyter-nodejs
WORKDIR /home/jovyan/jupyter-nodejs
RUN mkdir -p ~/.ipython/kernels/nodejs/
RUN npm install
RUN node install.js
RUN npm run build
RUN npm run build-ext
RUN jupyter kernelspec install ~/.ipython/kernels/nodejs/ --user
# Install Python requirements
COPY requirements.txt /home/jovyan/
RUN pip install -r /home/jovyan/requirements.txt
# Install NLTK
RUN python -c "import nltk; nltk.download('popular')"
# Custom styling
RUN mkdir -p /home/jovyan/.jupyter/custom
COPY custom/custom.css /home/jovyan/.jupyter/custom/
# Run the notebook
CMD ["/opt/conda/bin/jupyter", "lab"]
