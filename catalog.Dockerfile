# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.22 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.22
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
ENV __doozer_group=logging-6.6
ENV __doozer_key=loki-operator
ENV __doozer_version=6.6.2
ENV __doozer_release=20261028082253.ocp4.22
ENV __doozer_bundle_nvrs=loki-rhel9-operator-metadata-container-6.6.2.202610280715.p2.g02462af.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/loki
LABEL io.openshift.build.commit.id=02462af26855baaffffb1be2cec710a4eb864287
LABEL com.redhat.art.name=loki-operator-fbc
LABEL com.redhat.art.nvr=loki-operator-fbc-6.6.2-20261028082253.ocp4.22
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift-logging/loki-operator-bundle@sha256:4958233962b5bf09638cae07c2f43265df52c5e9fd75b95cc586448bd52b4e18
