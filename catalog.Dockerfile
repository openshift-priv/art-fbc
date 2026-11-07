# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry:v4.14 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry:v4.14
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
LABEL com.redhat.art.nvr=quay-fbc-unified-4.14-20261107013612087371.ocp4.14
ENV __doozer_group=quay-3.10
ENV __doozer_version=4.14
ENV __doozer_release=20261107013612087371.ocp4.14
ENV __doozer_bundle_nvrs=container-security-operator-metadata-container-3.10.28.202610271439.p2.ge91b0be.assembly.stream.el8-1,container-security-operator-metadata-container-3.12.24.202610271433.p2.gbe47da0.assembly.stream.el8-1,container-security-operator-metadata-container-3.14.10.202610261030.p2.gbdb8a8b.assembly.stream.el8-1,container-security-operator-metadata-container-3.15.9.202610271439.p2.gc6749aa.assembly.stream.el8-1,container-security-operator-metadata-container-3.16.7.202611041541.p2.g0d739b6.assembly.stream.el9-1,container-security-operator-metadata-container-3.17.7.202611041535.p2.g781f396.assembly.stream.el9-1,container-security-operator-metadata-container-3.18.3.202611041531.p2.gf5135f1.assembly.stream.el9-1,container-security-operator-metadata-container-3.9.28.202610271431.p2.gc380bf0.assembly.stream.el8-1,quay-bridge-operator-metadata-container-3.10.28.202610271439.p2.g6c16d61.assembly.stream.el8-1,quay-bridge-operator-metadata-container-3.12.24.202610271433.p2.gbbcd478.assembly.stream.el8-1,quay-bridge-operator-metadata-container-3.14.10.202610271443.p2.gf2b4563.assembly.stream.el8-1,quay-bridge-operator-metadata-container-3.15.9.202610271925.p2.g5a800a1.assembly.stream.el8-1,quay-bridge-operator-metadata-container-3.16.7.202610260619.p2.gfb76353.assembly.stream.el9-1,quay-bridge-operator-metadata-container-3.17.7.202610271744.p2.g7e838b2.assembly.stream.el9-1,quay-bridge-operator-metadata-container-3.18.3.202610271230.p2.gfe48dd9.assembly.stream.el9-1,quay-bridge-operator-metadata-container-3.9.28.202610271431.p2.g7495c99.assembly.stream.el8-1,quay-operator-metadata-container-3.10.28.202611041524.p2.g0da6583.assembly.stream.el8-3,quay-operator-metadata-container-3.12.24.202611041532.p2.g90e0a5d.assembly.stream.el8-3,quay-operator-metadata-container-3.14.10.202611041533.p2.gbd51185.assembly.stream.el8-3,quay-operator-metadata-container-3.15.9.202611041532.p2.gdba07eb.assembly.stream.el8-3,quay-operator-metadata-container-3.16.7.202611041541.p2.g0897e24.assembly.stream.el9-3,quay-operator-metadata-container-3.17.7.202611041535.p2.g9af02da.assembly.stream.el9-3,quay-operator-metadata-container-3.18.3.202611041531.p2.gf2b3442.assembly.stream.el9-3,quay-operator-metadata-container-3.9.28.202611041523.p2.gd33aced.assembly.stream.el8-3
