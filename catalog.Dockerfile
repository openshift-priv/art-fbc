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
ENV __doozer_group=rhosdt-3.11
ENV __doozer_key=opentelemetry-rhel9-operator
ENV __doozer_version=0.158.1
ENV __doozer_release=20260925155753.ocp4.17
ENV __doozer_bundle_nvrs=opentelemetry-operator-bundle-container-0.158.1.202609251512.p2.gacc39e6.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/open-telemetry-opentelemetry-operator
LABEL io.openshift.build.commit.id=acc39e6d057967b204f262412a8061962a32c4e2
LABEL com.redhat.art.name=opentelemetry-rhel9-operator-fbc
LABEL com.redhat.art.nvr=opentelemetry-rhel9-operator-fbc-0.158.1-20260925155753.ocp4.17
