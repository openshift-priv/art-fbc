# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.15 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.15
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
ENV __doozer_group=logging-6.0
ENV __doozer_key=loki-operator
ENV __doozer_version=6.0.18
ENV __doozer_release=20261106051945.ocp4.15
ENV __doozer_bundle_nvrs=loki-rhel9-operator-metadata-container-6.0.18.202611060303.p2.g3f07331.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/loki
LABEL io.openshift.build.commit.id=3f073315e6248c7e7bd785ec04bb82649297b2a5
LABEL com.redhat.art.name=loki-operator-fbc
LABEL com.redhat.art.nvr=loki-operator-fbc-6.0.18-20261106051945.ocp4.15
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift-logging/loki-operator-bundle@sha256:69f8d75d4aabae0c4aae417519ffba99d4ef33a69290beffbc97e72c75371bdd
