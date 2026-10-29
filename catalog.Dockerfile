# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.22 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.22
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
ENV __doozer_group=openshift-4.22
ENV __doozer_key=sriov-network-operator
ENV __doozer_version=4.22.0
ENV __doozer_release=20261029090857
ENV __doozer_bundle_nvrs=sriov-network-operator-metadata-container-v4.22.0.202610280358.p2.ga9706d1.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/sriov-network-operator
LABEL io.openshift.build.commit.id=a9706d180009034047a6742484fc8715dd021580
LABEL com.redhat.art.name=sriov-network-operator-fbc
LABEL com.redhat.art.nvr=sriov-network-operator-fbc-4.22.0-20261029090857
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-sriov-network-operator-bundle@sha256:50ddf28c64a4237eb2e3fcc11e81510da7e6b0d1f174c130e52d9d24050b57a1
