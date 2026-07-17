# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry:v4.13 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry:v4.13
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
ENV __doozer_group=oadp-1.3
ENV __doozer_key=oadp-operator
ENV __doozer_version=1.3.10
ENV __doozer_release=20260717190745.ocp4.13
ENV __doozer_bundle_nvrs=oadp-operator-metadata-container-1.3.10.202607171804.p2.gc575673.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/oadp-operator
LABEL io.openshift.build.commit.id=c5756737f1e0fca55fa660da877375d0969cebb5
LABEL com.redhat.art.name=oadp-operator-fbc
LABEL com.redhat.art.nvr=oadp-operator-fbc-1.3.10-20260717190745.ocp4.13
