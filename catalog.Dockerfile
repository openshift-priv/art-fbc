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
ENV __doozer_group=oadp-1.4
ENV __doozer_key=oadp-operator
ENV __doozer_version=1.4.12
ENV __doozer_release=20261020051003.ocp4.17
ENV __doozer_bundle_nvrs=oadp-operator-metadata-container-1.4.12.202610200414.p2.g75dc5ec.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/oadp-operator
LABEL io.openshift.build.commit.id=75dc5ec164f14fd63e78acd7f617c9e72b595930
LABEL com.redhat.art.name=oadp-operator-fbc
LABEL com.redhat.art.nvr=oadp-operator-fbc-1.4.12-20261020051003.ocp4.17
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/oadp/oadp-operator-bundle@sha256:97747b213f20e7e735b03c55e8f2f9a029373030240d838e50f437e1fef4bab0
