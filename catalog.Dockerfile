# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.21 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.21
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
ENV __doozer_group=quay-3.15
ENV __doozer_key=container-security-operator
ENV __doozer_version=3.15.9
ENV __doozer_release=20261023175602.ocp4.21
ENV __doozer_bundle_nvrs=container-security-operator-metadata-container-3.15.9.202610231528.p2.g46617d2.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/quay/container-security-operator
LABEL io.openshift.build.commit.id=46617d2dc2494ea06ede819c9631f148a8c524f4
LABEL com.redhat.art.name=container-security-operator-fbc
LABEL com.redhat.art.nvr=container-security-operator-fbc-3.15.9-20261023175602.ocp4.21
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/quay/quay-container-security-operator-bundle@sha256:995ffee304da55bdcf13a76c5c68a446b852a6e094baf6a76f614e4db9a3a4e5
