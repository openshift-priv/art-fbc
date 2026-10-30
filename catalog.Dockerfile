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
ENV __doozer_release=20261030162041.ocp4.21
ENV __doozer_bundle_nvrs=acm-multiclusterhub-operator-metadata-container-2.16.4.202610301521.p2.gb988dd9.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/stolostron/multiclusterhub-operator
LABEL io.openshift.build.commit.id=b988dd9b4cde4c575230109a27c90009d3124980
LABEL com.redhat.art.name=multiclusterhub-operator-fbc
LABEL com.redhat.art.nvr=multiclusterhub-operator-fbc-2.16.4-20261030162041.ocp4.21
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/rhacm2/acm-operator-bundle@sha256:440ffc021bf8450761a752b7110f514fac69b122f76a699a26e3348c8a3975c1
