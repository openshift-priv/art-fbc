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
ENV __doozer_group=rhosdt-0.158
ENV __doozer_key=opentelemetry-operator
ENV __doozer_version=0.158.0
ENV __doozer_release=20261031081809.ocp4.19
ENV __doozer_bundle_nvrs=opentelemetry-operator-bundle-container-0.158.0.202610310606.p2.g8efde6c.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/open-telemetry-opentelemetry-operator
LABEL io.openshift.build.commit.id=8efde6ce3362462475374f85b1769b7edbfd1de7
LABEL com.redhat.art.name=opentelemetry-operator-fbc
LABEL com.redhat.art.nvr=opentelemetry-operator-fbc-0.158.0-20261031081809.ocp4.19
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/rhosdt/opentelemetry-operator-bundle@sha256:991231793ee3c902d9d0e1f8c3b8f92d283956ddefff3c51db8d35d5db180b1b
