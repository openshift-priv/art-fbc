# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.19 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.19
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
LABEL com.redhat.art.nvr=quay-fbc-unified-4.19-20261027011615242732.ocp4.19
ENV __doozer_group=quay-3.10
ENV __doozer_version=4.19
ENV __doozer_release=20261027011615242732.ocp4.19
ENV __doozer_bundle_nvrs=container-security-operator-metadata-container-3.10.28.202610241446.p2.ge91b0be.assembly.stream.el8-1,container-security-operator-metadata-container-3.12.24.202610241446.p2.gbe47da0.assembly.stream.el8-1,container-security-operator-metadata-container-3.14.10.202610241446.p2.gbdb8a8b.assembly.stream.el8-1,container-security-operator-metadata-container-3.15.9.202610241446.p2.gc6749aa.assembly.stream.el8-1,container-security-operator-metadata-container-3.16.7.202610241446.p2.gce626cf.assembly.stream.el9-1,container-security-operator-metadata-container-3.17.7.202610261448.p2.gf32848b.assembly.stream.el9-1,container-security-operator-metadata-container-3.18.3.202610241446.p2.g9c7385b.assembly.stream.el9-1,container-security-operator-metadata-container-3.9.28.202610241446.p2.gc380bf0.assembly.stream.el8-1,quay-bridge-operator-metadata-container-3.10.28.202610241446.p2.g6c16d61.assembly.stream.el8-1,quay-bridge-operator-metadata-container-3.12.24.202610231623.p2.gbbcd478.assembly.stream.el8-1,quay-bridge-operator-metadata-container-3.14.10.202610241446.p2.gf2b4563.assembly.stream.el8-1,quay-bridge-operator-metadata-container-3.15.9.202610241446.p2.g5a800a1.assembly.stream.el8-1,quay-bridge-operator-metadata-container-3.16.7.202610241446.p2.gfb76353.assembly.stream.el9-1,quay-bridge-operator-metadata-container-3.17.7.202610261448.p2.g7e838b2.assembly.stream.el9-1,quay-bridge-operator-metadata-container-3.18.3.202610241446.p2.gfe48dd9.assembly.stream.el9-1,quay-bridge-operator-metadata-container-3.9.28.202610241446.p2.g7495c99.assembly.stream.el8-1,quay-operator-metadata-container-3.10.28.202610241528.p2.g13481ce.assembly.stream.el8-2,quay-operator-metadata-container-3.12.24.202610241529.p2.gbde6a05.assembly.stream.el8-2,quay-operator-metadata-container-3.14.10.202610241529.p2.g13deb4c.assembly.stream.el8-2,quay-operator-metadata-container-3.15.9.202610241537.p2.g8dee639.assembly.stream.el8-2,quay-operator-metadata-container-3.16.7.202610241530.p2.gc8d7ec8.assembly.stream.el9-2,quay-operator-metadata-container-3.17.7.202610261448.p2.g015d069.assembly.stream.el9-2,quay-operator-metadata-container-3.18.3.202610241530.p2.ga410e2d.assembly.stream.el9-2,quay-operator-metadata-container-3.9.28.202610241530.p2.g346c376.assembly.stream.el8-2
