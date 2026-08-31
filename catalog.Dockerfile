# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.18 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.18
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
ENV __doozer_group=logging-6.2
ENV __doozer_key=loki-operator
ENV __doozer_version=6.2.13
ENV __doozer_release=20260831064930.ocp4.18
ENV __doozer_bundle_nvrs=loki-rhel9-operator-metadata-container-6.2.13.202608310433.p2.gcd5eefc.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/loki
LABEL io.openshift.build.commit.id=cd5eefc1d5853920fdaddde76e462020a1fe637f
LABEL com.redhat.art.name=loki-operator-fbc
LABEL com.redhat.art.nvr=loki-operator-fbc-6.2.13-20260831064930.ocp4.18
