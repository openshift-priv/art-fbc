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
ENV __doozer_group=openshift-4.16
ENV __doozer_key=cluster-nfd-operator
ENV __doozer_version=4.16.0
ENV __doozer_release=20261120225035
ENV __doozer_bundle_nvrs=cluster-nfd-operator-metadata-container-v4.16.0.202611200935.p2.g808cdce.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/cluster-nfd-operator
LABEL io.openshift.build.commit.id=808cdce85b4c01c85e0332b8b0b41f73ceaebba0
LABEL com.redhat.art.name=cluster-nfd-operator-fbc
LABEL com.redhat.art.nvr=cluster-nfd-operator-fbc-4.16.0-20261120225035
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-cluster-nfd-operator-bundle@sha256:5398eb3a7cf4e4ff09a02c088e138425b23522cb9f7241cb27fbb1d8a81d3790
