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
ENV __doozer_group=quay-3.15
ENV __doozer_key=quay-bridge-operator
ENV __doozer_version=3.15.9
ENV __doozer_release=20261112002827.ocp4.22
ENV __doozer_bundle_nvrs=quay-bridge-operator-metadata-container-3.15.9.202611112203.p2.g6c2aa2c.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/quay/quay-bridge-operator
LABEL io.openshift.build.commit.id=6c2aa2c87faf9e2bc1762245d37d19d67e7e51dd
LABEL com.redhat.art.name=quay-bridge-operator-fbc
LABEL com.redhat.art.nvr=quay-bridge-operator-fbc-3.15.9-20261112002827.ocp4.22
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/quay/quay-bridge-operator-bundle@sha256:b9c0c0924b685a32b6a19a9072b86e669b0470f30a47ef5a537bc05fe11933d5
