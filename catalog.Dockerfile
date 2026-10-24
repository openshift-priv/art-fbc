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
ENV __doozer_group=quay-3.16
ENV __doozer_key=container-security-operator
ENV __doozer_version=3.16.7
ENV __doozer_release=20261024153702.ocp4.12
ENV __doozer_bundle_nvrs=container-security-operator-metadata-container-3.16.7.202610241446.p2.gce626cf.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/quay/container-security-operator
LABEL io.openshift.build.commit.id=ce626cfd72e032972421ca9713fc61e33aad1516
LABEL com.redhat.art.name=container-security-operator-fbc
LABEL com.redhat.art.nvr=container-security-operator-fbc-3.16.7-20261024153702.ocp4.12
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/quay/quay-container-security-operator-bundle@sha256:fe296c82ae68b2d0d5a40c0000d8897306384e379765d3c60d829a3620a893ce
