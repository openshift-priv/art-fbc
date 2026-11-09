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
ENV __doozer_group=openshift-4.13
ENV __doozer_key=ose-metallb-operator
ENV __doozer_version=4.13.0
ENV __doozer_release=20261109075117
ENV __doozer_bundle_nvrs=ose-metallb-operator-bundle-container-v4.13.0.202611090403.p2.gb196b6e.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/openshift/metallb-operator
LABEL io.openshift.build.commit.id=b196b6e5286f48a230e43266b905a56d8c6067be
LABEL com.redhat.art.name=ose-metallb-operator-fbc
LABEL com.redhat.art.nvr=ose-metallb-operator-fbc-4.13.0-20261109075117
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-metallb-operator-bundle@sha256:581c40afe6da2564ef0b6bfd185d147364d644fe1daf6f7c1d4572572d54b299
