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
ENV __doozer_group=mta-8.0
ENV __doozer_key=mta-operator
ENV __doozer_version=8.0.99
ENV __doozer_release=20251119021348
ENV __doozer_bundle_nvrs=mta-operator-metadata-container-8.0.99.202511190053.p2.g7344b5e.assembly.test.el9-1
LABEL io.openshift.build.source-location=https://github.com/migtools/mta-operator
LABEL io.openshift.build.commit.id=7344b5e6ef6ba1316d49e85fd061bba34b33a896
LABEL com.redhat.art.name=mta-operator-fbc
LABEL com.redhat.art.nvr=mta-operator-fbc-8.0.99-20251119021348
