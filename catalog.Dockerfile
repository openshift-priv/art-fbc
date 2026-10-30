# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.15 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.15
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
ENV __doozer_group=openshift-4.15
ENV __doozer_key=clusterresourceoverride-operator
ENV __doozer_version=4.15.0
ENV __doozer_release=20261030165842
ENV __doozer_bundle_nvrs=ose-clusterresourceoverride-operator-metadata-container-v4.15.0.202610300314.p2.gb27143a.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/cluster-resource-override-admission-operator
LABEL io.openshift.build.commit.id=b27143a9d8cda17afb4740fc6b3e46156474b4f5
LABEL com.redhat.art.name=clusterresourceoverride-operator-fbc
LABEL com.redhat.art.nvr=clusterresourceoverride-operator-fbc-4.15.0-20261030165842
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-clusterresourceoverride-operator-bundle@sha256:bf39e58c111639b4c3d781487e2216e10ee953bf73d5b184d4c35a755639eedb
