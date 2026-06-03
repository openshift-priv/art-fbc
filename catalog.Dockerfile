# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.15 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.15
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
ENV __doozer_group=mtc-1.8
ENV __doozer_key=openshift-migration-operator
ENV __doozer_version=1.8.15
ENV __doozer_release=20260603153721.ocp4.15
ENV __doozer_bundle_nvrs=openshift-migration-operator-metadata-container-1.8.15.202606031507.p2.gb768cea.assembly.test.el8-1
LABEL io.openshift.build.source-location=https://github.com/migtools/mig-operator
LABEL io.openshift.build.commit.id=b768cea5541e2c5e553433876c54efb60a672ac4
LABEL com.redhat.art.name=openshift-migration-operator-fbc
LABEL com.redhat.art.nvr=openshift-migration-operator-fbc-1.8.15-20260603153721.ocp4.15
