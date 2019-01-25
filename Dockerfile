FROM openjdk:8-jre-slim

MAINTAINER zocker-160

ENV VERSION 3.0.8
ENV DOWNLOAD_URL https://minecraft.curseforge.com/projects/sevtech-ages/files/2570735/download


RUN apt-get update \
	&& apt-get install -y wget unzip

RUN mkdir -p /minecraft/backups

# Setting workdir
WORKDIR /minecraft

RUN wget -O SevTechAgesServer.zip --no-check-certificate "$DOWNLOAD_URL" \
	&& unzip SevTechAgesServer.zip \
	&& rm SevTechAgesServer.zip

# Creating user and downloading files
RUN chmod u+x Install.sh ServerStart.sh \
	&& echo "#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents minecraft_eula)." > eula.txt \
	&& echo "$(date)" >> eula.txt \
	&& echo "eula=TRUE" >> eula.txt

# Running install
RUN /minecraft/Install.sh

# Expose port 25565
EXPOSE 25565

# Expose volume
VOLUME /minecraft/config \
	/minecraft/logs \
	/minecraft/backups \
	/minecraft/world

# Start server
CMD /minecraft/ServerStart.sh
