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
ENV __doozer_group=mta-8.3
ENV __doozer_key=mta-operator
ENV __doozer_version=8.3.4
ENV __doozer_release=20261105013657.ocp4.18
ENV __doozer_bundle_nvrs=mta-operator-metadata-container-8.3.4.202611042311.p2.g3cceead.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/migtools/mta-operator
LABEL io.openshift.build.commit.id=3cceeadbf069e8c1b6af6e4aafd8c38e39489458
LABEL com.redhat.art.name=mta-operator-fbc
LABEL com.redhat.art.nvr=mta-operator-fbc-8.3.4-20261105013657.ocp4.18
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/mta/mta-operator-bundle@sha256:6c20290720f8bfcc33d0e857461570233d208db71c539333d329e255e198e42d
