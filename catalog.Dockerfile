# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift5/ose-operator-registry-rhel9:v5.1 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift5/ose-operator-registry-rhel9:v5.1
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
ENV __doozer_group=openshift-5.1
ENV __doozer_key=ose-support-log-gather-operator
ENV __doozer_version=5.1.0
ENV __doozer_release=20261030172414
ENV __doozer_bundle_nvrs=ose-support-log-gather-operator-bundle-container-v5.1.0.202610300525.p2.ga57b2ed.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/must-gather-operator
LABEL io.openshift.build.commit.id=a57b2edfa5cb0c5c79c83113a3a1ce73ba25246c
LABEL com.redhat.art.name=ose-support-log-gather-operator-fbc
LABEL com.redhat.art.nvr=ose-support-log-gather-operator-fbc-5.1.0-20261030172414
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift5/ose-support-log-gather-operator-bundle@sha256:295b93bf7db3d3205eef6acfdc8d79237b1423057af4aba4cee6c52daff3f0ee
