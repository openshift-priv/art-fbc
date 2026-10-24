# The builder image is expected to contain
# /bin/opm (with serve subcommand)
FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.20 as builder

# Copy FBC root into image at /configs and pre-populate serve cache
ADD catalog /configs
RUN ["/bin/opm", "serve", "/configs", "--cache-dir=/tmp/cache", "--cache-only"]

FROM registry.redhat.io/openshift4/ose-operator-registry-rhel9:v4.20
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
ENV __doozer_group=openshift-4.20
ENV __doozer_key=ingress-node-firewall-operator
ENV __doozer_version=4.20.0
ENV __doozer_release=20261024170216
ENV __doozer_bundle_nvrs=ingress-node-firewall-operator-bundle-container-v4.20.0.202610241310.p2.ga44b093.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/ingress-node-firewall
LABEL io.openshift.build.commit.id=a44b09332909fc38eb06b4ed67d39fdcc4c9bc5b
LABEL com.redhat.art.name=ingress-node-firewall-operator-fbc
LABEL com.redhat.art.nvr=ingress-node-firewall-operator-fbc-4.20.0-20261024170216
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift4/ingress-node-firewall-operator-bundle@sha256:a667b8f741a230eab7fee92ae8791f6538dcd21391485fb4b9263d1474038776
