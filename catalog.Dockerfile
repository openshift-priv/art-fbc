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
ENV __doozer_group=logging-6.6
ENV __doozer_key=cluster-logging-operator
ENV __doozer_version=6.6.2
ENV __doozer_release=20261016234807.ocp4.21
ENV __doozer_bundle_nvrs=ose-cluster-logging-operator-metadata-container-6.6.2.202610162308.p2.g8db4712.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/cluster-logging-operator
LABEL io.openshift.build.commit.id=8db471288e08bbe732582cb04b099b50d80ab77d
LABEL com.redhat.art.name=cluster-logging-operator-fbc
LABEL com.redhat.art.nvr=cluster-logging-operator-fbc-6.6.2-20261016234807.ocp4.21
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift-logging/cluster-logging-operator-bundle@sha256:69ca28f4ab3b92cb1c85ff222217b818d7ac16f66dc9abf8ffdad3a15fdce786
