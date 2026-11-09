# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift5/ose-operator-registry-rhel9:v5.0 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift5/ose-operator-registry-rhel9:v5.0
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
ENV __doozer_version=6.7.1
ENV __doozer_release=20261109114120.ocp5.0
ENV __doozer_bundle_nvrs=ose-cluster-logging-operator-metadata-container-6.7.1.202611090908.p2.gf790441.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/cluster-logging-operator
LABEL io.openshift.build.commit.id=f790441b31bde2f031e6eb908c0de0b7ac6589eb
LABEL com.redhat.art.name=cluster-logging-operator-fbc
LABEL com.redhat.art.nvr=cluster-logging-operator-fbc-6.7.1-20261109114120.ocp5.0
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift-logging/cluster-logging-operator-bundle@sha256:f48ba5bd9e8e99d5f765860c5aa14ed697b5159345d81fdbf4ebabc3122d287c
