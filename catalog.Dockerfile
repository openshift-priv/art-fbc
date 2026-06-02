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
ENV __doozer_key=ose-support-log-gather-operator
ENV __doozer_version=4.23.0
ENV __doozer_release=20260602140022
ENV __doozer_bundle_nvrs=ose-support-log-gather-operator-bundle-container-v4.23.0.202606020916.p2.g3337e2b.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/must-gather-operator
LABEL io.openshift.build.commit.id=3337e2ba82aa9af09dc0256333d9f4b982b58a2a
LABEL com.redhat.art.name=ose-support-log-gather-operator-fbc
LABEL com.redhat.art.nvr=ose-support-log-gather-operator-fbc-4.23.0-20260602140022
