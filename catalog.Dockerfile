# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.22 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.22
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
ENV __doozer_group=openshift-4.22
ENV __doozer_key=ose-support-log-gather-operator
ENV __doozer_version=4.22.0
ENV __doozer_release=20261125112730
ENV __doozer_bundle_nvrs=ose-support-log-gather-operator-bundle-container-v4.22.0.202611250138.p2.g8c51b0d.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/must-gather-operator
LABEL io.openshift.build.commit.id=8c51b0d9d46609d12b4fad33a4713100151bfc76
LABEL com.redhat.art.name=ose-support-log-gather-operator-fbc
LABEL com.redhat.art.nvr=ose-support-log-gather-operator-fbc-4.22.0-20261125112730
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-support-log-gather-operator-bundle@sha256:dd22f76ee8730f9a524499f51a9e5e4be863957e62a06c635e9e3c71d93983b7
