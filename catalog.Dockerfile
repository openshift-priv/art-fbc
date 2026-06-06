# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v5.0 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v5.0
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
ENV __doozer_group=openshift-5.0
ENV __doozer_key=ose-aws-efs-csi-driver-operator
ENV __doozer_version=5.0.0
ENV __doozer_release=20260606094504
ENV __doozer_bundle_nvrs=ose-aws-efs-csi-driver-operator-bundle-container-v5.0.0.202606060450.p2.g5021458.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/csi-operator
LABEL io.openshift.build.commit.id=5021458d94df6f749bfb61b5eab719129a27c836
LABEL com.redhat.art.name=ose-aws-efs-csi-driver-operator-fbc
LABEL com.redhat.art.nvr=ose-aws-efs-csi-driver-operator-fbc-5.0.0-20260606094504
