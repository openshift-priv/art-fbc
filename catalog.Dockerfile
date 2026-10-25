# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.18 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.18
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
ENV __doozer_group=kueue-1.4
ENV __doozer_key=kueue-operator
ENV __doozer_version=1.4.0
ENV __doozer_release=20261025121337.ocp4.18
ENV __doozer_bundle_nvrs=kueue-operator-bundle-1.4.4.202610251108.p2.gc5e3bcf.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/kueue-operator
LABEL io.openshift.build.commit.id=c5e3bcfc4d3a8225f9e340a044f8a7f6981bb198
LABEL com.redhat.art.name=kueue-operator-fbc
LABEL com.redhat.art.nvr=kueue-operator-fbc-1.4.0-20261025121337.ocp4.18
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/kueue/kueue-operator-bundle@sha256:bf85b2d3e56c25687f276f478392b0eb60dc4f053dcde48a776dabb4fc0c1b0a
