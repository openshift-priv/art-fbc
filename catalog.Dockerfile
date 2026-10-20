# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry:v4.13 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry:v4.13
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
ENV __doozer_release=20261020062313.ocp4.13
ENV __doozer_bundle_nvrs=quay-operator-metadata-container-3.10.28.202610200432.p2.g99297d2.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/quay/quay-operator
LABEL io.openshift.build.commit.id=99297d27e5e6697b7f9b6cf78e8d8b74e86c3f4f
LABEL com.redhat.art.name=quay-operator-fbc
LABEL com.redhat.art.nvr=quay-operator-fbc-3.10.28-20261020062313.ocp4.13
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/quay/quay-operator-bundle@sha256:66a6659534a80bfcadbe06b36f5d932c4a34205110d7ca25a619b79051a46506
