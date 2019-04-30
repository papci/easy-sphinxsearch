FROM ubuntu:18.10
RUN apt update
RUN apt install curl gnupg wget -y
RUN   curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN   curl https://packages.microsoft.com/config/ubuntu/18.10/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN   apt-get update
RUN   ACCEPT_EULA=Y apt-get install msodbcsql17 -y
# optional: for bcp and sqlcmd
RUN   ACCEPT_EULA=Y apt-get install mssql-tools -y
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

RUN   apt install unixodbc-dev -y


RUN wget  http://sphinxsearch.com/files/sphinx-3.1.1-612d99f-linux-amd64.tar.gz -O /tmp/sphinxsearch.tar.gz
RUN mkdir  /opt/sphinx
RUN cd /opt/sphinx && tar -xf /tmp/sphinxsearch.tar.gz
RUN rm /tmp/sphinxsearch.tar.gz
ENV PATH "${PATH}:/opt/sphinx/sphinx-3.1.1/bin"
RUN indexer -v



# redirect logs to stdout
RUN mkdir /opt/sphinx/log/ 
RUN ln -sv /dev/stdout /opt/sphinx/log/query.log
RUN ln -sv /dev/stdout /opt/sphinx/log/searchd.log

# expose TCP port
EXPOSE 36307

VOLUME /opt/sphinx/conf
VOLUME /opt/sphinx/data
VOLUME /opt/sphinx/log


# run indexing
CMD indexer --rotate --all
CMD searchd --nodetach --config /opt/sphinx/conf/sphinx.conf