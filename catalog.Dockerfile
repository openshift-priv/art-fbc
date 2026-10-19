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
ENV __doozer_key=local-storage-operator
ENV __doozer_version=4.14.0
ENV __doozer_release=20261019091709
ENV __doozer_bundle_nvrs=local-storage-operator-metadata-container-v4.14.0.202610190338.p2.g4624a1e.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/local-storage-operator
LABEL io.openshift.build.commit.id=4624a1e795f129fc50bfcddbf5cbe0bcecf1de1f
LABEL com.redhat.art.name=local-storage-operator-fbc
LABEL com.redhat.art.nvr=local-storage-operator-fbc-4.14.0-20261019091709
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-local-storage-operator-bundle@sha256:7f78f7fcc4c467f668affe96b0f4994b035b8790d60f4c32264f8517a2504f43
