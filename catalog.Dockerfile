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
ENV __doozer_group=quay-3.17
ENV __doozer_key=quay-operator
ENV __doozer_version=3.17.7
ENV __doozer_release=20261112215127.ocp4.15
ENV __doozer_bundle_nvrs=quay-operator-metadata-container-3.17.7.202611121840.p2.g9af02da.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/quay/quay-operator
LABEL io.openshift.build.commit.id=9af02dac8a46156218be51823a4ea34fb5056425
LABEL com.redhat.art.name=quay-operator-fbc
LABEL com.redhat.art.nvr=quay-operator-fbc-3.17.7-20261112215127.ocp4.15
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/quay/quay-operator-bundle@sha256:d1f6fcbb72b6bd21c1137fa55de1e09cd56d7083d4a35ecc0eff96117d513ea4
