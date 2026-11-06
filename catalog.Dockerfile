# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.22 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.22
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
ENV __doozer_group=openshift-4.22
ENV __doozer_key=ptp-operator
ENV __doozer_version=4.22.0
ENV __doozer_release=20261106211756
ENV __doozer_bundle_nvrs=ose-ptp-operator-metadata-container-v4.22.0.202611061901.p2.g6792a2e.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/ptp-operator
LABEL io.openshift.build.commit.id=6792a2ecec729be5edbf1832540f4d08906418f0
LABEL com.redhat.art.name=ptp-operator-fbc
LABEL com.redhat.art.nvr=ptp-operator-fbc-4.22.0-20261106211756
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-ptp-operator-bundle@sha256:8c2280c369be62c97a666a2381b232e3e0d1da2f95b4d3c599106a66dfb38254
