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
ENV __doozer_group=oadp-1.4
ENV __doozer_key=oadp-operator
ENV __doozer_version=4.18.0
ENV __doozer_release=20251006224320
ENV __doozer_bundle_nvrs=oadp-operator-metadata-container-1.4.6.202510062203.p2.g22099d5.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/oadp-operator
LABEL io.openshift.build.commit.id=22099d5de26b3cb4c430597ac0636d4941215a86
LABEL com.redhat.art.name=oadp-operator-fbc
LABEL com.redhat.art.nvr=oadp-operator-fbc-4.18.0-20251006224320
