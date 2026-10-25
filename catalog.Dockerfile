# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.16 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.16
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
ENV __doozer_group=openshift-4.16
ENV __doozer_key=clusterresourceoverride-operator
ENV __doozer_version=4.16.0
ENV __doozer_release=20261025185730
ENV __doozer_bundle_nvrs=ose-clusterresourceoverride-operator-metadata-container-v4.16.0.202610242033.p2.gda8cad0.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/cluster-resource-override-admission-operator
LABEL io.openshift.build.commit.id=da8cad094f77fd0980705f712b577d25b6c964a9
LABEL com.redhat.art.name=clusterresourceoverride-operator-fbc
LABEL com.redhat.art.nvr=clusterresourceoverride-operator-fbc-4.16.0-20261025185730
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-clusterresourceoverride-operator-bundle@sha256:1f8d8f9862e649740bdb5a4c2587d2cfc0b563c77e06cc805c6aff1e822e1dff
