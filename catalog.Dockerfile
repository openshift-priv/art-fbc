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
ENV __doozer_release=20260904151731
ENV __doozer_bundle_nvrs=sriov-network-operator-metadata-container-v5.1.0.202609041259.p2.gad3161c.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/sriov-network-operator
LABEL io.openshift.build.commit.id=ad3161cba27619ef1161c13c8112e3aa020a900a
LABEL com.redhat.art.name=sriov-network-operator-fbc
LABEL com.redhat.art.nvr=sriov-network-operator-fbc-5.1.0-20260904151731
