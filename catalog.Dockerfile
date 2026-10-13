# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry:v4.13 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry:v4.13
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
ENV __doozer_group=openshift-4.13
ENV __doozer_key=openshift-kubernetes-nmstate-operator
ENV __doozer_version=4.13.0
ENV __doozer_release=20261013075713
ENV __doozer_bundle_nvrs=ose-kubernetes-nmstate-operator-bundle-container-v4.13.0.202610130416.p2.gb4452e6.assembly.stream.el8-1
LABEL io.openshift.build.source-location=https://github.com/openshift/kubernetes-nmstate
LABEL io.openshift.build.commit.id=b4452e69c86bedc30d0dbba1701086e396ef97dd
LABEL com.redhat.art.name=openshift-kubernetes-nmstate-operator-fbc
LABEL com.redhat.art.nvr=openshift-kubernetes-nmstate-operator-fbc-4.13.0-20261013075713
LABEL com.redhat.art.bundle.pullspec=quay.io/redhat-user-workloads/ocp-art-tenant/art-images@sha256:ac250949f0c7b2d8d0cd2da92b6b9a0bb53a6712bff1ec6a3ee432d23b1ba01c
