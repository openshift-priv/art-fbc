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
LABEL com.redhat.art.name=quay-operator-fbc-unified
LABEL com.redhat.art.nvr=quay-operator-fbc-unified-4.22-20261023162121230686.ocp4.22
ENV __doozer_group=quay-3.16
ENV __doozer_version=4.22
ENV __doozer_release=20261023162121230686.ocp4.22
ENV __doozer_bundle_nvrs=quay-operator-metadata-container-3.16.7.202610202232.p2.ge44ea81.assembly.stream.el9-2,quay-operator-metadata-container-3.17.7.202610202329.p2.g015d069.assembly.stream.el9-2,quay-operator-metadata-container-3.18.3.202610202230.p2.g198abc8.assembly.stream.el9-1
