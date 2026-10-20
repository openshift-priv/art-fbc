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
ENV __doozer_release=20261020110301
ENV __doozer_bundle_nvrs=sriov-network-operator-metadata-container-v5.1.0.202610200350.p2.gabb119c.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/sriov-network-operator
LABEL io.openshift.build.commit.id=abb119c9b63c76b312eac061eddd24007ca08c1d
LABEL com.redhat.art.name=sriov-network-operator-fbc
LABEL com.redhat.art.nvr=sriov-network-operator-fbc-5.1.0-20261020110301
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift5/ose-sriov-network-operator-bundle@sha256:e66c9bc32c592e827b3508fb5514a1c30490fa7fcf4fa2300f8157c24d1f639b
