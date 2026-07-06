# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v5.0 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v5.0
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
ENV __doozer_group=openshift-5.0
ENV __doozer_key=local-storage-operator
ENV __doozer_version=5.0.0
ENV __doozer_release=20260706211448
ENV __doozer_bundle_nvrs=local-storage-operator-metadata-container-v5.0.0.202607061906.p2.gb4a98b6.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/local-storage-operator
LABEL io.openshift.build.commit.id=b4a98b678edd37877a0de3a6b4c4e1adab72611c
LABEL com.redhat.art.name=local-storage-operator-fbc
LABEL com.redhat.art.nvr=local-storage-operator-fbc-5.0.0-20260706211448
