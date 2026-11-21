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
ENV __doozer_key=ose-metallb-operator
ENV __doozer_version=4.20.0
ENV __doozer_release=20261121215738
ENV __doozer_bundle_nvrs=ose-metallb-operator-bundle-container-v4.20.0.202611201826.p2.gdb17c2b.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/metallb-operator
LABEL io.openshift.build.commit.id=db17c2b5bddc7457e3c86f3948e396ef8a1ba19a
LABEL com.redhat.art.name=ose-metallb-operator-fbc
LABEL com.redhat.art.nvr=ose-metallb-operator-fbc-4.20.0-20261121215738
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ose-metallb-operator-bundle@sha256:a83d1ebcf20abc37bd9eea8ee47053fd0de8ba3600370222afd3f6fe3b85a32d
