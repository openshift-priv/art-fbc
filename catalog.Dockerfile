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
ENV __doozer_group=cert-manager-1.19
ENV __doozer_key=cert-manager-operator
ENV __doozer_version=1.19.0
ENV __doozer_release=20260812155234.ocp4.22
ENV __doozer_bundle_nvrs=cert-manager-operator-metadata-container-1.19.0.202608121506.p2.g0402666.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/cert-manager-operator
LABEL io.openshift.build.commit.id=04026660a8f5561b2d792bc0f6b3fd9cadb8c7bd
LABEL com.redhat.art.name=cert-manager-operator-fbc
LABEL com.redhat.art.nvr=cert-manager-operator-fbc-1.19.0-20260812155234.ocp4.22
