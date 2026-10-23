# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.20 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.20
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
ENV __doozer_group=openshift-4.20
ENV __doozer_key=ose-support-log-gather-operator
ENV __doozer_version=4.20.0
ENV __doozer_release=20261023093228
ENV __doozer_bundle_nvrs=ose-support-log-gather-operator-bundle-container-v4.20.0.202610230250.p2.g9bd9428.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/must-gather-operator
LABEL io.openshift.build.commit.id=9bd9428e2668bc3639ba54c74b749074d1a9e021
LABEL com.redhat.art.name=ose-support-log-gather-operator-fbc
LABEL com.redhat.art.nvr=ose-support-log-gather-operator-fbc-4.20.0-20261023093228
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-support-log-gather-operator-bundle@sha256:745a0c397a33993017d2191ad363464b6081e1483f91afa0e69efc46009c32dc
