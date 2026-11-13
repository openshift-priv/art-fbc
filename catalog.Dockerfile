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
ENV __doozer_key=sriov-network-operator
ENV __doozer_version=4.12.0
ENV __doozer_release=20261113155926
ENV __doozer_bundle_nvrs=sriov-network-operator-metadata-container-v4.12.0.202611130352.p2.g8536318.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/openshift/sriov-network-operator
LABEL io.openshift.build.commit.id=8536318cf847e32c0174fee03534e68fea063cc8
LABEL com.redhat.art.name=sriov-network-operator-fbc
LABEL com.redhat.art.nvr=sriov-network-operator-fbc-4.12.0-20261113155926
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-sriov-network-operator-bundle@sha256:600752e4eb60d45c9c4b0bff13f9bf05bd2ee9c38a78525ff99704a1489b4610
