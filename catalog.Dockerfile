# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.19 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.19
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
ENV __doozer_group=mce-2.17
ENV __doozer_key=backplane-operator
ENV __doozer_version=2.17.4
ENV __doozer_release=20261014133319.ocp4.19
ENV __doozer_bundle_nvrs=mce-backplane-operator-metadata-container-2.17.4.202610141153.p2.gb34ad2b.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/stolostron/backplane-operator
LABEL io.openshift.build.commit.id=b34ad2b4c8c9c59ce98a21591cdfba5c043dcc6d
LABEL com.redhat.art.name=backplane-operator-fbc
LABEL com.redhat.art.nvr=backplane-operator-fbc-2.17.4-20261014133319.ocp4.19
LABEL com.redhat.art.bundle.pullspec=quay.io/redhat-user-workloads/ocp-art-tenant/art-images@sha256:e0886db2f744a422f1d022eb6f63b8daab10c4a7e6ea632317f87f36bfbcde8d
