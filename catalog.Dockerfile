# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.23 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.23
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
ENV __doozer_group=openshift-4.23
ENV __doozer_key=local-storage-operator
ENV __doozer_version=4.23.0
ENV __doozer_release=20261109114007
ENV __doozer_bundle_nvrs=local-storage-operator-metadata-container-v4.23.0.202611090131.p2.g3e6582a.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/local-storage-operator
LABEL io.openshift.build.commit.id=3e6582a04c6bab535600043bd90d7865ff9a3a80
LABEL com.redhat.art.name=local-storage-operator-fbc
LABEL com.redhat.art.nvr=local-storage-operator-fbc-4.23.0-20261109114007
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-local-storage-operator-bundle@sha256:52ffd618e904ff8a07423ac15b1988254cebbf221555b7fc27ac1bb37bc90f1b
