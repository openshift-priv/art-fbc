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
ENV __doozer_group=openshift-4.12
ENV __doozer_key=clusterresourceoverride-operator
ENV __doozer_version=4.12.0
ENV __doozer_release=20261027134323
ENV __doozer_bundle_nvrs=ose-clusterresourceoverride-operator-metadata-container-v4.12.0.202610271002.p2.g100ed5b.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/openshift/cluster-resource-override-admission-operator
LABEL io.openshift.build.commit.id=100ed5b2a145789cd9635d3aeccbe8b2de22ed46
LABEL com.redhat.art.name=clusterresourceoverride-operator-fbc
LABEL com.redhat.art.nvr=clusterresourceoverride-operator-fbc-4.12.0-20261027134323
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-clusterresourceoverride-operator-bundle@sha256:982ee3e54e9eddc57c874c4f25e7078f72da509c4587ce7d07d2c244778dc897
