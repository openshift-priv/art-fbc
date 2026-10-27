# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.22 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.22
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
ENV __doozer_group=openshift-4.22
ENV __doozer_key=ose-smb-csi-driver-operator
ENV __doozer_version=4.22.0
ENV __doozer_release=20261027062033
ENV __doozer_bundle_nvrs=ose-smb-csi-driver-operator-bundle-container-v4.22.0.202610262217.p2.gac56459.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/csi-operator
LABEL io.openshift.build.commit.id=ac564599111768d06ab6c8347d7397aed7de3ed3
LABEL com.redhat.art.name=ose-smb-csi-driver-operator-fbc
LABEL com.redhat.art.nvr=ose-smb-csi-driver-operator-fbc-4.22.0-20261027062033
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-smb-csi-driver-operator-bundle@sha256:99e808abc9b24737d2466eddb3c3f1f0ca51bdb24e06bd83d3014243b182b74b
