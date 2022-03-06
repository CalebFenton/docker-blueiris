FROM phusion/baseimage:hirsute

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Configure user nobody to match unRAID's settings
 RUN \
    usermod -u 99 nobody && \
    usermod -g 100 nobody && \
    usermod -d /config nobody && \
    chown -R nobody:users /home

ENV WINEPREFIX /root/prefix32
ENV WINEARCH win32
ENV DISPLAY :0

RUN \
    apt update && \
    apt -y upgrade && \
    apt -y install xvfb x11vnc xdotool wget supervisor cabextract websockify net-tools unzip && \
    apt clean

RUN \
    dpkg --add-architecture i386 && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 76F1A20FF987672F && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv F987672F && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ hirsute main' && \
    apt-add-repository 'deb https://download.mono-project.com/repo/ubuntu stable-focal main' && \
    apt update && \
    apt -y install --allow-unauthenticated --install-recommends winehq-devel mono-complete && \
    apt clean && \
    # install winetricks
    wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks --directory-prefix /usr/bin/ && \
    chmod +x /usr/bin/winetricks && \
    sh /usr/bin/winetricks corefonts wininet && \
    # move prefix over
    mv /root/prefix32 /root/prefix32_original && \
    mkdir /root/prefix32

COPY novnc /root/novnc/
COPY www /root/www/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY blueiris.sh /root/blueiris.sh
RUN chmod +x /root/blueiris.sh

COPY install_www.sh /root/install_www.sh
RUN chmod +x /root/install_www.sh

WORKDIR /root/

EXPOSE 8080

CMD ["/usr/bin/supervisord"]
