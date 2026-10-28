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
ENV __doozer_key=sriov-network-operator
ENV __doozer_version=5.0.0
ENV __doozer_release=20261028152623
ENV __doozer_bundle_nvrs=sriov-network-operator-metadata-container-v5.0.0.202610271435.p2.g4d6a7b2.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/sriov-network-operator
LABEL io.openshift.build.commit.id=4d6a7b26cbe2e489800e7c48769d063f524035b7
LABEL com.redhat.art.name=sriov-network-operator-fbc
LABEL com.redhat.art.nvr=sriov-network-operator-fbc-5.0.0-20261028152623
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift5/ose-sriov-network-operator-bundle@sha256:3583b0f5ee4ffb0f4d121950aeb917513fa29d3707c26947512cf963d443b9af
