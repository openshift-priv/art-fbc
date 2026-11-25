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
ENV __doozer_key=sriov-network-operator
ENV __doozer_version=5.1.0
ENV __doozer_release=20261125175232
ENV __doozer_bundle_nvrs=sriov-network-operator-metadata-container-v5.1.0.202611251154.p2.g7892a9b.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/sriov-network-operator
LABEL io.openshift.build.commit.id=7892a9b2fda9a995e802c7eb266c2769a487e67d
LABEL com.redhat.art.name=sriov-network-operator-fbc
LABEL com.redhat.art.nvr=sriov-network-operator-fbc-5.1.0-20261125175232
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift5/ose-sriov-network-operator-bundle@sha256:85dd8446329f068097fe4c2902c02d461dcdec40fa2e7926f7add2b19b6b8b10
