# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry:v4.12 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry:v4.12
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
ENV __doozer_group=openshift-4.12
ENV __doozer_key=ose-aws-efs-csi-driver-operator
ENV __doozer_version=4.12.0
ENV __doozer_release=20261105005126
ENV __doozer_bundle_nvrs=ose-aws-efs-csi-driver-operator-bundle-container-v4.12.0.202611041933.p2.g742d4b4.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/openshift/aws-efs-csi-driver-operator
LABEL io.openshift.build.commit.id=742d4b4e5522f2d1c25a6d3d3820f21101c4f262
LABEL com.redhat.art.name=ose-aws-efs-csi-driver-operator-fbc
LABEL com.redhat.art.nvr=ose-aws-efs-csi-driver-operator-fbc-4.12.0-20261105005126
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-aws-efs-csi-driver-operator-bundle@sha256:fbeabb48d9fe1ad04d47523feea0c6ec7dfd1f14b41ee502d93f49a7536e561b
