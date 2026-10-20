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
ENV __doozer_group=rhosdt-0.158
ENV __doozer_key=opentelemetry-operator
ENV __doozer_version=0.158.0
ENV __doozer_release=20261020034704.ocp4.21
ENV __doozer_bundle_nvrs=opentelemetry-operator-bundle-container-0.158.0.202610200317.p2.g1cf76ad.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/open-telemetry-opentelemetry-operator
LABEL io.openshift.build.commit.id=1cf76ad65651808fd895487c5d527f462deafc14
LABEL com.redhat.art.name=opentelemetry-operator-fbc
LABEL com.redhat.art.nvr=opentelemetry-operator-fbc-0.158.0-20261020034704.ocp4.21
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/rhosdt/opentelemetry-operator-bundle@sha256:deab4f96dde8b3dc0956d9bbc3ae6ebf3dd6d992f8d49f6771477cb11d1b662d
