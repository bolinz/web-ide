FROM centos:7
RUN yum update -y && yum install -y git make pkgconfig gcc gcc-c++ libX11-devel.x86_64 libxkbfile-devel.x86-64 libsecret-devel libxkbfile
ENV NODE_DISTRO linux-x64
ENV NODE_VERSION v12.16.3
ENV NODE_DOWNLOAD_URL "https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-${NODE_DISTRO}.tar.xz"
RUN curl -L -O "${NODE_DOWNLOAD_URL}" && \
mkdir -p /usr/local/lib/nodejs && \
tar -xJvf node-${NODE_VERSION}-${NODE_DISTRO}.tar.xz -C /usr/local/lib/nodejs && \
export PATH=/usr/local/lib/nodejs/node-${NODE_VERSION}-${NODE_DISTRO}/bin:$PATH && \
npm install --global yarn
ENV PATH /usr/local/lib/nodejs/node-${NODE_VERSION}-${NODE_DISTRO}/bin:$PATH
RUN git clone https://github.com/microsoft/vscode.git
WORKDIR /vscode
RUN LAST_RELEASE=$(git branch -a |grep -o "release.*"|sort -r|head -n 1) && \
git checkout -b ${LAST_RELEASE} origin/${LAST_RELEASE}
RUN yarn install
RUN yarn watch

EXPOSE 8080

ENTRYPOINT ["yarn","web"]