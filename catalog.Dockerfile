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
ENV __doozer_group=coo-1.5
ENV __doozer_key=cluster-observability-operator
ENV __doozer_version=1.5.2
ENV __doozer_release=20261018202750.ocp4.12
ENV __doozer_bundle_nvrs=cluster-observability-operator-bundle-container-1.5.2.202610182005.p2.g8d0176b.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/rhobs/observability-operator
LABEL io.openshift.build.commit.id=8d0176b2e3f0bf93a3faed4344f0c61c22aa502f
LABEL com.redhat.art.name=cluster-observability-operator-fbc
LABEL com.redhat.art.nvr=cluster-observability-operator-fbc-1.5.2-20261018202750.ocp4.12
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/cluster-observability-operator/cluster-observability-operator-bundle@sha256:fe8d2de1b44a2890bd122a8ae7c743a6c158b6c0215294dd7ca2872af601047c
