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
ENV __doozer_group=quay-3.17
ENV __doozer_key=container-security-operator
ENV __doozer_version=3.17.5
ENV __doozer_release=20260831131344.ocp4.22
ENV __doozer_bundle_nvrs=container-security-operator-metadata-container-3.17.5.202608311209.p2.gc9f8934.assembly.test.el9-1
LABEL io.openshift.build.source-location=https://github.com/quay/container-security-operator
LABEL io.openshift.build.commit.id=c9f8934565f37ec0adf038b0379abc6012a0e95a
LABEL com.redhat.art.name=container-security-operator-fbc
LABEL com.redhat.art.nvr=container-security-operator-fbc-3.17.5-20260831131344.ocp4.22
