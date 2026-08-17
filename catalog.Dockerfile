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
ENV __doozer_group=zero-trust-1.1
ENV __doozer_key=zero-trust-workload-identity-manager
ENV __doozer_version=1.1.0
ENV __doozer_release=20260817083124.ocp4.21
ENV __doozer_bundle_nvrs=zero-trust-workload-identity-manager-metadata-container-1.1.0.202608170744.p2.g7d9b0ee.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/zero-trust-workload-identity-manager
LABEL io.openshift.build.commit.id=7d9b0eea1371ead6c9ac96ff7cbd35a0e5df4fb9
LABEL com.redhat.art.name=zero-trust-workload-identity-manager-fbc
LABEL com.redhat.art.nvr=zero-trust-workload-identity-manager-fbc-1.1.0-20260817083124.ocp4.21
