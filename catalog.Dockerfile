# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.21 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.21
# The base image is expected to contain
# /bin/opm (with serve subcommand) and /bin/grpc_health_probe

# Configure the entrypoint and command
ENTRYPOINT ["/bin/opm"]
CMD ["serve", "/configs", "--cache-dir=/tmp/cache"]

COPY --from=builder /configs /configs
COPY --from=builder /tmp/cache /tmp/cache

# Set FBC-specific label for the location of the FBC root directory
# in the image
LABEL operators.operatorframework.io.index.configs.v1=/configs
ENV __doozer_group=logging-6.5
ENV __doozer_key=loki-operator
ENV __doozer_version=6.5.4
ENV __doozer_release=20261028165343.ocp4.21
ENV __doozer_bundle_nvrs=loki-rhel9-operator-metadata-container-6.5.4.202610281621.p2.g823825c.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/loki
LABEL io.openshift.build.commit.id=823825c8c5fc128651d43fdaeb0b48aeb1068550
LABEL com.redhat.art.name=loki-operator-fbc
LABEL com.redhat.art.nvr=loki-operator-fbc-6.5.4-20261028165343.ocp4.21
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift-logging/loki-operator-bundle@sha256:f8f0d964aaf963dbcd9b5dfda897279ae5474e283bf100b049caa07819336760
