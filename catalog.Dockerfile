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
ENV __doozer_key=ose-secrets-store-csi-driver-operator
ENV __doozer_version=4.22.0
ENV __doozer_release=20261015093813
ENV __doozer_bundle_nvrs=ose-secrets-store-csi-driver-operator-bundle-container-v4.22.0.202610130501.p2.g0a4052c.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/secrets-store-csi-driver-operator
LABEL io.openshift.build.commit.id=0a4052c612f3716d3f5a1f12f4a0ab09c5185a30
LABEL com.redhat.art.name=ose-secrets-store-csi-driver-operator-fbc
LABEL com.redhat.art.nvr=ose-secrets-store-csi-driver-operator-fbc-4.22.0-20261015093813
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-secrets-store-csi-driver-operator-bundle@sha256:ecccb4c6da72f27ac7003e25191e97ec64e819a3850923c8b01bf6a1b33e05eb
