# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.18 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.18
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
ENV __doozer_group=mce-2.11
ENV __doozer_key=backplane-operator
ENV __doozer_version=2.11.5
ENV __doozer_release=20261106195944.ocp4.18
ENV __doozer_bundle_nvrs=mce-backplane-operator-metadata-container-2.11.5.202611061812.p2.gef460a9.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/stolostron/backplane-operator
LABEL io.openshift.build.commit.id=ef460a99d3b8869041dc12e44879b28d61d9b2eb
LABEL com.redhat.art.name=backplane-operator-fbc
LABEL com.redhat.art.nvr=backplane-operator-fbc-2.11.5-20261106195944.ocp4.18
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/multicluster-engine/mce-operator-bundle@sha256:4fb818529c472cb79b8c2ce09630979171ff3c3a458bef88ccdbd7776981d3dd
