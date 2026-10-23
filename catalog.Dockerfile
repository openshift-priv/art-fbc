# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.19 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.19
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
ENV __doozer_version=1.5.4
ENV __doozer_release=20261023004242.ocp4.19
ENV __doozer_bundle_nvrs=cluster-observability-operator-bundle-container-1.5.4.202610222354.p2.gc0e5706.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/rhobs/observability-operator
LABEL io.openshift.build.commit.id=c0e5706acef2afca939d91676fc6af340a08dcfb
LABEL com.redhat.art.name=cluster-observability-operator-fbc
LABEL com.redhat.art.nvr=cluster-observability-operator-fbc-1.5.4-20261023004242.ocp4.19
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/cluster-observability-operator/cluster-observability-operator-bundle@sha256:2d8e7779020df6c78c0a068f11814468adf1c386150524e1de7c417311b20900
