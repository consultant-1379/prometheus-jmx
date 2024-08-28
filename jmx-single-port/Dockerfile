FROM armdocker.rnd.ericsson.se/proj-ldc/common_base_os/sles:6.17.0-11

ARG PACKAGE_REPO_URL=https://arm.rnd.ki.sw.ericsson.se/artifactory/proj-ldc-repo-rpm-local/common_base_os/sles/6.17.0-11

LABEL GIT_COMMIT=unknown
ARG PRODUCT_REVISION
ARG IMAGE_CREATED
ARG IMAGE_REVISION
ARG IMAGE_VERSION

LABEL com.ericsson.product-number="CXC2012016" \
com.ericsson.product-revision=$PRODUCT_REVISION \
org.opencontainers.image.title="JMX Exporter" \
org.opencontainers.image.created=$IMAGE_CREATED \
org.opencontainers.image.revision=$IMAGE_REVISION \
org.opencontainers.image.vendor="Ericsson" \
org.opencontainers.image.version=$IMAGE_VERSION

ENV VERSION 0.20.0
ENV JAR jmx_prometheus_httpserver-$VERSION.jar
ENV JMX_USER=273948

COPY files/opt/jmx_exporter/config /opt/jmx_exporter/config/
COPY files/opt/jmx_exporter/rules /opt/jmx_exporter/rules
COPY files/opt/jmx_exporter/start.sh /opt/jmx_exporter/
COPY files/opt/jmx_exporter/check_jmx /opt/jmx_exporter/check_jmx
COPY files/opt/jmx_exporter/entrypoint.sh /opt/jmx_exporter/entrypoint.sh
COPY files/stdout-redirect /usr/bin/

RUN echo "273948:x:273948:273948:An Identity for prometheus-jmx:/home/jmx:/bin/bash" >> /etc/passwd
RUN set -x \
    && zypper ar -C -G -f $PACKAGE_REPO_URL?ssl_verify=no LDC-CBO-SLES \
    && zypper ref -f -r LDC-CBO-SLES \
    && zypper -q install -y --no-recommends curl java-11-openjdk-headless shadow \
    && zypper clean --all \
    && zypper rr LDC-CBO-SLES \
    && curl --insecure -L https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64 -o /usr/local/bin/dumb-init \
    && chmod +x /usr/local/bin/dumb-init \
    && curl --insecure -L https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_httpserver/$VERSION/$JAR -o /opt/jmx_exporter/$JAR \
    && mkdir -p /opt/jmx_exporter/rules_official \
    && chown -R $JMX_USER:0 /opt/jmx_exporter \
    && chmod -R g=u /opt/jmx_exporter \
    && chmod +x /opt/jmx_exporter/entrypoint.sh \
    && chmod +x /opt/jmx_exporter/start.sh

USER $JMX_USER
ENTRYPOINT ["/opt/jmx_exporter/entrypoint.sh"]
