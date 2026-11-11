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
ENV __doozer_release=20261111223500.ocp4.13
ENV __doozer_bundle_nvrs=oadp-operator-metadata-container-1.3.10.202611112052.p2.g0386a65.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/oadp-operator
LABEL io.openshift.build.commit.id=0386a65531002ba9bbc74ca86b9499a8ab25d6a2
LABEL com.redhat.art.name=oadp-operator-fbc
LABEL com.redhat.art.nvr=oadp-operator-fbc-1.3.10-20261111223500.ocp4.13
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/oadp/oadp-operator-bundle@sha256:f95535b4661a7efe5ec9aeb086f481261e4c9a7b8d42def2063a42e1866f4b06
