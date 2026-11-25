# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry:v4.13 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry:v4.13
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
ENV __doozer_group=openshift-4.13
ENV __doozer_key=ose-gcp-filestore-csi-driver-operator
ENV __doozer_version=4.13.0
ENV __doozer_release=20261125155755
ENV __doozer_bundle_nvrs=ose-gcp-filestore-csi-driver-operator-bundle-container-v4.13.0.202611251125.p2.g5a2f1b3.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/openshift/gcp-filestore-csi-driver-operator
LABEL io.openshift.build.commit.id=5a2f1b3ca80940b12de1f810d4875b7b01006c19
LABEL com.redhat.art.name=ose-gcp-filestore-csi-driver-operator-fbc
LABEL com.redhat.art.nvr=ose-gcp-filestore-csi-driver-operator-fbc-4.13.0-20261125155755
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-gcp-filestore-csi-driver-operator-bundle@sha256:7835f5031b8b7cac46daed1d0a7d999b1aa2285770e7fbd2855eb12b4cb4a963
