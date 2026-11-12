# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift5/ose-operator-registry-rhel9:v5.1 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift5/ose-operator-registry-rhel9:v5.1
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
ENV __doozer_group=openshift-5.1
ENV __doozer_key=openshift-kubernetes-nmstate-operator
ENV __doozer_version=5.1.0
ENV __doozer_release=20261112052145
ENV __doozer_bundle_nvrs=ose-kubernetes-nmstate-operator-bundle-container-v5.1.0.202611111959.p2.gfc1566c.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/kubernetes-nmstate
LABEL io.openshift.build.commit.id=fc1566c60b59561cc43e00cfa99fee3548eab8fa
LABEL com.redhat.art.name=openshift-kubernetes-nmstate-operator-fbc
LABEL com.redhat.art.nvr=openshift-kubernetes-nmstate-operator-fbc-5.1.0-20261112052145
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift5/kubernetes-nmstate-operator-bundle@sha256:b6220161fe282fe6bfefbb61a978b30db83ada0caf30e0f772f3dc50f8d1610c
