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
ENV __doozer_group=openshift-4.16
ENV __doozer_key=ose-aws-efs-csi-driver-operator
ENV __doozer_version=4.16.0
ENV __doozer_release=20261019112245
ENV __doozer_bundle_nvrs=ose-aws-efs-csi-driver-operator-bundle-container-v4.16.0.202610190237.p2.g7f17397.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/aws-efs-csi-driver-operator
LABEL io.openshift.build.commit.id=7f1739766bac13cb49ae57883f201dd51cd2ba94
LABEL com.redhat.art.name=ose-aws-efs-csi-driver-operator-fbc
LABEL com.redhat.art.nvr=ose-aws-efs-csi-driver-operator-fbc-4.16.0-20261019112245
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-aws-efs-csi-driver-operator-bundle@sha256:cf81ba4604226f8cb8f160a4da168472fea506e4a5016031ccccb7accde7a644
