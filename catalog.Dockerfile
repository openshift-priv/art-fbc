# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry:v4.13 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry:v4.13
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
ENV __doozer_group=openshift-4.13
ENV __doozer_key=vertical-pod-autoscaler-operator
ENV __doozer_version=4.13.0
ENV __doozer_release=20261128165338
ENV __doozer_bundle_nvrs=ose-vertical-pod-autoscaler-operator-metadata-container-v4.13.0.202611281146.p2.g3ac7d2a.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/openshift/vertical-pod-autoscaler-operator
LABEL io.openshift.build.commit.id=3ac7d2a020eee8ce9933b6f8ecf8fa66b2b3c91b
LABEL com.redhat.art.name=vertical-pod-autoscaler-operator-fbc
LABEL com.redhat.art.nvr=vertical-pod-autoscaler-operator-fbc-4.13.0-20261128165338
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-vertical-pod-autoscaler-operator-bundle@sha256:9f91fbf972cde71dc6d6e3f6c215d00af0a0a9e6aa32ffa4807f8e9564238547
