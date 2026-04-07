# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.20 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.20
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
ENV __doozer_group=openshift-4.20
ENV __doozer_key=dpu-operator
ENV __doozer_version=4.20.0
ENV __doozer_release=20260407163009
ENV __doozer_bundle_nvrs=dpu-operator-bundle-container-v4.20.0.202604070841.p2.ga462d40.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/dpu-operator
LABEL io.openshift.build.commit.id=a462d4011c21ff38aeab9b65c0c16aed44257d1e
LABEL com.redhat.art.name=dpu-operator-fbc
LABEL com.redhat.art.nvr=dpu-operator-fbc-4.20.0-20260407163009
