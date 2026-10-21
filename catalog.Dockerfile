# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry:v4.13 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry:v4.13
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
ENV __doozer_group=openshift-4.13
ENV __doozer_key=sriov-network-operator
ENV __doozer_version=4.13.0
ENV __doozer_release=20261021001120
ENV __doozer_bundle_nvrs=sriov-network-operator-metadata-container-v4.13.0.202610202015.p2.g76b1754.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/openshift/sriov-network-operator
LABEL io.openshift.build.commit.id=76b17549ad848b61f20498ef081d45db827a068d
LABEL com.redhat.art.name=sriov-network-operator-fbc
LABEL com.redhat.art.nvr=sriov-network-operator-fbc-4.13.0-20261021001120
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-sriov-network-operator-bundle@sha256:e2abda517fc1a95f40916a1caa9e1d3f5d7ef8b753f97203f305ced79b92b52b
