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
ENV __doozer_group=zero-trust-1.0
ENV __doozer_key=zero-trust-workload-identity-manager
ENV __doozer_version=1.0.3
ENV __doozer_release=20261027055756.ocp4.20
ENV __doozer_bundle_nvrs=zero-trust-workload-identity-manager-metadata-container-1.0.3.202610270511.p2.g6c08480.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/zero-trust-workload-identity-manager
LABEL io.openshift.build.commit.id=6c0848034cdefc260890c40088938a52c82a9a51
LABEL com.redhat.art.name=zero-trust-workload-identity-manager-fbc
LABEL com.redhat.art.nvr=zero-trust-workload-identity-manager-fbc-1.0.3-20261027055756.ocp4.20
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/zero-trust-workload-identity-manager/zero-trust-workload-identity-manager-operator-bundle@sha256:63c3ed4cd1ee135bf708992fdbbe0ae791f886467677c285645758fe3d70586b
