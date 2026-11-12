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
ENV __doozer_key=ose-gcp-filestore-csi-driver-operator
ENV __doozer_version=4.16.0
ENV __doozer_release=20261112065053
ENV __doozer_bundle_nvrs=ose-gcp-filestore-csi-driver-operator-bundle-container-v4.16.0.202611111847.p2.g72317ad.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/gcp-filestore-csi-driver-operator
LABEL io.openshift.build.commit.id=72317ad8389b249b771d0dcb00e48eca133e90e4
LABEL com.redhat.art.name=ose-gcp-filestore-csi-driver-operator-fbc
LABEL com.redhat.art.nvr=ose-gcp-filestore-csi-driver-operator-fbc-4.16.0-20261112065053
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-gcp-filestore-csi-driver-operator-bundle@sha256:a8a34d9e4b35ebead787dbcdccbb5be79ce50ad089de0dbbc0676ef1e44304fe
