# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.15 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.15
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
ENV __doozer_group=openshift-4.15
ENV __doozer_key=sriov-network-operator
ENV __doozer_version=4.15.0
ENV __doozer_release=20261015071514
ENV __doozer_bundle_nvrs=sriov-network-operator-metadata-container-v4.15.0.202610141915.p2.ge93cb06.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/sriov-network-operator
LABEL io.openshift.build.commit.id=e93cb06a37634db13a8cd4b1de0863daf4bf9c85
LABEL com.redhat.art.name=sriov-network-operator-fbc
LABEL com.redhat.art.nvr=sriov-network-operator-fbc-4.15.0-20261015071514
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-sriov-network-operator-bundle@sha256:ea688f2855b27834cfa8079a7b8e3f7a2d681e52d34bea06063fec2eb855843d
