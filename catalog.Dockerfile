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
ENV __doozer_group=zero-trust-1.0
ENV __doozer_key=zero-trust-workload-identity-manager
ENV __doozer_version=1.0.3
ENV __doozer_release=20261015194415.ocp4.18
ENV __doozer_bundle_nvrs=zero-trust-workload-identity-manager-metadata-container-1.0.3.202610151442.p2.ga41fb56.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/zero-trust-workload-identity-manager
LABEL io.openshift.build.commit.id=a41fb56a76a5199e05e63bfdc1bcf2147a4556c1
LABEL com.redhat.art.name=zero-trust-workload-identity-manager-fbc
LABEL com.redhat.art.nvr=zero-trust-workload-identity-manager-fbc-1.0.3-20261015194415.ocp4.18
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/zero-trust-workload-identity-manager/zero-trust-workload-identity-manager-operator-bundle@sha256:b979dac36824e0e93fc935e92657e92b656af2acb8a5531970c3528b8bd6581c
