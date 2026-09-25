# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift5/ose-operator-registry-rhel9:v5.1 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift5/ose-operator-registry-rhel9:v5.1
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
ENV __doozer_group=openshift-5.1
ENV __doozer_key=ose-secrets-store-csi-driver-operator
ENV __doozer_version=5.1.0
ENV __doozer_release=20260925083219
ENV __doozer_bundle_nvrs=ose-secrets-store-csi-driver-operator-bundle-container-v5.1.0.202609242116.p2.gba1c19f.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/secrets-store-csi-driver-operator
LABEL io.openshift.build.commit.id=ba1c19f95603feb2ffca90d67421c03747b0d76c
LABEL com.redhat.art.name=ose-secrets-store-csi-driver-operator-fbc
LABEL com.redhat.art.nvr=ose-secrets-store-csi-driver-operator-fbc-5.1.0-20260925083219
