# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.23 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.23
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
ENV __doozer_group=kueue-1.5
ENV __doozer_key=kueue-operator
ENV __doozer_version=1.5.1
ENV __doozer_release=20261111192446.ocp4.23
ENV __doozer_bundle_nvrs=kueue-operator-metadata-container-1.5.1.202611111824.p2.g9b4acc2.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/kueue-operator
LABEL io.openshift.build.commit.id=9b4acc23b49df5ec467ddfc60bb23db1a89469da
LABEL com.redhat.art.name=kueue-operator-fbc
LABEL com.redhat.art.nvr=kueue-operator-fbc-1.5.1-20261111192446.ocp4.23
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/kueue/kueue-operator-bundle@sha256:aa86865784876bd97377504780460d8c972dfcc549607c50a4961d269ca2ba21
