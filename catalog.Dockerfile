# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry:v4.14 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry:v4.14
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
ENV __doozer_release=20261124014722.ocp4.14
ENV __doozer_bundle_nvrs=quay-bridge-operator-metadata-container-3.14.11.202611232308.p2.g9f08af7.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/quay/quay-bridge-operator
LABEL io.openshift.build.commit.id=9f08af755fcc3baffb4b4bce940ff2cd65a23722
LABEL com.redhat.art.name=quay-bridge-operator-fbc
LABEL com.redhat.art.nvr=quay-bridge-operator-fbc-3.14.11-20261124014722.ocp4.14
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/quay/quay-bridge-operator-bundle@sha256:395a62c546855f71edf0935b764e03acf2c1478c0fb46a5ab0d7ac7e61a707d5
