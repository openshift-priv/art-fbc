# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v5.0 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v5.0
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
ENV __doozer_group=openshift-5.0
ENV __doozer_key=pf-status-relay-operator
ENV __doozer_version=5.0.0
ENV __doozer_release=20260702223921
ENV __doozer_bundle_nvrs=pf-status-relay-operator-bundle-container-v5.0.0.202606250141.p2.gc0ce5e1.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/pf-status-relay-operator
LABEL io.openshift.build.commit.id=c0ce5e1554f4e2d0c3195c7736b0625dc4d1bf05
LABEL com.redhat.art.name=pf-status-relay-operator-fbc
LABEL com.redhat.art.nvr=pf-status-relay-operator-fbc-5.0.0-20260702223921
