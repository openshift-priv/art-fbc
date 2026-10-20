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
ENV __doozer_group=openshift-5.0
ENV __doozer_key=ose-support-log-gather-operator
ENV __doozer_version=5.0.0
ENV __doozer_release=20261020085303
ENV __doozer_bundle_nvrs=ose-support-log-gather-operator-bundle-container-v5.0.0.202610200739.p2.g0124171.assembly.test.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/must-gather-operator
LABEL io.openshift.build.commit.id=0124171e873aee250bd59f1598f492892b5c5f37
LABEL com.redhat.art.name=ose-support-log-gather-operator-fbc
LABEL com.redhat.art.nvr=ose-support-log-gather-operator-fbc-5.0.0-20261020085303
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift5/ose-support-log-gather-operator-bundle@sha256:94b8f712831e2ee20341ce3d85847a34f9aa16536e9bb00170cd1db520de453e
