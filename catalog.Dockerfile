# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.18 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.18
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
ENV __doozer_group=openshift-4.18
ENV __doozer_key=cluster-nfd-operator
ENV __doozer_version=4.18.0
ENV __doozer_release=20261015023032
ENV __doozer_bundle_nvrs=cluster-nfd-operator-metadata-container-v4.18.0.202610141759.p2.ga722bc5.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/cluster-nfd-operator
LABEL io.openshift.build.commit.id=a722bc5fb97f36bd8e79049098e3dbf57bd6e812
LABEL com.redhat.art.name=cluster-nfd-operator-fbc
LABEL com.redhat.art.nvr=cluster-nfd-operator-fbc-4.18.0-20261015023032
LABEL com.redhat.art.bundle.pullspec=quay.io/redhat-user-workloads/ocp-art-tenant/art-images@sha256:e97032aa8e10f08c9f3933f24e1073e0cd5e01be494bfd79d307cda4639001da
