FROM debian:stable AS debian_resharper

RUN apt update && apt install -y \
    git \
    wget \
    tar \
    software-properties-common \
    gnupg \
    apt-transport-https

RUN wget -O - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg \
    && mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ \
    && wget https://packages.microsoft.com/config/debian/10/prod.list \
    && mv prod.list /etc/apt/sources.list.d/microsoft-prod.list \
    && chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg \
    && chown root:root /etc/apt/sources.list.d/microsoft-prod.list

RUN apt-get update \
    && apt-get install -y \
    dotnet-sdk-3.1 \
    aspnetcore-runtime-3.1 \
    dotnet-runtime-3.1 \
    && rm -rf /var/lib/apt/lists/* && apt autoclean

ADD ./resources/resharper.tar.gz /opt/
RUN ln -s /opt/resharper/resharper.sh /usr/bin/resharper

WORKDIR /inspections
COPY ./scripts/docker-entrypoint.sh /usr/bin/
ENTRYPOINT [ "/usr/bin/docker-entrypoint.sh" ]
