# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.17 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.17
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
ENV __doozer_release=20261111223858.ocp4.17
ENV __doozer_bundle_nvrs=opentelemetry-operator-bundle-container-0.158.0.202611112121.p2.gc8e78b5.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/open-telemetry-opentelemetry-operator
LABEL io.openshift.build.commit.id=c8e78b53c9a5cb32f4ce7a0af85ef02c6eb5b53b
LABEL com.redhat.art.name=opentelemetry-operator-fbc
LABEL com.redhat.art.nvr=opentelemetry-operator-fbc-0.158.0-20261111223858.ocp4.17
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/rhosdt/opentelemetry-operator-bundle@sha256:81c5d49a37113388e398f7387ef0d85ffeb91563c3099a788314ec8ca72bcc78
