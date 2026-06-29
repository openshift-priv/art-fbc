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
ENV __doozer_group=openshift-4.12
ENV __doozer_key=local-storage-operator
ENV __doozer_version=4.12.0
ENV __doozer_release=20260629094115
ENV __doozer_bundle_nvrs=local-storage-operator-metadata-container-v4.12.0.202606290825.p2.g1284973.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/local-storage-operator
LABEL io.openshift.build.commit.id=12849734ab5bda4bbecebe2c1242a6d8a4e86b67
LABEL com.redhat.art.name=local-storage-operator-fbc
LABEL com.redhat.art.nvr=local-storage-operator-fbc-4.12.0-20260629094115
