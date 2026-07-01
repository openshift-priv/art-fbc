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
ENV __doozer_group=openshift-4.19
ENV __doozer_key=pf-status-relay-operator
ENV __doozer_version=4.19.0
ENV __doozer_release=20260701082004
ENV __doozer_bundle_nvrs=pf-status-relay-operator-bundle-container-v4.19.0.202606301915.p2.g819a7b2.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/pf-status-relay-operator
LABEL io.openshift.build.commit.id=819a7b2ea89a4615accaa4ad1e6ebe2a28e2fb41
LABEL com.redhat.art.name=pf-status-relay-operator-fbc
LABEL com.redhat.art.nvr=pf-status-relay-operator-fbc-4.19.0-20260701082004
