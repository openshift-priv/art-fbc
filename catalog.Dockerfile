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
ENV __doozer_key=helloworld-operator
ENV __doozer_version=4.18.0
ENV __doozer_release=20250711060142
ENV __doozer_bundle_nvrs=helloworld-operator-bundle-container-v4.18.0.202506160933.p2.g1a444ee.assembly.stream.el9-2
LABEL io.openshift.build.source-location=https://github.com/openshift-eng/ocp-build-data
LABEL io.openshift.build.commit.id=1a444eee3a8c3f9ba3542ccd359b77e1b2dbdc7f
LABEL com.redhat.art.name=helloworld-operator-fbc
LABEL com.redhat.art.nvr=helloworld-operator-fbc-4.18.0-20250711060142
