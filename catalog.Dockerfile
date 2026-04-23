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
ENV __doozer_group=openshift-4.14
ENV __doozer_key=cluster-nfd-operator
ENV __doozer_version=4.14.0
ENV __doozer_release=20260423073725
ENV __doozer_bundle_nvrs=cluster-nfd-operator-metadata-container-v4.14.0.202604230255.p2.ga62d778.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/openshift/cluster-nfd-operator
LABEL io.openshift.build.commit.id=a62d778acf51c76b9cbcffd14448bc8f4ec0ab84
LABEL com.redhat.art.name=cluster-nfd-operator-fbc
LABEL com.redhat.art.nvr=cluster-nfd-operator-fbc-4.14.0-20260423073725
