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
ENV __doozer_key=ptp-operator
ENV __doozer_version=5.1.0
ENV __doozer_release=20261020110301
ENV __doozer_bundle_nvrs=ose-ptp-operator-metadata-container-v5.1.0.202610200350.p2.g591eef7.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/ptp-operator
LABEL io.openshift.build.commit.id=591eef7818390eb6b105974115e1b07d43a9a95f
LABEL com.redhat.art.name=ptp-operator-fbc
LABEL com.redhat.art.nvr=ptp-operator-fbc-5.1.0-20261020110301
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift5/ose-ptp-operator-bundle@sha256:5afc2fcd4e9c6cecd13b2dbd61d7f28bf7657a2c42b121cd90dd25ef415056a4
