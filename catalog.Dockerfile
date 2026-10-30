# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.21 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.21
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
ENV __doozer_group=acm-2.16
ENV __doozer_key=multiclusterhub-operator
ENV __doozer_version=2.16.4
ENV __doozer_release=20261030212607.ocp4.21
ENV __doozer_bundle_nvrs=acm-multiclusterhub-operator-metadata-container-2.16.4.202610302011.p2.gfd4ea4c.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/stolostron/multiclusterhub-operator
LABEL io.openshift.build.commit.id=fd4ea4cd646ca815fea6839a45cc0db30d357419
LABEL com.redhat.art.name=multiclusterhub-operator-fbc
LABEL com.redhat.art.nvr=multiclusterhub-operator-fbc-2.16.4-20261030212607.ocp4.21
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/rhacm2/acm-operator-bundle@sha256:78ea2d62a57456c58dedfbaf13c90fec394e43f5d627123992edd2177f28e0bc
