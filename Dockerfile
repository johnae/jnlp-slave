FROM jenkins/jnlp-slave:3.10-1
USER root

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

RUN apt-get update && apt-get install -y --no-install-recommends \
		sudo \
    && rm -rf /var/lib/apt/lists/* \
    && usermod -aG sudo jenkins \
    && sed -i"" 's|%sudo.*|%sudo ALL=(ALL:ALL) NOPASSWD: ALL|g' /etc/sudoers

USER jenkins
ENV USER jenkins
RUN curl https://nixos.org/nix/install | sh \
    && . /home/jenkins/.nix-profile/etc/profile.d/nix.sh \
    && echo ". /home/jenkins/.nix-profile/etc/profile.d/nix.sh" > /home/jenkins/.profile \
    && nix-env -iA nixpkgs.git

ENTRYPOINT ["/tini", "--"]
CMD ["jenkins-slave"]