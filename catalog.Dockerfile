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
ENV __doozer_group=osus-5.0
ENV __doozer_key=openshift-update-service-rhel8-operator
ENV __doozer_version=5.0.0
ENV __doozer_release=20261024012006.ocp4.12
ENV __doozer_bundle_nvrs=openshift-update-service-rhel8-operator-metadata-container-5.0.5.202610221449.p2.g1b4a9cc.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/cincinnati-operator
LABEL io.openshift.build.commit.id=1b4a9cc08ed6a71d47b7aa00fbb55a365d824478
LABEL com.redhat.art.name=openshift-update-service-rhel8-operator-fbc
LABEL com.redhat.art.nvr=openshift-update-service-rhel8-operator-fbc-5.0.0-20261024012006.ocp4.12
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift-update-service/cincinnati-operator-bundle@sha256:4baef8713f5c626c87a4e8393bb40c9b34f1de85399be2ccafb1cf2e90142702
