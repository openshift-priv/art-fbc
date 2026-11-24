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
ENV __doozer_group=quay-3.14
ENV __doozer_key=quay-bridge-operator
ENV __doozer_version=3.14.11
ENV __doozer_release=20261124182836.ocp4.16
ENV __doozer_bundle_nvrs=quay-bridge-operator-metadata-container-3.14.11.202611241502.p2.g9dd6cf4.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/quay/quay-bridge-operator
LABEL io.openshift.build.commit.id=9dd6cf42f9cf1df1d4b9aa6f1dff2503ba64af31
LABEL com.redhat.art.name=quay-bridge-operator-fbc
LABEL com.redhat.art.nvr=quay-bridge-operator-fbc-3.14.11-20261124182836.ocp4.16
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/quay/quay-bridge-operator-bundle@sha256:b86ef3bf158eb046288ef9d5b1bc12382f842fc4a17ead8e43841d8b6a1a0f7c
