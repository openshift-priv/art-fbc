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
ENV __doozer_group=openshift-4.20
ENV __doozer_key=local-storage-operator
ENV __doozer_version=4.20.0
ENV __doozer_release=20261024170216
ENV __doozer_bundle_nvrs=local-storage-operator-metadata-container-v4.20.0.202610241310.p2.gd81ba42.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/local-storage-operator
LABEL io.openshift.build.commit.id=d81ba42d8d3a6fbb501b5507fec069d429410892
LABEL com.redhat.art.name=local-storage-operator-fbc
LABEL com.redhat.art.nvr=local-storage-operator-fbc-4.20.0-20261024170216
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-local-storage-operator-bundle@sha256:405215c82e60c2007f8fce11c6b7af95ab936d0a5ec9c51ff10e4e6c60ab89e4
