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
ENV __doozer_group=logging-6.4
ENV __doozer_key=cluster-logging-operator
ENV __doozer_version=6.4.0
ENV __doozer_release=20261023195744.ocp4.20
ENV __doozer_bundle_nvrs=ose-cluster-logging-operator-metadata-container-6.4.8.202610231521.p2.ga124201.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/cluster-logging-operator
LABEL io.openshift.build.commit.id=a1242018cd9d300bc81d73b32f2d8ffb43dce81a
LABEL com.redhat.art.name=cluster-logging-operator-fbc
LABEL com.redhat.art.nvr=cluster-logging-operator-fbc-6.4.0-20261023195744.ocp4.20
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift-logging/cluster-logging-operator-bundle@sha256:c7f1f2bfac4bcf66100f58ec18a44b9866ce0cbc9b5dfcd8c20d956b58688664
