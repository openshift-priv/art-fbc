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
ENV __doozer_key=vertical-pod-autoscaler-operator
ENV __doozer_version=4.12.0
ENV __doozer_release=20261027134323
ENV __doozer_bundle_nvrs=ose-vertical-pod-autoscaler-operator-metadata-container-v4.12.0.202610271002.p2.gee4fb01.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/openshift/vertical-pod-autoscaler-operator
LABEL io.openshift.build.commit.id=ee4fb0132fda3b1936346c761073279d6bed6fc4
LABEL com.redhat.art.name=vertical-pod-autoscaler-operator-fbc
LABEL com.redhat.art.nvr=vertical-pod-autoscaler-operator-fbc-4.12.0-20261027134323
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-vertical-pod-autoscaler-operator-bundle@sha256:f4b117e150afd47fe97e4599d9c329e67f7d5606916a556ab9c11325915c3d96
