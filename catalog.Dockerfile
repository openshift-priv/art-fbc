# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.19 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.19
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
ENV __doozer_group=mce-2.8
ENV __doozer_key=backplane-operator
ENV __doozer_version=2.8.13
ENV __doozer_release=20261106200348.ocp4.19
ENV __doozer_bundle_nvrs=mce-backplane-operator-metadata-container-2.8.13.202611061817.p2.g06044a0.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/stolostron/backplane-operator
LABEL io.openshift.build.commit.id=06044a0e33071cbdab83aee9125d4712cf5f80de
LABEL com.redhat.art.name=backplane-operator-fbc
LABEL com.redhat.art.nvr=backplane-operator-fbc-2.8.13-20261106200348.ocp4.19
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/multicluster-engine/mce-operator-bundle@sha256:7ed9c7d406d62b78e3e344117a40b5e8b4f3f479de544b9ef98600f9c298cafc
