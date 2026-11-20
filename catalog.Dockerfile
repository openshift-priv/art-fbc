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
ENV __doozer_group=logging-6.2
ENV __doozer_key=cluster-logging-operator
ENV __doozer_version=6.2.15
ENV __doozer_release=20261120061512.ocp4.19
ENV __doozer_bundle_nvrs=ose-cluster-logging-operator-metadata-container-6.2.15.202611182212.p2.gf531282.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/cluster-logging-operator
LABEL io.openshift.build.commit.id=f5312825c7e4874e186d8efd081b81d83a9c5933
LABEL com.redhat.art.name=cluster-logging-operator-fbc
LABEL com.redhat.art.nvr=cluster-logging-operator-fbc-6.2.15-20261120061512.ocp4.19
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift-logging/cluster-logging-operator-bundle@sha256:57e8b677a2baf4adc96dedca241ae72aba8affa6bc5310ec8e5436ace21be917
