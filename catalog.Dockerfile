# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.22 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.22
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
LABEL com.redhat.art.nvr=quay-fbc-unified-4.22-20261107030841871772.ocp4.22
ENV __doozer_group=quay-3.16
ENV __doozer_version=4.22
ENV __doozer_release=20261107030841871772.ocp4.22
ENV __doozer_bundle_nvrs=container-security-operator-metadata-container-3.16.7.202611041541.p2.g0d739b6.assembly.stream.el9-1,container-security-operator-metadata-container-3.17.7.202611041535.p2.g781f396.assembly.stream.el9-1,container-security-operator-metadata-container-3.18.3.202611041531.p2.gf5135f1.assembly.stream.el9-1,quay-bridge-operator-metadata-container-3.16.7.202610260619.p2.gfb76353.assembly.stream.el9-1,quay-bridge-operator-metadata-container-3.17.7.202610271744.p2.g7e838b2.assembly.stream.el9-1,quay-bridge-operator-metadata-container-3.18.3.202610271230.p2.gfe48dd9.assembly.stream.el9-1,quay-operator-metadata-container-3.16.7.202611041541.p2.g0897e24.assembly.stream.el9-3,quay-operator-metadata-container-3.17.7.202611041535.p2.g9af02da.assembly.stream.el9-3,quay-operator-metadata-container-3.18.3.202611041531.p2.gf2b3442.assembly.stream.el9-3
