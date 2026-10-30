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
ENV __doozer_release=20261030014016
ENV __doozer_bundle_nvrs=ose-metallb-operator-bundle-container-v4.14.0.202610291928.p2.g354718e.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/metallb-operator
LABEL io.openshift.build.commit.id=354718e5bcf27c22cffba6d49543a6a481d4fe35
LABEL com.redhat.art.name=ose-metallb-operator-fbc
LABEL com.redhat.art.nvr=ose-metallb-operator-fbc-4.14.0-20261030014016
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-metallb-operator-bundle@sha256:1978149fe417131e48414084e3b968fd569a6651465d2c341581ec7aca5b21a4
