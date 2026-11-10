# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.23 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.23
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
ENV __doozer_group=openshift-4.23
ENV __doozer_key=ose-aws-efs-csi-driver-operator
ENV __doozer_version=4.23.0
ENV __doozer_release=20261110221628
ENV __doozer_bundle_nvrs=ose-aws-efs-csi-driver-operator-bundle-container-v4.23.0.202611101744.p2.g3974a8b.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/csi-operator
LABEL io.openshift.build.commit.id=3974a8b545f06a7f18f442cdcf472b69475d83ad
LABEL com.redhat.art.name=ose-aws-efs-csi-driver-operator-fbc
LABEL com.redhat.art.nvr=ose-aws-efs-csi-driver-operator-fbc-4.23.0-20261110221628
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-aws-efs-csi-driver-operator-bundle@sha256:d6c617055b1cb46cbfda6c81b67cac690e240616ca9a7ff8b109436fdf276c0c
