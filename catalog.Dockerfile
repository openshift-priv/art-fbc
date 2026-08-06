# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.21 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.21
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
ENV __doozer_group=external-secrets-1.1
ENV __doozer_key=external-secrets-operator
ENV __doozer_version=1.1.0
ENV __doozer_release=20260806101731.ocp4.21
ENV __doozer_bundle_nvrs=external-secrets-operator-metadata-container-1.1.0.202608060926.p2.g28fd76a.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/external-secrets-operator
LABEL io.openshift.build.commit.id=28fd76a94ae867ac76b63102e4e70cd2fa7ba7f5
LABEL com.redhat.art.name=external-secrets-operator-fbc
LABEL com.redhat.art.nvr=external-secrets-operator-fbc-1.1.0-20260806101731.ocp4.21
