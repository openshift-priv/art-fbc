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
ENV __doozer_group=openshift-4.18
ENV __doozer_key=pf-status-relay-operator
ENV __doozer_version=4.18.0
ENV __doozer_release=20261019142742
ENV __doozer_bundle_nvrs=pf-status-relay-operator-bundle-container-v4.18.0.202610190155.p2.gc20e0b7.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/pf-status-relay-operator
LABEL io.openshift.build.commit.id=c20e0b701ac4352662567eca41ecd821fbc9b4ab
LABEL com.redhat.art.name=pf-status-relay-operator-fbc
LABEL com.redhat.art.nvr=pf-status-relay-operator-fbc-4.18.0-20261019142742
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/pf-status-relay-operator-bundle@sha256:fa397fa9e4c57feb5fac7578917d303d7650ee898b3d2c588f639f383f23f3a8
