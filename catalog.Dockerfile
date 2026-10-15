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
ENV __doozer_key=pf-status-relay-operator
ENV __doozer_version=4.21.0
ENV __doozer_release=20261015070338
ENV __doozer_bundle_nvrs=pf-status-relay-operator-bundle-container-v4.21.0.202610141028.p2.ge08ab06.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/pf-status-relay-operator
LABEL io.openshift.build.commit.id=e08ab06dd18955ac0772ccfda31f2b79d3bead52
LABEL com.redhat.art.name=pf-status-relay-operator-fbc
LABEL com.redhat.art.nvr=pf-status-relay-operator-fbc-4.21.0-20261015070338
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/pf-status-relay-operator-bundle@sha256:aa204896ed17a94cc0ba1f6b913e7597e2ebf3c7c302f981baf6b178bfdc972e
