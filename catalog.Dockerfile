# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.21 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.21
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
ENV __doozer_group=openshift-4.21
ENV __doozer_key=sriov-network-operator
ENV __doozer_version=4.21.0
ENV __doozer_release=20251001100631
ENV __doozer_bundle_nvrs=sriov-network-operator-metadata-container-v4.21.0.202510010824.p2.g4438a1f.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/sriov-network-operator
LABEL io.openshift.build.commit.id=4438a1ffa4c0ae78a11467945ea2dd78d21e14bc
LABEL com.redhat.art.name=sriov-network-operator-fbc
LABEL com.redhat.art.nvr=sriov-network-operator-fbc-4.21.0-20251001100631
