# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift5/ose-operator-registry-rhel9:v5.0 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift5/ose-operator-registry-rhel9:v5.0
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
ENV __doozer_group=kueue-1.5
ENV __doozer_key=kueue-operator
ENV __doozer_version=1.5.1
ENV __doozer_release=20261105024207.ocp5.0
ENV __doozer_bundle_nvrs=kueue-operator-metadata-container-1.5.1.202611042247.p2.g44342d5.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/kueue-operator
LABEL io.openshift.build.commit.id=44342d5feb4e5ea26f39eeaeda79c980f85440e6
LABEL com.redhat.art.name=kueue-operator-fbc
LABEL com.redhat.art.nvr=kueue-operator-fbc-1.5.1-20261105024207.ocp5.0
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/kueue/kueue-operator-bundle@sha256:2c5fca530147a6fe7fb976657c5cd4962c5dbbb9ab539b62a799e965dd117197
