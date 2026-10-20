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
ENV __doozer_key=ose-support-log-gather-operator
ENV __doozer_version=4.21.0
ENV __doozer_release=20261020183607
ENV __doozer_bundle_nvrs=ose-support-log-gather-operator-bundle-container-v4.21.0.202610201702.p2.g8a1697a.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/must-gather-operator
LABEL io.openshift.build.commit.id=8a1697ac00ed16f4a3e7260a8bfa28d7bfa6d20c
LABEL com.redhat.art.name=ose-support-log-gather-operator-fbc
LABEL com.redhat.art.nvr=ose-support-log-gather-operator-fbc-4.21.0-20261020183607
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-support-log-gather-operator-bundle@sha256:a34f8893b0e8cb4f63f5a1930b2e6198e8126ab7f5b5874c0d033776d7ffd627
