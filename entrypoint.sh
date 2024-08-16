#!/bin/bash

echo "Starting container"
if ! [ -f /home/jumpuser/.ssh/config ]; then
    echo "Container failed to start, config missing"
    exit 1
elif [ -z "$HOSTS" ]; then
    echo "Container failed to start, please pass -e HOST=tunnelname"
    exit 1
fi

# Decrypt key
echo "Decrypting Keyfile"
gpg --passphrase="${PASSPHRASE:-None}" -d --batch /keyfile.gpg > ~/.ssh/ssh_key

#chown jumpuser ~/.ssh/ssh_key
chmod 600 ~/.ssh/ssh_key

# Start the SSH tunnel.
echo "Connecting tunnel $HOSTS"
ssh -N $HOSTS