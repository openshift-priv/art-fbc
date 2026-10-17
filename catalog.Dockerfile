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
ENV __doozer_key=ose-support-log-gather-operator
ENV __doozer_version=5.1.0
ENV __doozer_release=20261017090706
ENV __doozer_bundle_nvrs=ose-support-log-gather-operator-bundle-container-v5.1.0.202610170343.p2.ge87ed6a.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/must-gather-operator
LABEL io.openshift.build.commit.id=e87ed6a98c97a29266739d38399427ccef0bd0a6
LABEL com.redhat.art.name=ose-support-log-gather-operator-fbc
LABEL com.redhat.art.nvr=ose-support-log-gather-operator-fbc-5.1.0-20261017090706
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift5/ose-support-log-gather-operator-bundle@sha256:876869002fc18b8ab9c952245678fa139d24b68a18f5dc65b210f09d5c05767a
