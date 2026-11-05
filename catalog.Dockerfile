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
ENV __doozer_group=openshift-4.12
ENV __doozer_key=ptp-operator
ENV __doozer_version=4.12.0
ENV __doozer_release=20261105005126
ENV __doozer_bundle_nvrs=ose-ptp-operator-metadata-container-v4.12.0.202611041933.p2.g3c9f39e.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/openshift/ptp-operator
LABEL io.openshift.build.commit.id=3c9f39e8a6c361665837ab34da047108dd4a4096
LABEL com.redhat.art.name=ptp-operator-fbc
LABEL com.redhat.art.nvr=ptp-operator-fbc-4.12.0-20261105005126
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-ptp-operator-bundle@sha256:f9a93e23f6c3c1a2faa31a5473664f3423a0cce9c1ee92f99f6119b223737a2a
