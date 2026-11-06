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
ENV __doozer_group=logging-6.5
ENV __doozer_key=loki-operator
ENV __doozer_version=6.5.4
ENV __doozer_release=20261106074745.ocp4.21
ENV __doozer_bundle_nvrs=loki-rhel9-operator-metadata-container-6.5.4.202611060519.p2.gd53b528.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/loki
LABEL io.openshift.build.commit.id=d53b5283b8c8277233ee853523b62dcd58874b43
LABEL com.redhat.art.name=loki-operator-fbc
LABEL com.redhat.art.nvr=loki-operator-fbc-6.5.4-20261106074745.ocp4.21
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift-logging/loki-operator-bundle@sha256:fc8e14270d2e1d89021c2a07518e8120845a22f916949a22d1313f2a9e3abda4
