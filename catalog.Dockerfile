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
ENV __doozer_release=20261123223758
ENV __doozer_bundle_nvrs=ose-secrets-store-csi-driver-operator-bundle-container-v4.15.0.202611231117.p2.gef602a5.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/openshift/secrets-store-csi-driver-operator
LABEL io.openshift.build.commit.id=ef602a541e8cd5e398c195a1056b5ff699a12e4b
LABEL com.redhat.art.name=ose-secrets-store-csi-driver-operator-fbc
LABEL com.redhat.art.nvr=ose-secrets-store-csi-driver-operator-fbc-4.15.0-20261123223758
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-secrets-store-csi-driver-operator-bundle@sha256:48487eea33469629fa8c7711ab32b8ad7c9374a0bcc6c943ba375cc60b49c744
