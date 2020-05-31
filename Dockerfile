FROM centos:7
RUN yum install -y git make pkgconfig gcc gcc-c++ libX11-devel.x86_64 libxkbfile-devel.x86-64 libsecret-devel
ENV NODE_DISTRO linux-x64
ENV NODE_VERSION v12.16.3
RUN DOWNLOAD_URL="https://nodejs.org/dist/${VERSION}/node-${VERSION}-${DISTRO}.tar.xz" && \
curl -L -O "${DOWNLOAD_URL}" && \
mkdir -p /usr/local/lib/nodejs && \
tar -xJvf node-$VERSION-$DISTRO.tar.xz -C /usr/local/lib/nodejs && \
export PATH=/usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin:$PATH && \
npm install --global yarn
ENV PATH /usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin:$PATH
RUN git clone https://github.com/microsoft/vscode.git

RUN cd vscode && \
LAST_RELEASE=$(git branch -a |grep -o "release.*"|sort -r|head -n 1) && \
git checkout -b ${LAST_RELEASE} origin/${LAST_RELEASE}

RUN yarn watch

EXPOSE 8080