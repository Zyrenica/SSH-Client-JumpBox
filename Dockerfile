FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive

# Update packages and install sshd.
RUN apt-get -q update
RUN apt-get install -y --no-install-recommends openssh-server gnupg2
RUN mkdir /var/run/sshd

# Clean up after apt to slim down the image.
RUN apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

# Only use IPV4
RUN echo "AddressFamily inet" >> /etc/ssh/ssh_config
# Only keys can be used to authenticate.
RUN echo "PasswordAuthentication no" >> /etc/ssh/ssh_config
# Only use Identity File
RUN echo "IdentitiesOnly yes" >> /etc/ssh/ssh_config
# Set IdentityFile
RUN echo "IdentityFile ~/.ssh/ssh_key" >> /etc/ssh/ssh_config
# Allow listen ports externally isntead of only on localhost.
RUN echo "GatewayPorts yes" >> /etc/ssh/ssh_config
# Set Logging Level
RUN echo "LogLevel DEBUG1" >> /etc/ssh/ssh_config
# Add HostKey for connection
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

# Copy in external files.
COPY entrypoint.sh /entrypoint.sh
COPY keyfile.gpg /keyfile.gpg
RUN chmod 755 /entrypoint.sh

# Create a user entry for the jump user, but without a home
# directory or the ability to get an interactive shell.  This user will only be
# able to create tunnels.
RUN adduser --shell /bin/nologin jumpuser
RUN mkdir /home/jumpuser/.ssh
RUN chown jumpuser /home/jumpuser/.ssh
RUN chmod 700 /home/jumpuser/.ssh

# Switch to user
USER jumpuser

ENTRYPOINT ["/entrypoint.sh"]