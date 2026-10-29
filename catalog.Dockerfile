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
ENV __doozer_release=20261029104051
ENV __doozer_bundle_nvrs=ose-ptp-operator-metadata-container-v4.19.0.202610290933.p2.g3836778.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/ptp-operator
LABEL io.openshift.build.commit.id=3836778baa548814205ad72e2618db1a10338b96
LABEL com.redhat.art.name=ptp-operator-fbc
LABEL com.redhat.art.nvr=ptp-operator-fbc-4.19.0-20261029104051
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-ptp-operator-bundle@sha256:ee0625a44376727322e0e475395c6d5abaa2c9f577a32c8704316542d136a131
