# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.17 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.17
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
ENV __doozer_group=openshift-4.17
ENV __doozer_key=ose-smb-csi-driver-operator
ENV __doozer_version=4.17.0
ENV __doozer_release=20261111152350
ENV __doozer_bundle_nvrs=ose-smb-csi-driver-operator-bundle-container-v4.17.0.202611110238.p2.g14fb085.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/csi-operator
LABEL io.openshift.build.commit.id=14fb0852e9a2c68aca971e9c106d38c3c2301c66
LABEL com.redhat.art.name=ose-smb-csi-driver-operator-fbc
LABEL com.redhat.art.nvr=ose-smb-csi-driver-operator-fbc-4.17.0-20261111152350
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-smb-csi-driver-operator-bundle@sha256:4d07a5d144d760aa0362f7c662a36b9c41a90012d4480974b30e47bf68f6606a
