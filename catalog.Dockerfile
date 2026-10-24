# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry:v4.12 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry:v4.12
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
ENV __doozer_release=20261024010153.ocp4.12
ENV __doozer_bundle_nvrs=quay-bridge-operator-metadata-container-3.15.9.202610231821.p2.g5a800a1.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/quay/quay-bridge-operator
LABEL io.openshift.build.commit.id=5a800a18f29a1f842d5caae2b0d06bdee9115cc2
LABEL com.redhat.art.name=quay-bridge-operator-fbc
LABEL com.redhat.art.nvr=quay-bridge-operator-fbc-3.15.9-20261024010153.ocp4.12
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/quay/quay-bridge-operator-bundle@sha256:1ba81cfa05778e5920c53f28b77155acfac8e678ffbb0d5f9d2c0c7b5324d5e8
