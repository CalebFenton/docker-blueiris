ARG UBUNTU_RELEASE=20.04
ARG CUDA_VERSION=11.4.1
FROM nvidia/cudagl:${CUDA_VERSION}-runtime-ubuntu${UBUNTU_RELEASE}

ENV HOME /root
ARG DEBIAN_FRONTEND=noninteractive
ARG NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES all
ENV QT_X11_NO_MITSHM=1

# Configure user nobody to match unRAID's settings
RUN \
    usermod -u 99 nobody && \
    usermod -g 100 nobody && \
    usermod -d /config nobody && \
    chown -R nobody:users /home

# Install locales to prevent errors
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    locales \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN \
    apt-get update && \
    apt-get install -y -qq --no-install-recommends \
    apt-transport-https \
    apt-utils \
    cabextract \
    curl \
    fluxbox \
    jq \
    net-tools \
    p7zip-full \
    software-properties-common \
    supervisor \
    unzip \
    websockify \
    x11vnc \
    xdotool \
    xvfb \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install VirtualGL
RUN VIRTUALGL_VERSION=$(curl -fsSL "https://api.github.com/repos/VirtualGL/virtualgl/releases/67016359" | jq -r '.tag_name' | sed 's/[^0-9\.\-]*//g') && \
    curl -fsSL -O https://sourceforge.net/projects/virtualgl/files/virtualgl_${VIRTUALGL_VERSION}_amd64.deb && \
    curl -fsSL -O https://sourceforge.net/projects/virtualgl/files/virtualgl32_${VIRTUALGL_VERSION}_amd64.deb && \
    apt-get update && apt-get install -y --no-install-recommends ./virtualgl_${VIRTUALGL_VERSION}_amd64.deb ./virtualgl32_${VIRTUALGL_VERSION}_amd64.deb && \
    rm virtualgl_${VIRTUALGL_VERSION}_amd64.deb virtualgl32_${VIRTUALGL_VERSION}_amd64.deb && \
    rm -rf /var/lib/apt/lists/* && \
    chmod u+s /usr/lib/libvglfaker.so && \
    chmod u+s /usr/lib/libdlfaker.so && \
    chmod u+s /usr/lib32/libvglfaker.so && \
    chmod u+s /usr/lib32/libdlfaker.so && \
    chmod u+s /usr/lib/i386-linux-gnu/libvglfaker.so && \
    chmod u+s /usr/lib/i386-linux-gnu/libdlfaker.so

ARG ARCH=64
ENV WINEPREFIX /opt/wine/wine${ARCH}
ENV WINEARCH win${ARCH}
ENV DISPLAY :0

# Install Wine and winetricks
ARG WINE_BRANCH=devel
RUN \
    dpkg --add-architecture i386 && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 76F1A20FF987672F && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv F987672F && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' && \
    apt-add-repository 'deb https://download.mono-project.com/repo/ubuntu stable-focal main' && \
    apt-get update && \
    apt-get -y install --allow-unauthenticated --install-recommends \
        winehq-${WINE_BRANCH} \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    curl -fsSL -o /usr/bin/winetricks "https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks" && \
    chmod 755 /usr/bin/winetricks && \
    sh /usr/bin/winetricks -q win10 && \
    # Prefix directory is huge so keep it compressed to keep layer small
    # It's normally a volume, and this file only used first time this is run
    7z a -mmt=8 -m0=PPMd -mx=9 -ms=on ${WINEPREFIX}.7z ${WINEPREFIX} && \
    rm -r ${WINEPREFIX}

COPY novnc /root/novnc/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ARG UID=1000
ARG GID=1000
RUN groupadd -g ${GID} -o blueiris && \
    useradd -m -u ${UID} -g ${GID} -o -s /bin/bash blueiris

RUN mkdir -p /home/blueiris/.fluxbox
COPY menu /home/blueiris/.fluxbox/menu

COPY www /opt/blueiris/www
COPY entrypoint.sh /opt/blueiris/entrypoint.sh
COPY install_www.sh /opt/blueiris/install_www.sh
RUN chmod +x /opt/blueiris/entrypoint.sh && \
    chmod +x /opt/blueiris/install_www.sh && \
    chown -R $UID:$GID /opt/blueiris && \
    chown -R $UID:$GID /home/blueiris

EXPOSE 8080

CMD ["/usr/bin/supervisord"]
