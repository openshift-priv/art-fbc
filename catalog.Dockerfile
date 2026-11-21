# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.22 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.22
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
ENV __doozer_group=logging-6.5
ENV __doozer_key=cluster-logging-operator
ENV __doozer_version=6.5.5
ENV __doozer_release=20261121022315.ocp4.22
ENV __doozer_bundle_nvrs=ose-cluster-logging-operator-metadata-container-6.5.5.202611202313.p2.ge55461c.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/cluster-logging-operator
LABEL io.openshift.build.commit.id=e55461c41df0d23fccfcdf9bdc57db82cd7ab9ea
LABEL com.redhat.art.name=cluster-logging-operator-fbc
LABEL com.redhat.art.nvr=cluster-logging-operator-fbc-6.5.5-20261121022315.ocp4.22
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift-logging/cluster-logging-operator-bundle@sha256:23c2880d4e90f7a06b1b652509d6d49d633957139a7350fff522e733f951808c
