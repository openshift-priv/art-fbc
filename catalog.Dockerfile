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
ENV __doozer_group=osus-5.0
ENV __doozer_key=openshift-update-service-rhel8-operator
ENV __doozer_version=5.0.5
ENV __doozer_release=20261029042311.ocp4.15
ENV __doozer_bundle_nvrs=openshift-update-service-rhel8-operator-metadata-container-5.0.5.202610290354.p2.g1b4a9cc.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/cincinnati-operator
LABEL io.openshift.build.commit.id=1b4a9cc08ed6a71d47b7aa00fbb55a365d824478
LABEL com.redhat.art.name=openshift-update-service-rhel8-operator-fbc
LABEL com.redhat.art.nvr=openshift-update-service-rhel8-operator-fbc-5.0.5-20261029042311.ocp4.15
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift-update-service/cincinnati-operator-bundle@sha256:3fc42d9186f8a76de420f28db5302b6e6737397200dda21fe4050c1a670f6c63
