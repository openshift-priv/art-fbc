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
ENV __doozer_group=oadp-1.6
ENV __doozer_key=oadp-operator
ENV __doozer_version=1.6.2
ENV __doozer_release=20261023153217.ocp5.0
ENV __doozer_bundle_nvrs=oadp-operator-metadata-container-1.6.2.202610231409.p2.g483de5e.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/oadp-operator
LABEL io.openshift.build.commit.id=483de5e05055352af7500c46bf40f5b9b447ddb8
LABEL com.redhat.art.name=oadp-operator-fbc
LABEL com.redhat.art.nvr=oadp-operator-fbc-1.6.2-20261023153217.ocp5.0
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/oadp/oadp-operator-bundle@sha256:edf820c75184b182b8c474e14989067b7f7b2f6d01c3c669b4b47e7fa4c62092
