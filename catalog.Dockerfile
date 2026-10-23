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
ENV __doozer_key=ingress-node-firewall-operator
ENV __doozer_version=5.1.0
ENV __doozer_release=20261023012205
ENV __doozer_bundle_nvrs=ingress-node-firewall-operator-bundle-container-v5.1.0.202610221628.p2.g3d7f0cb.assembly.stream.el9-1
LABEL io.openshift.build.source-location=https://github.com/openshift/ingress-node-firewall
LABEL io.openshift.build.commit.id=3d7f0cb4e6d1ab065ca3a99ab0c3dd0e4946e564
LABEL com.redhat.art.name=ingress-node-firewall-operator-fbc
LABEL com.redhat.art.nvr=ingress-node-firewall-operator-fbc-5.1.0-20261023012205
LABEL com.redhat.art.bundle.pullspec=registry.redhat.io/openshift5/ingress-node-firewall-operator-bundle@sha256:044450ca3ac100b1e6ecbec41eb0eba5cdfc500fbaf567c53231c8b9cbed195e
