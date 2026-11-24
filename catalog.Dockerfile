# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.15 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.15
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
ENV __doozer_group=openshift-4.15
ENV __doozer_key=ose-secrets-store-csi-driver-operator
ENV __doozer_version=4.15.0
ENV __doozer_release=20261124215743
ENV __doozer_bundle_nvrs=ose-secrets-store-csi-driver-operator-bundle-container-v4.15.0.202611240314.p2.gef602a5.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/openshift/secrets-store-csi-driver-operator
LABEL io.openshift.build.commit.id=ef602a541e8cd5e398c195a1056b5ff699a12e4b
LABEL com.redhat.art.name=ose-secrets-store-csi-driver-operator-fbc
LABEL com.redhat.art.nvr=ose-secrets-store-csi-driver-operator-fbc-4.15.0-20261124215743
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-secrets-store-csi-driver-operator-bundle@sha256:af6f697c3ab2e7927e09c18fc00245085c982e214a7eb5d9435dd75dd3b6ff70
