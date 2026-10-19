# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift5/ose-operator-registry-rhel9:v5.0 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift5/ose-operator-registry-rhel9:v5.0
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
ENV __doozer_group=openshift-5.0
ENV __doozer_key=ose-secrets-store-csi-driver-operator
ENV __doozer_version=5.0.0
ENV __doozer_release=20261019153836
ENV __doozer_bundle_nvrs=ose-secrets-store-csi-driver-operator-bundle-container-v5.0.0.202610191236.p2.gdd6f4f7.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/secrets-store-csi-driver-operator
LABEL io.openshift.build.commit.id=dd6f4f7236ffff35dc33d984c9e6e6f27f126064
LABEL com.redhat.art.name=ose-secrets-store-csi-driver-operator-fbc
LABEL com.redhat.art.nvr=ose-secrets-store-csi-driver-operator-fbc-5.0.0-20261019153836
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift5/ose-secrets-store-csi-driver-operator-bundle@sha256:298525ba02d8f15052ec8ead2cada46a721542548741385df6f5e1743d3ea1aa
