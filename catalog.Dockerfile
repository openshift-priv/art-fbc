# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.20 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.20
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
ENV __doozer_group=openshift-4.20
ENV __doozer_key=openshift-kubernetes-nmstate-operator
ENV __doozer_version=4.20.0
ENV __doozer_release=20261120181903
ENV __doozer_bundle_nvrs=ose-kubernetes-nmstate-operator-bundle-container-v4.20.0.202611200817.p2.g05a8f6d.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/kubernetes-nmstate
LABEL io.openshift.build.commit.id=05a8f6d24df4b845d2b88eca202ffae5071081fa
LABEL com.redhat.art.name=openshift-kubernetes-nmstate-operator-fbc
LABEL com.redhat.art.nvr=openshift-kubernetes-nmstate-operator-fbc-4.20.0-20261120181903
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/kubernetes-nmstate-operator-bundle@sha256:acb7c168e5116270a03edceec9b1945a9e9a4ceccc1bfad9e58161fd098837f0
