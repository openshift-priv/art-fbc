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
ENV __doozer_key=ose-smb-csi-driver-operator
ENV __doozer_version=4.23.0
ENV __doozer_release=20261106160451
ENV __doozer_bundle_nvrs=ose-smb-csi-driver-operator-bundle-container-v4.23.0.202611060121.p2.g3974a8b.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/csi-operator
LABEL io.openshift.build.commit.id=3974a8b545f06a7f18f442cdcf472b69475d83ad
LABEL com.redhat.art.name=ose-smb-csi-driver-operator-fbc
LABEL com.redhat.art.nvr=ose-smb-csi-driver-operator-fbc-4.23.0-20261106160451
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-smb-csi-driver-operator-bundle@sha256:29c793c545080f685e9ce9c9d703a04ea4818f38b2c3b0951a37aa17301234cb
