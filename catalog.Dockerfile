# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.19 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.19
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
ENV __doozer_group=mta-8.1
ENV __doozer_key=mta-operator
ENV __doozer_version=8.1.1
ENV __doozer_release=20260408003120.ocp4.19
ENV __doozer_bundle_nvrs=mta-operator-metadata-container-8.1.1.202604080006.p2.ga19cee4.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/migtools/mta-operator
LABEL io.openshift.build.commit.id=a19cee4c56c1cf82e09c5ebd024c07effbcd1e6a
LABEL com.redhat.art.name=mta-operator-fbc
LABEL com.redhat.art.nvr=mta-operator-fbc-8.1.1-20260408003120.ocp4.19
