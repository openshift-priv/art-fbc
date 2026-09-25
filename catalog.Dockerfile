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
ENV __doozer_group=quay-3.18
ENV __doozer_key=container-security-operator
ENV __doozer_version=3.18.2
ENV __doozer_release=20260925145421.ocp4.15
ENV __doozer_bundle_nvrs=container-security-operator-metadata-container-3.18.2.202609251300.p2.g6c0e6c4.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/quay/container-security-operator
LABEL io.openshift.build.commit.id=6c0e6c4db407ca98c60479f0eb815f293a8a3547
LABEL com.redhat.art.name=container-security-operator-fbc
LABEL com.redhat.art.nvr=container-security-operator-fbc-3.18.2-20260925145421.ocp4.15
