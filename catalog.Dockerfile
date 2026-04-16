# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry:v4.14 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry:v4.14
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
ENV __doozer_group=openshift-4.14
ENV __doozer_key=vertical-pod-autoscaler-operator
ENV __doozer_version=4.14.0
ENV __doozer_release=20260416034357
ENV __doozer_bundle_nvrs=ose-vertical-pod-autoscaler-operator-metadata-container-v4.14.0.202604160116.p2.gb70ce20.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/openshift/vertical-pod-autoscaler-operator
LABEL io.openshift.build.commit.id=b70ce203a66852ae0aeff2b8eff64583760c86e6
LABEL com.redhat.art.name=vertical-pod-autoscaler-operator-fbc
LABEL com.redhat.art.nvr=vertical-pod-autoscaler-operator-fbc-4.14.0-20260416034357
