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
ENV __doozer_group=openshift-4.22
ENV __doozer_key=ptp-operator
ENV __doozer_version=4.22.0
ENV __doozer_release=20261020084703
ENV __doozer_bundle_nvrs=ose-ptp-operator-metadata-container-v4.22.0.202610200738.p2.g6792a2e.assembly.test.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/ptp-operator
LABEL io.openshift.build.commit.id=6792a2ecec729be5edbf1832540f4d08906418f0
LABEL com.redhat.art.name=ptp-operator-fbc
LABEL com.redhat.art.nvr=ptp-operator-fbc-4.22.0-20261020084703
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-ptp-operator-bundle@sha256:d3cf97b275a0107ca697a733b75b51a72774fff8a54db85b6c30b49436388581
