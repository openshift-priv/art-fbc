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
ENV __doozer_group=zero-trust-1.0
ENV __doozer_key=zero-trust-workload-identity-manager
ENV __doozer_version=1.0.3
ENV __doozer_release=20261102212938.ocp4.21
ENV __doozer_bundle_nvrs=zero-trust-workload-identity-manager-metadata-container-1.0.3.202611021824.p2.g6c08480.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/zero-trust-workload-identity-manager
LABEL io.openshift.build.commit.id=6c0848034cdefc260890c40088938a52c82a9a51
LABEL com.redhat.art.name=zero-trust-workload-identity-manager-fbc
LABEL com.redhat.art.nvr=zero-trust-workload-identity-manager-fbc-1.0.3-20261102212938.ocp4.21
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/zero-trust-workload-identity-manager/zero-trust-workload-identity-manager-operator-bundle@sha256:81f12ce4aaddd7db703e0084320bd5b0f41a885ffef58717a7cc15af87f67fbc
