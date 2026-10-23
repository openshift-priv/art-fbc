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
ENV __doozer_group=coo-1.5
ENV __doozer_key=cluster-observability-operator
ENV __doozer_version=1.5.4
ENV __doozer_release=20261023085506.ocp5.0
ENV __doozer_bundle_nvrs=cluster-observability-operator-bundle-container-1.5.4.202610230814.p2.g67d6cc3.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/rhobs/observability-operator
LABEL io.openshift.build.commit.id=67d6cc30bd05e24ea8dd145a33a3963921fd2be9
LABEL com.redhat.art.name=cluster-observability-operator-fbc
LABEL com.redhat.art.nvr=cluster-observability-operator-fbc-1.5.4-20261023085506.ocp5.0
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/cluster-observability-operator/cluster-observability-operator-bundle@sha256:361fc1c61b5912fe8e37bb70008d111106f021e3cee502e6ec72f2273781e570
