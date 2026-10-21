# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.21 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.21
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
ENV __doozer_group=openshift-4.21
ENV __doozer_key=ptp-operator
ENV __doozer_version=4.21.0
ENV __doozer_release=20261021082618
ENV __doozer_bundle_nvrs=ose-ptp-operator-metadata-container-v4.21.0.202610210701.p2.g8801c59.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/ptp-operator
LABEL io.openshift.build.commit.id=8801c591e4b990ed669cac28fb77b8268a38726a
LABEL com.redhat.art.name=ptp-operator-fbc
LABEL com.redhat.art.nvr=ptp-operator-fbc-4.21.0-20261021082618
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-ptp-operator-bundle@sha256:a73b05f7d1a616921ecfbf6378b5b6d7abf441ee58ffab57e946d25d301578c3
