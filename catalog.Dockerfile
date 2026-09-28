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
ENV __doozer_group=rhosdt-3.11
ENV __doozer_key=opentelemetry-operator
ENV __doozer_version=0.158.1
ENV __doozer_release=20260928175316.ocp5.0
ENV __doozer_bundle_nvrs=opentelemetry-operator-bundle-container-0.158.1.202609281704.p2.gfd6dcd9.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/open-telemetry-opentelemetry-operator
LABEL io.openshift.build.commit.id=fd6dcd9bc8ebfedc9f709b45c8e9dee7f105c4fa
LABEL com.redhat.art.name=opentelemetry-operator-fbc
LABEL com.redhat.art.nvr=opentelemetry-operator-fbc-0.158.1-20260928175316.ocp5.0
