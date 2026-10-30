# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.23 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.23
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
ENV __doozer_release=20261030045526.ocp4.23
ENV __doozer_bundle_nvrs=opentelemetry-operator-bundle-container-0.158.0.202610300423.p2.gd110155.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/open-telemetry-opentelemetry-operator
LABEL io.openshift.build.commit.id=d110155182eee06addc4dfcf8fb907abd60cd380
LABEL com.redhat.art.name=opentelemetry-operator-fbc
LABEL com.redhat.art.nvr=opentelemetry-operator-fbc-0.158.0-20261030045526.ocp4.23
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/rhosdt/opentelemetry-operator-bundle@sha256:851cdb584a7d076ef025801f1a8c15ca719631225f8c6a242e6382ec55df4a03
