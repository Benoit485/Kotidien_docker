FROM python:3.12.7-bookworm AS build

# Pillow help : https://pillow.readthedocs.io/en/latest/installation/building-from-source.html#external-libraries
RUN apt update \
    && DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends \
        git \
        python3-dev \
        build-essential \
        openssl \
        libssl-dev \
        libc6-dev \
        g++ \
        gcc \
        libtiff5-dev \
        libjpeg-dev  \
        libopenjp2-7-dev \
        zlib1g-dev \
        libfreetype6-dev \
        liblcms2-dev  \
        libwebp-dev  \
        tcl8.6-dev  \
        tk8.6-dev  \
        python3-tk \
        libharfbuzz-dev \
        libfribidi-dev \
        libxcb1-dev \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /app

RUN git clone https://github.com/pantaflex44/kotidien.git /app

RUN /usr/local/bin/python -m pip install --upgrade pip setuptools wheel

#RUN pip3 install --no-cache \
#    PyQt5==5.15.2 \
#    pycountry==20.7.3 \
#    nh-currency==1.0.1 \
#    pyqtgraph==0.11.1 \
#    fpdf2==2.2.0 \
#    ofxtools==0.9.1 \
#    cryptography==2.8 \
#    python-dateutil==2.8.1 \
#    glibc==0.6.1 \
#    six==1.15.0 \
#    pdf2image==1.14.0 \
#    Pillow==7.2.0

# 07/10/2024 Last versions
RUN pip3 install --no-cache \
    PyQt5==5.15.11 \
    pycountry==24.6.1 \
    nh-currency==1.0.1 \
    pyqtgraph==0.13.7 \
    fpdf2==2.8.1 \
    ofxtools==0.9.5 \
    cryptography==43.0.1 \
    python-dateutil==2.9.0 \
    glibc==0.6.1 \
    six==1.16.0 \
    pdf2image==1.17.0 \
    setuptools==75.1.0 \
    Pillow==10.4.0

WORKDIR /app/code

RUN pyrcc5 resources.qrc -o resources.py

RUN pip3 install --no-cache \
    pyinstaller==6.10.0

RUN pyinstaller \
        --clean \
        --distpath ../dist/Kotidien.linux \
        --workpath ../build/linux \
        -y Kotidien.spec

FROM python:3.12.7-slim-bookworm

ARG PUID=1000
ARG PGID=1000

ENV DEBIAN_FRONTEND=noninteractive
ENV XDG_RUNTIME_DIR=/tmp/runtime-kotidien

# Qt5
RUN apt update \
    && apt install -y --no-install-recommends \
        qttools5-dev \
#        qtdeclarative5-dev \
        qtbase5-dev \
        libqt5widgets5 \
        libqt5x11extras5-dev \
        libqt5svg5-dev \
#        libqt5serialport5-dev \
#        qtbase5-private-dev \
#    	qtscript5-dev \
        xorg \
    && apt-get -qq clean \
    && rm -rf /var/lib/apt/lists/*

# Qt5
#RUN apt update  \
#    && apt install -y --no-install-recommends \
#        libudev-dev \
#        libhidapi-dev \
#        libgpiod-dev \
#        mesa-utils \
#        libgl1-mesa-dri \
#        libgl1-mesa-glx \
#    && apt-get -qq clean \
#    && rm -rf /var/lib/apt/lists/*

COPY --from=build /app/dist /app/dist

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN groupadd -g ${PGID} kotidien
RUN useradd -u ${PUID} -g ${PGID} -m kotidien

USER kotidien

WORKDIR /app/dist

ENV DISPLAY=:1
ENV HOME="/home/kotidien"

ENTRYPOINT ["/entrypoint.sh"]

CMD ["./Kotidien.linux/Kotidien"]


