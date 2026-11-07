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
LABEL com.redhat.art.name=quay-fbc-unified
LABEL com.redhat.art.nvr=quay-fbc-unified-5.0-20261107031632265438.ocp5.0
ENV __doozer_group=quay-3.18
ENV __doozer_version=5.0
ENV __doozer_release=20261107031632265438.ocp5.0
ENV __doozer_bundle_nvrs=container-security-operator-metadata-container-3.18.3.202611041531.p2.gf5135f1.assembly.stream.el9-1,quay-bridge-operator-metadata-container-3.18.3.202610271230.p2.gfe48dd9.assembly.stream.el9-1,quay-operator-metadata-container-3.18.3.202611041531.p2.gf2b3442.assembly.stream.el9-3
