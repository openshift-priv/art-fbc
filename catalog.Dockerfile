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
ENV __doozer_release=20261127121258
ENV __doozer_bundle_nvrs=sriov-network-operator-metadata-container-v5.1.0.202611202059.p2.g778d507.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/sriov-network-operator
LABEL io.openshift.build.commit.id=778d507a34aa385d509939e8108d611d5592bfaa
LABEL com.redhat.art.name=sriov-network-operator-fbc
LABEL com.redhat.art.nvr=sriov-network-operator-fbc-5.1.0-20261127121258
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift5/ose-sriov-network-operator-bundle@sha256:56fb7f05ffe4a18d58b8d350039fa058786f65851fbb8089b4871255645d8079
