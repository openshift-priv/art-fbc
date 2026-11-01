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
ENV __doozer_group=mce-2.17
ENV __doozer_key=backplane-operator
ENV __doozer_version=2.17.4
ENV __doozer_release=20261101220158.ocp4.21
ENV __doozer_bundle_nvrs=mce-backplane-operator-metadata-container-2.17.4.202611012111.p2.gfb3e285.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/stolostron/backplane-operator
LABEL io.openshift.build.commit.id=fb3e285ffbb40dca346a36894780e5794ac69281
LABEL com.redhat.art.name=backplane-operator-fbc
LABEL com.redhat.art.nvr=backplane-operator-fbc-2.17.4-20261101220158.ocp4.21
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/multicluster-engine/mce-operator-bundle@sha256:e4fecd42f72e424c37e3ac2559e91f6be80157aa63fefd836ffa6ea42c5d20a0
