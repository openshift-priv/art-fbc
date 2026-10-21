# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.20 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.20
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
ENV __doozer_release=20261021060741.ocp4.20
ENV __doozer_bundle_nvrs=opentelemetry-operator-bundle-container-0.158.0.202610210501.p2.g80eddb6.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/open-telemetry-opentelemetry-operator
LABEL io.openshift.build.commit.id=80eddb661589e7e7ed1d4c8c0887efe75c2e3830
LABEL com.redhat.art.name=opentelemetry-operator-fbc
LABEL com.redhat.art.nvr=opentelemetry-operator-fbc-0.158.0-20261021060741.ocp4.20
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/rhosdt/opentelemetry-operator-bundle@sha256:80d70726f13c0c0bc8646788317d740c056d066953a178fcf51820d36b0732ad
