FROM gradle:5.4.1-jdk-alpine

ENV PATH="/docToolchain/bin:${PATH}"

USER root
RUN	set -x && \
    apk add --no-cache curl wget zip unzip git bash \
    git \
    graphviz \
    python \
    ruby \
    py-pygments \
    libc6-compat \
    ttf-dejavu && \
    gem install rdoc --no-document && \
    gem install pygments.rb

USER gradle
RUN set -x && \
  git clone https://github.com/docToolchain/docToolchain.git && \
  cd docToolchain && \
  git checkout v1.1.0 && \
  git submodule update -i && \
  ./gradlew tasks

VOLUME [ "/project" ]
WORKDIR /project
ENV GRADLE_USER_HOME=/project/.gradle

ENTRYPOINT [ "/home/gradle/docToolchain/bin/doctoolchain" ]

CMD [ ".", "generateHTML" ]