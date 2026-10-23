# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry:v4.13 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry:v4.13
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
ENV __doozer_group=quay-3.10
ENV __doozer_key=container-security-operator
ENV __doozer_version=3.10.28
ENV __doozer_release=20261023182332.ocp4.13
ENV __doozer_bundle_nvrs=container-security-operator-metadata-container-3.10.28.202610231528.p2.gbff71d4.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/quay/container-security-operator
LABEL io.openshift.build.commit.id=bff71d49a63432a4ab519b6e9cf9fff6d0f9a0b9
LABEL com.redhat.art.name=container-security-operator-fbc
LABEL com.redhat.art.nvr=container-security-operator-fbc-3.10.28-20261023182332.ocp4.13
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/quay/quay-container-security-operator-bundle@sha256:f570bb56b41f70a9f0f178dbb1d333a8850da4c0c338f846c6b62125ed300c13
