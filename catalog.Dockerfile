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
ENV __doozer_key=dpu-operator
ENV __doozer_version=4.19.0
ENV __doozer_release=20251018092259
ENV __doozer_bundle_nvrs=dpu-operator-bundle-container-v4.19.0.202510172045.p2.g0d8f538.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/dpu-operator
LABEL io.openshift.build.commit.id=0d8f538fb6fa144cf854dc009988e38421237e7a
LABEL com.redhat.art.name=dpu-operator-fbc
LABEL com.redhat.art.nvr=dpu-operator-fbc-4.19.0-20251018092259
