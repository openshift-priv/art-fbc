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
ENV __doozer_key=ptp-operator
ENV __doozer_version=5.1.0
ENV __doozer_release=20261112052145
ENV __doozer_bundle_nvrs=ose-ptp-operator-metadata-container-v5.1.0.202611111959.p2.g13ff651.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/ptp-operator
LABEL io.openshift.build.commit.id=13ff651df58202b45ecad0cc73a2da0eb752c958
LABEL com.redhat.art.name=ptp-operator-fbc
LABEL com.redhat.art.nvr=ptp-operator-fbc-5.1.0-20261112052145
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift5/ose-ptp-operator-bundle@sha256:f37e475abb9d440f618174be2a3e45b8e0af67a24efbc82a2d7236d38f435d3d
