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
ENV __doozer_release=20261128094717
ENV __doozer_bundle_nvrs=ose-secrets-store-csi-driver-operator-bundle-container-v4.19.0.202611280855.p2.gab2435b.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/secrets-store-csi-driver-operator
LABEL io.openshift.build.commit.id=ab2435b75d3569f7a25779ec397a689f9f4cc532
LABEL com.redhat.art.name=ose-secrets-store-csi-driver-operator-fbc
LABEL com.redhat.art.nvr=ose-secrets-store-csi-driver-operator-fbc-4.19.0-20261128094717
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-secrets-store-csi-driver-operator-bundle@sha256:a07ac01fe775891e3fa77573d472234e0784acdf1bd9c407eaf56fc8e96ad94d
