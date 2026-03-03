# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.19 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.19
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
ENV __doozer_group=openshift-4.19
ENV __doozer_key=ptp-operator
ENV __doozer_version=4.19.0
ENV __doozer_release=20260303153118
ENV __doozer_bundle_nvrs=ose-ptp-operator-metadata-container-v4.19.0.202603031419.p2.g96c0870.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/ptp-operator
LABEL io.openshift.build.commit.id=96c0870b4962df790f7c29bf5a3bf1e88343dfb0
LABEL com.redhat.art.name=ptp-operator-fbc
LABEL com.redhat.art.nvr=ptp-operator-fbc-4.19.0-20260303153118
