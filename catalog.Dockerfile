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
ENV __doozer_group=zero-trust-1.1
ENV __doozer_key=zero-trust-workload-identity-manager
ENV __doozer_version=1.1.2
ENV __doozer_release=20261029071207.ocp4.22
ENV __doozer_bundle_nvrs=zero-trust-workload-identity-manager-metadata-container-1.1.2.202610290616.p2.gb184e8a.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/zero-trust-workload-identity-manager
LABEL io.openshift.build.commit.id=b184e8a3505f0b1eca41e98d2d5c761f379708c4
LABEL com.redhat.art.name=zero-trust-workload-identity-manager-fbc
LABEL com.redhat.art.nvr=zero-trust-workload-identity-manager-fbc-1.1.2-20261029071207.ocp4.22
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/zero-trust-workload-identity-manager/zero-trust-workload-identity-manager-operator-bundle@sha256:d09148da96fcb0ea8963ebadefc494d2063ccb65e06ed1b4ccd9e4745524f6be
