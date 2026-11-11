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
ENV __doozer_group=mta-8.3
ENV __doozer_key=mta-operator
ENV __doozer_version=8.3.4
ENV __doozer_release=20261111234306.ocp4.20
ENV __doozer_bundle_nvrs=mta-operator-metadata-container-8.3.4.202611112052.p2.g3cceead.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/migtools/mta-operator
LABEL io.openshift.build.commit.id=3cceeadbf069e8c1b6af6e4aafd8c38e39489458
LABEL com.redhat.art.name=mta-operator-fbc
LABEL com.redhat.art.nvr=mta-operator-fbc-8.3.4-20261111234306.ocp4.20
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/mta/mta-operator-bundle@sha256:b63c536ce4029ad637a86508a22fa7f14e1ff324965187301211bd78687ade07
