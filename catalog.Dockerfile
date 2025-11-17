# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.16 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.16
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
ENV __doozer_group=mtc-1.8
ENV __doozer_key=openshift-migration-operator
ENV __doozer_version=1.8.11
ENV __doozer_release=20251117235222
ENV __doozer_bundle_nvrs=openshift-migration-operator-metadata-container-1.8.11.202511141453.p2.g66fad72.assembly.stream.el8-2
LABEL io.openshift.build.source-location=https://github.com/migtools/mig-operator
LABEL io.openshift.build.commit.id=66fad725dcc5f3b9218b6320667ffa12b2247aa8
LABEL com.redhat.art.name=openshift-migration-operator-fbc
LABEL com.redhat.art.nvr=openshift-migration-operator-fbc-1.8.11-20251117235222
