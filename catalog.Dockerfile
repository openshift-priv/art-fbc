# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry:v4.12 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry:v4.12
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
ENV __doozer_group=quay-3.14
ENV __doozer_key=container-security-operator
ENV __doozer_version=3.14.11
ENV __doozer_release=20261124182749.ocp4.12
ENV __doozer_bundle_nvrs=container-security-operator-metadata-container-3.14.11.202611241502.p2.g1962c88.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/quay/container-security-operator
LABEL io.openshift.build.commit.id=1962c886b578e7f522f1b8b9f44aff4290672c9e
LABEL com.redhat.art.name=container-security-operator-fbc
LABEL com.redhat.art.nvr=container-security-operator-fbc-3.14.11-20261124182749.ocp4.12
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/quay/quay-container-security-operator-bundle@sha256:9d070ec888eaf2c52b9a0688cfd00ad1635e360d877db6c350ad8075e68bd733
