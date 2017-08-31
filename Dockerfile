FROM continuumio/anaconda3
ADD requirements.txt /
RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y python-rpy2
RUN conda install -c r r-essentials r-rjson
RUN pip install -r requirements.txt
CMD ["/opt/conda/bin/jupyter", "notebook", "--notebook-dir=/opt/notebooks", "--ip='*'", "--no-browser", "--allow-root"]
