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
ENV __doozer_key=ptp-operator
ENV __doozer_version=5.0.0
ENV __doozer_release=20261110224233
ENV __doozer_bundle_nvrs=ose-ptp-operator-metadata-container-v5.0.0.202611102040.p2.gcbe73c6.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/ptp-operator
LABEL io.openshift.build.commit.id=cbe73c6129a967c6021639ad9ef9da2f59adbb14
LABEL com.redhat.art.name=ptp-operator-fbc
LABEL com.redhat.art.nvr=ptp-operator-fbc-5.0.0-20261110224233
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift5/ose-ptp-operator-bundle@sha256:bc80f20aeecfde5f3bfaafd4203549368ef5f35e91ebbf8a38bc84cf0599bb69
