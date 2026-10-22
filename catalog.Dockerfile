# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift5/ose-operator-registry-rhel9:v5.0 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift5/ose-operator-registry-rhel9:v5.0
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
ENV __doozer_group=kueue-1.4
ENV __doozer_key=kueue-operator
ENV __doozer_version=1.4.4
ENV __doozer_release=20261022224600.ocp5.0
ENV __doozer_bundle_nvrs=kueue-operator-bundle-1.4.4.202610222154.p2.gf994258.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/kueue-operator
LABEL io.openshift.build.commit.id=f994258f8f00a2dfc1309319e03f7f27348ec113
LABEL com.redhat.art.name=kueue-operator-fbc
LABEL com.redhat.art.nvr=kueue-operator-fbc-1.4.4-20261022224600.ocp5.0
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/kueue/kueue-operator-bundle@sha256:fa9bdde12d162bd3045e7792c2a681bc4efab42ee83cae9412909f542e8e3d8c
