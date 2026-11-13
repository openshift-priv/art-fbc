# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.16 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.16
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
ENV __doozer_group=logging-6.2
ENV __doozer_key=loki-operator
ENV __doozer_version=6.2.15
ENV __doozer_release=20261113195432.ocp4.16
ENV __doozer_bundle_nvrs=loki-rhel9-operator-metadata-container-6.2.15.202611131913.p2.g15b83a7.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/loki
LABEL io.openshift.build.commit.id=15b83a7937d63c058f4ef94a3bda103255528fa2
LABEL com.redhat.art.name=loki-operator-fbc
LABEL com.redhat.art.nvr=loki-operator-fbc-6.2.15-20261113195432.ocp4.16
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift-logging/loki-operator-bundle@sha256:2303cf6652aa8e4cf5c8cf3b8795f3e1c6d184fb4a94d83a3343539e05aa91ae
