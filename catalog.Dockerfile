# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.19 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.19
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
ENV __doozer_group=mce-2.9
ENV __doozer_key=backplane-operator
ENV __doozer_version=2.9.9
ENV __doozer_release=20261027192539.ocp4.19
ENV __doozer_bundle_nvrs=mce-backplane-operator-metadata-container-2.9.9.202610271734.p2.geaf33ea.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/stolostron/backplane-operator
LABEL io.openshift.build.commit.id=eaf33ea994f523b23fa7455e36c44074dcbbd8b3
LABEL com.redhat.art.name=backplane-operator-fbc
LABEL com.redhat.art.nvr=backplane-operator-fbc-2.9.9-20261027192539.ocp4.19
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/multicluster-engine/mce-operator-bundle@sha256:1675e5f6c0d2225c88d4a79760829efd10de0eabe5a26ca91e67aed1aecf3962
