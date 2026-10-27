# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry:v4.12 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry:v4.12
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
ENV __doozer_group=quay-3.10
ENV __doozer_key=quay-operator
ENV __doozer_version=3.10.28
ENV __doozer_release=20261027201859.ocp4.12
ENV __doozer_bundle_nvrs=quay-operator-metadata-container-3.10.28.202610271938.p2.g710090f.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/quay/quay-operator
LABEL io.openshift.build.commit.id=710090f023c3d7c6ad67764e15f0bb3132d90c73
LABEL com.redhat.art.name=quay-operator-fbc
LABEL com.redhat.art.nvr=quay-operator-fbc-3.10.28-20261027201859.ocp4.12
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/quay/quay-operator-bundle@sha256:62f0eb7a05c665508b8b207078787173b03d48dabfdb7930d417b56c2c9322e0
