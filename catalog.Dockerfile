# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.23 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.23
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
ENV __doozer_version=1.6.0
ENV __doozer_release=20261023181334.ocp4.23
ENV __doozer_bundle_nvrs=oadp-operator-metadata-container-1.6.2.202610231516.p2.g483de5e.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/oadp-operator
LABEL io.openshift.build.commit.id=483de5e05055352af7500c46bf40f5b9b447ddb8
LABEL com.redhat.art.name=oadp-operator-fbc
LABEL com.redhat.art.nvr=oadp-operator-fbc-1.6.0-20261023181334.ocp4.23
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/oadp/oadp-operator-bundle@sha256:0ca9885ac3f996eb3394f3bf20a68f5a64f217416ef4b93573597536320a315a
