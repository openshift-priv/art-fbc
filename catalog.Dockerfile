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
ENV __doozer_group=zero-trust-1.1
ENV __doozer_key=zero-trust-workload-identity-manager
ENV __doozer_version=1.1.0
ENV __doozer_release=20260810094620.ocp4.20
ENV __doozer_bundle_nvrs=zero-trust-workload-identity-manager-metadata-container-1.1.0.202608100858.p2.g0e03ca0.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/zero-trust-workload-identity-manager
LABEL io.openshift.build.commit.id=0e03ca0f4516b0da84cc0cf9a8bc3d3bf2602d73
LABEL com.redhat.art.name=zero-trust-workload-identity-manager-fbc
LABEL com.redhat.art.nvr=zero-trust-workload-identity-manager-fbc-1.1.0-20260810094620.ocp4.20
