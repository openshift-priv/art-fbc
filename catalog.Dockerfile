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
ENV __doozer_key=cluster-nfd-operator
ENV __doozer_version=5.1.0
ENV __doozer_release=20261121091457
ENV __doozer_bundle_nvrs=cluster-nfd-operator-metadata-container-v5.1.0.202611202059.p2.ga8fa2b3.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/cluster-nfd-operator
LABEL io.openshift.build.commit.id=a8fa2b365d26525deb10098762d3c2ec6d234957
LABEL com.redhat.art.name=cluster-nfd-operator-fbc
LABEL com.redhat.art.nvr=cluster-nfd-operator-fbc-5.1.0-20261121091457
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift5/ose-cluster-nfd-operator-bundle@sha256:4b84b502985c3443ed61b721248a51fc102e142eff2ec4fc2ef39be1088e88b8
