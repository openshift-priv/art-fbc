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
ENV __doozer_group=mce-2.10
ENV __doozer_key=backplane-operator
ENV __doozer_version=2.10.8
ENV __doozer_release=20261028043052.ocp4.21
ENV __doozer_bundle_nvrs=mce-backplane-operator-metadata-container-2.10.8.202610280313.p2.gc27453a.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/stolostron/backplane-operator
LABEL io.openshift.build.commit.id=c27453ae9a54059841f14d5424c911146c7b9104
LABEL com.redhat.art.name=backplane-operator-fbc
LABEL com.redhat.art.nvr=backplane-operator-fbc-2.10.8-20261028043052.ocp4.21
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/multicluster-engine/mce-operator-bundle@sha256:03245bcb7a7a745def380d7efdd6220709e829aaa8ab5c17a77489813fd75347
