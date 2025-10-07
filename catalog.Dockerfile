# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.15 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.15
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
ENV __doozer_group=openshift-4.15
ENV __doozer_key=cluster-nfd-operator
ENV __doozer_version=4.15.0
ENV __doozer_release=20251007192831
ENV __doozer_bundle_nvrs=cluster-nfd-operator-metadata-container-v4.15.0.202510071319.p2.g1e57eb5.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/cluster-nfd-operator
LABEL io.openshift.build.commit.id=1e57eb5fb53eb075abaeaa10b148c04124bbb1ab
LABEL com.redhat.art.name=cluster-nfd-operator-fbc
LABEL com.redhat.art.nvr=cluster-nfd-operator-fbc-4.15.0-20251007192831
