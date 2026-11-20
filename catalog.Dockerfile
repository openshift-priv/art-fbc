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
ENV __doozer_group=acm-2.17
ENV __doozer_key=multiclusterhub-operator
ENV __doozer_version=2.17.5
ENV __doozer_release=20261120191736.ocp4.19
ENV __doozer_bundle_nvrs=acm-multiclusterhub-operator-metadata-container-2.17.5.202611201731.p2.g44b1954.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/stolostron/multiclusterhub-operator
LABEL io.openshift.build.commit.id=44b1954c2f5e1a15ed274813bccab49c0f04619d
LABEL com.redhat.art.name=multiclusterhub-operator-fbc
LABEL com.redhat.art.nvr=multiclusterhub-operator-fbc-2.17.5-20261120191736.ocp4.19
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/rhacm2/acm-operator-bundle@sha256:b07b32f59bc6e20e0573c054992eea869a1d55bc8e4b11e2b9d601e873953f5f
