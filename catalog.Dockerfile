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
ENV __doozer_key=quay-bridge-operator
ENV __doozer_version=3.17.7
ENV __doozer_release=20261104220916.ocp4.22
ENV __doozer_bundle_nvrs=quay-bridge-operator-metadata-container-3.17.7.202611041726.p2.g0ba300e.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/quay/quay-bridge-operator
LABEL io.openshift.build.commit.id=0ba300ee7389447ee0920c96f40aff25b5a7fbba
LABEL com.redhat.art.name=quay-bridge-operator-fbc
LABEL com.redhat.art.nvr=quay-bridge-operator-fbc-3.17.7-20261104220916.ocp4.22
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/quay/quay-bridge-operator-bundle@sha256:7e483f3038ad188505a6609dc558e81c56410fdaf587f8836ec5b27698e82c06
