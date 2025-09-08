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
ENV __doozer_key=ose-secrets-store-csi-driver-operator
ENV __doozer_version=4.19.0
ENV __doozer_release=20250908072733
ENV __doozer_bundle_nvrs=ose-secrets-store-csi-driver-operator-bundle-container-v4.19.0.202509072341.p2.gd830230.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/secrets-store-csi-driver-operator
LABEL io.openshift.build.commit.id=d830230699dd19bdf9a85b0d68a60d94cc2d78ff
LABEL com.redhat.art.name=ose-secrets-store-csi-driver-operator-fbc
LABEL com.redhat.art.nvr=ose-secrets-store-csi-driver-operator-fbc-4.19.0-20250908072733
