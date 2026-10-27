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
ENV __doozer_release=20261027101126
ENV __doozer_bundle_nvrs=ose-kubernetes-nmstate-operator-bundle-container-v5.1.0.202610262325.p2.g0043de9.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/kubernetes-nmstate
LABEL io.openshift.build.commit.id=0043de9e98d9fc61b9a8e23daf6ce3d039ec8101
LABEL com.redhat.art.name=openshift-kubernetes-nmstate-operator-fbc
LABEL com.redhat.art.nvr=openshift-kubernetes-nmstate-operator-fbc-5.1.0-20261027101126
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift5/kubernetes-nmstate-operator-bundle@sha256:18ef0c3f3ff8ab22c4c69a7f8a0ba0c4bae5d59fca8c9033884525c5d482d458
