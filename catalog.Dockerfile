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
ENV __doozer_group=openshift-5.0
ENV __doozer_key=local-storage-operator
ENV __doozer_version=5.0.0
ENV __doozer_release=20261028152623
ENV __doozer_bundle_nvrs=local-storage-operator-metadata-container-v5.0.0.202610271435.p2.g3e6582a.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/local-storage-operator
LABEL io.openshift.build.commit.id=3e6582a04c6bab535600043bd90d7865ff9a3a80
LABEL com.redhat.art.name=local-storage-operator-fbc
LABEL com.redhat.art.nvr=local-storage-operator-fbc-5.0.0-20261028152623
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift5/ose-local-storage-operator-bundle@sha256:e4dafd335c317ed5f804ac37ba70d497e4bb42c1d8df4550c3230377a0f1e5dc
