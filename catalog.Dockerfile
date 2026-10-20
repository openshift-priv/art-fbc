# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.22 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.22
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
LABEL com.redhat.art.name=quay-merged-fbc
LABEL com.redhat.art.nvr=quay-merged-fbc-4.22-20261020190634013112.ocp4.22
ENV __doozer_group=quay-3.16
ENV __doozer_version=4.22
ENV __doozer_release=20261020190634013112.ocp4.22
ENV __doozer_bundle_nvrs=container-security-operator-metadata-container-3.16.7.202610122234.p2.g0474a13.assembly.stream.el9-1,container-security-operator-metadata-container-3.17.6.202610141838.p2.g7729f96.assembly.stream.el9-1,container-security-operator-metadata-container-3.18.2.202610122226.p2.g7aaec7d.assembly.stream.el9-1
