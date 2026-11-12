# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.19 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.19
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
ENV __doozer_group=openshift-4.19
ENV __doozer_key=ose-metallb-operator
ENV __doozer_version=4.19.0
ENV __doozer_release=20261112125410
ENV __doozer_bundle_nvrs=ose-metallb-operator-bundle-container-v4.19.0.202611120549.p2.g1e1cf0e.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/metallb-operator
LABEL io.openshift.build.commit.id=1e1cf0ec89490e9a890fc21fbf87c8a62cbaab00
LABEL com.redhat.art.name=ose-metallb-operator-fbc
LABEL com.redhat.art.nvr=ose-metallb-operator-fbc-4.19.0-20261112125410
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-metallb-operator-bundle@sha256:379e22050a754c65b6bdaa7a4b1f2737661b859ed749d5dc4fe7ef46c18e13e0
