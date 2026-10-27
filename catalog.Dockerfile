# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry:v4.14 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry:v4.14
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
ENV __doozer_group=openshift-4.14
ENV __doozer_key=openshift-kubernetes-nmstate-operator
ENV __doozer_version=4.14.0
ENV __doozer_release=20261027105353
ENV __doozer_bundle_nvrs=ose-kubernetes-nmstate-operator-bundle-container-v4.14.0.202610270214.p2.g8f354cd.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/kubernetes-nmstate
LABEL io.openshift.build.commit.id=8f354cd2f866bbd2e7c9edc8d9d1fea0faaef028
LABEL com.redhat.art.name=openshift-kubernetes-nmstate-operator-fbc
LABEL com.redhat.art.nvr=openshift-kubernetes-nmstate-operator-fbc-4.14.0-20261027105353
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/kubernetes-nmstate-operator-bundle@sha256:f0fcd066720c5a0cfb9c3f3e4ae1a68025d006770e0812a5e37b14be3b11f7a8
