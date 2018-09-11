FROM jenkins/jnlp-slave:3.10-1
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
		sudo \
    && rm -rf /var/lib/apt/lists/* \
    && usermod -aG sudo jenkins \
    && sed -i"" 's|%sudo.*|%sudo ALL=(ALL:ALL) NOPASSWD: ALL|g' /etc/sudoers
USER jenkins
