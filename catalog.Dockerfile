# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.19 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.19
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
ENV __doozer_group=openshift-4.19
ENV __doozer_key=ose-gcp-filestore-csi-driver-operator
ENV __doozer_version=4.19.0
ENV __doozer_release=20261105073944
ENV __doozer_bundle_nvrs=ose-gcp-filestore-csi-driver-operator-bundle-container-v4.19.0.202611050700.p2.g542cc81.assembly.4.19.55.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/gcp-filestore-csi-driver-operator
LABEL io.openshift.build.commit.id=542cc81cc50ec4982da9567e9234f49d0804a0ae
LABEL com.redhat.art.name=ose-gcp-filestore-csi-driver-operator-fbc
LABEL com.redhat.art.nvr=ose-gcp-filestore-csi-driver-operator-fbc-4.19.0-20261105073944
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-gcp-filestore-csi-driver-operator-bundle@sha256:07a482d804c2379478c8ae4713be7de47b003fe33398295aac9112e2332f33ca
