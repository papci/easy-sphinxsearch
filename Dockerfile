FROM ubuntu:18.10
RUN apt update
RUN apt install curl gnupg wget cron -y
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/18.10/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install msodbcsql17 -y
# optional: for bcp and sqlcmd
RUN ACCEPT_EULA=Y apt-get install mssql-tools -y
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

RUN   apt install unixodbc-dev -y


RUN wget  http://sphinxsearch.com/files/sphinx-3.1.1-612d99f-linux-amd64.tar.gz -O /tmp/sphinxsearch.tar.gz
RUN mkdir  /opt/sphinx
RUN cd /opt/sphinx && tar -xf /tmp/sphinxsearch.tar.gz
RUN rm /tmp/sphinxsearch.tar.gz
ENV PATH "${PATH}:/opt/sphinx/sphinx-3.1.1/bin"
RUN indexer -v


# expose TCP port
EXPOSE 36307

VOLUME /opt/sphinx/conf
VOLUME /opt/sphinx/data
VOLUME /opt/sphinx/log
VOLUME /opt/odbc
VOLUME /opt/cron

# run everything
CMD cp /opt/odbc/* /etc/ && \
    indexer --config  /opt/sphinx/conf/sphinx.conf --rotate --all > /opt/sphinx/log/firsttime.log && \
    cp /opt/cron/* /etc/crond.d/ && \
    chmod 0644 /etc/crond.d/* && \
    touch /var/log/cron.log && \
    cron && \
    searchd --nodetach --config /opt/sphinx/conf/sphinx.conf