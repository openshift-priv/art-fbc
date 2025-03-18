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
ENV __doozer_key=ose-cluster-kube-descheduler-operator
ENV __doozer_version=4.14.0
ENV __doozer_release=20250318065540
ENV __doozer_bundle_nvrs=ose-cluster-kube-descheduler-operator-bundle-v4.14.0.202503180630.p0.gcd52d96.assembly.test.el8-1
LABEL io.openshift.build.source-location=https://github.com/openshift/cluster-kube-descheduler-operator
LABEL io.openshift.build.commit.id=cd52d9687e5ea28f0a05523eca14d1ac615b83b8
