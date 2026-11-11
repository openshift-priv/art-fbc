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
ENV __doozer_key=clusterresourceoverride-operator
ENV __doozer_version=4.20.0
ENV __doozer_release=20261111131143
ENV __doozer_bundle_nvrs=ose-clusterresourceoverride-operator-metadata-container-v4.20.0.202611110219.p2.g335425a.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/cluster-resource-override-admission-operator
LABEL io.openshift.build.commit.id=335425af10fc36afa600aec6bcbdd81c9f0dc029
LABEL com.redhat.art.name=clusterresourceoverride-operator-fbc
LABEL com.redhat.art.nvr=clusterresourceoverride-operator-fbc-4.20.0-20261111131143
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-clusterresourceoverride-operator-bundle@sha256:2ab51f3efb36ac79611eaeec79c2062da7667b737607e33de766163275f44989
