# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift5/ose-operator-registry-rhel9:v5.1 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift5/ose-operator-registry-rhel9:v5.1
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
ENV __doozer_group=logging-6.7
ENV __doozer_key=cluster-logging-operator
ENV __doozer_version=6.7.0
ENV __doozer_release=20261013154708.ocp5.1
ENV __doozer_bundle_nvrs=ose-cluster-logging-operator-metadata-container-6.7.0.202610131424.p2.gee6a5af.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/cluster-logging-operator
LABEL io.openshift.build.commit.id=ee6a5af15ccb11cb8886e363ac32593ad7b65470
LABEL com.redhat.art.name=cluster-logging-operator-fbc
LABEL com.redhat.art.nvr=cluster-logging-operator-fbc-6.7.0-20261013154708.ocp5.1
LABEL com.redhat.art.bundle.pullspec=quay.io/redhat-user-workloads/ocp-art-tenant/art-images@sha256:c77f60fc60a3c66639c33a1117cd5e93a6de5e6ca763495ffcf4feda003ff9f3
