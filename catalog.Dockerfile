# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.21 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.21
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
ENV __doozer_group=openshift-4.21
ENV __doozer_key=dpu-operator
ENV __doozer_version=4.21.0
ENV __doozer_release=20250917163524
ENV __doozer_bundle_nvrs=dpu-operator-bundle-container-v4.21.0.202509071644.p2.g68982ff.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/dpu-operator
LABEL io.openshift.build.commit.id=68982ffc315976022d71b17fab3a6cef3dab9cf0
LABEL com.redhat.art.name=dpu-operator-fbc
LABEL com.redhat.art.nvr=dpu-operator-fbc-4.21.0-20250917163524
