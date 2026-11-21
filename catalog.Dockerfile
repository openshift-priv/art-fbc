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
ENV __doozer_group=openshift-4.21
ENV __doozer_key=vertical-pod-autoscaler-operator
ENV __doozer_version=4.21.0
ENV __doozer_release=20261121153412
ENV __doozer_bundle_nvrs=ose-vertical-pod-autoscaler-operator-metadata-container-v4.21.0.202611211234.p2.g6cfa95a.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/vertical-pod-autoscaler-operator
LABEL io.openshift.build.commit.id=6cfa95a56e5c0e434c28072b72267c40c28dbdaa
LABEL com.redhat.art.name=vertical-pod-autoscaler-operator-fbc
LABEL com.redhat.art.nvr=vertical-pod-autoscaler-operator-fbc-4.21.0-20261121153412
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-vertical-pod-autoscaler-operator-bundle@sha256:09deb971e74fb38121bfb22de9bd5aa2a5fd9dc266d503c93f82fba11cc30280
