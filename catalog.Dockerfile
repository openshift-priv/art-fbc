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
ENV __doozer_key=openshift-kubernetes-nmstate-operator
ENV __doozer_version=4.22.0
ENV __doozer_release=20261111114907
ENV __doozer_bundle_nvrs=ose-kubernetes-nmstate-operator-bundle-container-v4.22.0.202611110234.p2.g1d6d332.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/kubernetes-nmstate
LABEL io.openshift.build.commit.id=1d6d332026b97b6e48d1aff79ad442f9f0a86bd6
LABEL com.redhat.art.name=openshift-kubernetes-nmstate-operator-fbc
LABEL com.redhat.art.nvr=openshift-kubernetes-nmstate-operator-fbc-4.22.0-20261111114907
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/kubernetes-nmstate-operator-bundle@sha256:502d76b7ebccb269b0c95f3916519eaa13b6e703feba9268255aea19a0a3fc52
