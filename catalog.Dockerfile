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
ENV __doozer_group=openshift-4.23
ENV __doozer_key=pf-status-relay-operator
ENV __doozer_version=4.23.0
ENV __doozer_release=20261020031437
ENV __doozer_bundle_nvrs=pf-status-relay-operator-bundle-container-v4.23.0.202610200135.p2.ge4fa4ed.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/pf-status-relay-operator
LABEL io.openshift.build.commit.id=e4fa4ed83f8632965f7e0b126b6c90ce6f593bb4
LABEL com.redhat.art.name=pf-status-relay-operator-fbc
LABEL com.redhat.art.nvr=pf-status-relay-operator-fbc-4.23.0-20261020031437
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/pf-status-relay-operator-bundle@sha256:f12564451b21f7a1659261343c938935ef1fe2cfb491f1efeb58b3f33ed54a6e
