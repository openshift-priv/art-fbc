# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry:v4.14 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry:v4.14
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
ENV __doozer_group=openshift-4.14
ENV __doozer_key=ose-metallb-operator
ENV __doozer_version=4.14.0
ENV __doozer_release=20261026195830
ENV __doozer_bundle_nvrs=ose-metallb-operator-bundle-container-v4.14.0.202610261004.p2.g354718e.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/metallb-operator
LABEL io.openshift.build.commit.id=354718e5bcf27c22cffba6d49543a6a481d4fe35
LABEL com.redhat.art.name=ose-metallb-operator-fbc
LABEL com.redhat.art.nvr=ose-metallb-operator-fbc-4.14.0-20261026195830
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-metallb-operator-bundle@sha256:8cbb0edd69320bd17fea0d09bc1830412dd19d4c0a10480f1269819b6c2c8f6f
