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
ENV __doozer_key=clusterresourceoverride-operator
ENV __doozer_version=4.14.0
ENV __doozer_release=20261027105353
ENV __doozer_bundle_nvrs=ose-clusterresourceoverride-operator-metadata-container-v4.14.0.202610270214.p2.g022e925.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/openshift/cluster-resource-override-admission-operator
LABEL io.openshift.build.commit.id=022e9252c7060033a47b28c3446295bd3fd4c005
LABEL com.redhat.art.name=clusterresourceoverride-operator-fbc
LABEL com.redhat.art.nvr=clusterresourceoverride-operator-fbc-4.14.0-20261027105353
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-clusterresourceoverride-operator-bundle@sha256:cc4d258d38430a3402464adc1b6f474ecf13a592be672a9f9d0649dcefbd6823
