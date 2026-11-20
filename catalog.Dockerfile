# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry:v4.12 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry:v4.12
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
ENV __doozer_group=acm-2.11
ENV __doozer_key=multiclusterhub-operator
ENV __doozer_version=2.11.15
ENV __doozer_release=20261120074624.ocp4.12
ENV __doozer_bundle_nvrs=acm-multiclusterhub-operator-metadata-container-2.11.15.202611200418.p2.g0f9d0b6.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/stolostron/multiclusterhub-operator
LABEL io.openshift.build.commit.id=0f9d0b627737764bef67fe72e8c434a2f2fab19a
LABEL com.redhat.art.name=multiclusterhub-operator-fbc
LABEL com.redhat.art.nvr=multiclusterhub-operator-fbc-2.11.15-20261120074624.ocp4.12
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/rhacm2/acm-operator-bundle@sha256:949d742b04660434c24e2350898dc6d454172e3afc6659c3ceb490f8d4ee45e6
