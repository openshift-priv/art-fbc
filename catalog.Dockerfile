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
ENV __doozer_group=quay-3.9
ENV __doozer_key=quay-operator
ENV __doozer_version=3.9.28
ENV __doozer_release=20261027234626.ocp4.12
ENV __doozer_bundle_nvrs=quay-operator-metadata-container-3.9.28.202610272224.p2.g26af49b.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/quay/quay-operator
LABEL io.openshift.build.commit.id=26af49b73845dae8e14ed2a23b4541994910f2c8
LABEL com.redhat.art.name=quay-operator-fbc
LABEL com.redhat.art.nvr=quay-operator-fbc-3.9.28-20261027234626.ocp4.12
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/quay/quay-operator-bundle@sha256:2fa6f628c2eae1fb30df4c5a71b9e76967b1ac2e2e7fd0d6d8308ba89c54d934
