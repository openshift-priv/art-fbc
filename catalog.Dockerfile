# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.16 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.16
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
ENV __doozer_group=quay-3.18
ENV __doozer_key=quay-operator
ENV __doozer_version=3.18.3
ENV __doozer_release=20261022200404.ocp4.16
ENV __doozer_bundle_nvrs=quay-operator-metadata-container-3.18.3.202610221635.p2.g198abc8.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/quay/quay-operator
LABEL io.openshift.build.commit.id=198abc802adef5817315835e5b9751bb1dce0236
LABEL com.redhat.art.name=quay-operator-fbc
LABEL com.redhat.art.nvr=quay-operator-fbc-3.18.3-20261022200404.ocp4.16
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/quay/quay-operator-bundle@sha256:1413a24f41f4161c3f70d9d349d39593b44045e19b10e5587e184cb20885f48d
