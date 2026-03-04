# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.22 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.22
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
ENV __doozer_group=logging-6.5
ENV __doozer_key=cluster-logging-operator
ENV __doozer_version=6.5.0
ENV __doozer_release=20260304152205
ENV __doozer_bundle_nvrs=ose-cluster-logging-operator-metadata-container-6.5.0.202603041458.p2.g7d6b32e.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/cluster-logging-operator
LABEL io.openshift.build.commit.id=7d6b32e8d2b9f29e5a7a83be7074c7e953409f80
LABEL com.redhat.art.name=cluster-logging-operator-fbc
LABEL com.redhat.art.nvr=cluster-logging-operator-fbc-6.5.0-20260304152205
