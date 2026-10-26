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
ENV __doozer_key=ose-smb-csi-driver-operator
ENV __doozer_version=4.16.0
ENV __doozer_release=20261026183755
ENV __doozer_bundle_nvrs=ose-smb-csi-driver-operator-bundle-container-v4.16.0.202610260938.p2.g14fb085.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/csi-operator
LABEL io.openshift.build.commit.id=14fb0852e9a2c68aca971e9c106d38c3c2301c66
LABEL com.redhat.art.name=ose-smb-csi-driver-operator-fbc
LABEL com.redhat.art.nvr=ose-smb-csi-driver-operator-fbc-4.16.0-20261026183755
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-smb-csi-driver-operator-bundle@sha256:a9c1395d368a2360dad28bb37d054443719c7ab069473e702515383de52401fc
