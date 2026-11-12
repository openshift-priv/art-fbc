# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.17 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.17
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
ENV __doozer_group=openshift-4.17
ENV __doozer_key=sriov-network-operator
ENV __doozer_version=4.17.0
ENV __doozer_release=20261112040317
ENV __doozer_bundle_nvrs=sriov-network-operator-metadata-container-v4.17.0.202611110238.p2.ge0c6ea2.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/sriov-network-operator
LABEL io.openshift.build.commit.id=e0c6ea20fd4d6f9c831e71e6205e5cb403ecdfc2
LABEL com.redhat.art.name=sriov-network-operator-fbc
LABEL com.redhat.art.nvr=sriov-network-operator-fbc-4.17.0-20261112040317
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-sriov-network-operator-bundle@sha256:a6a6a2beb89fe4a69d02acc5a5882bebd5ec44e16ec823f6f513d5913eaaf193
