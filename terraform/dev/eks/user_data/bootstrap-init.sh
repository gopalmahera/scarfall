#!/bin/bash
echo "Starting node initialization..." | tee -a /var/log/user-data.log

# Install crictl if not found
if ! command -v crictl &> /dev/null; then
    echo "crictl not found. Installing..."
    CRICTL_VERSION="v1.27.0"
    ARCH="amd64"
    sudo curl -L -o crictl.tar.gz "https://github.com/kubernetes-sigs/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-linux-${ARCH}.tar.gz"
    sudo tar -xvzf crictl.tar.gz -C /usr/local/bin
    sudo chmod +x /usr/local/bin/crictl
    rm -f crictl.tar.gz
fi

# Check running containerd-shim-runc-v2 processes
echo "Listing running containerd-shim-runc-v2 processes..."
ps aux | grep containerd-shim-runc-v2 || echo "No running processes found."

# Configure crictl to Use the Correct Endpoint
sudo tee /etc/crictl.yaml <<EOF
runtime-endpoint: "unix:///run/containerd/containerd.sock"
EOF

# Create script to pull images periodically
cat << 'EOF' | sudo tee /usr/local/bin/pull-images.sh
#!/bin/bash

LOG_FILE="/var/log/pull-images.log"
SSM_IMAGE_PATH="/dev/instance/gameplay/image"
SSM_INTERVAL_PATH="/dev/instance/gameplay/interval"

log() {
    echo "$(date) - $1" | tee -a "$LOG_FILE"
}

log "Starting image pull process..."

# Fetch images list from AWS SSM Parameter Store
IMAGES_JSON=$(aws ssm get-parameter --name "$SSM_IMAGE_PATH" --query "Parameter.Value" --output text 2>/dev/null)

if [ -z "$IMAGES_JSON" ]; then
    log "Error: Unable to fetch images list from SSM. Exiting."
    exit 1
fi

# Convert JSON array to bash array
IMAGES=($(echo "$IMAGES_JSON" | jq -r '.[]'))

# Fetch interval from AWS SSM Parameter Store
INTERVAL=$(aws ssm get-parameter --name "$SSM_INTERVAL_PATH" --query "Parameter.Value" --output text 2>/dev/null)

if [ -z "$INTERVAL" ]; then
    log "Warning: Unable to fetch interval from SSM. Defaulting to 60 seconds."
    INTERVAL=60
fi

AWS_REGION="ap-south-1"
ECR_USER="AWS"
ECR_PASSWORD=$(aws ecr get-login-password --region $AWS_REGION)

# Pull each image
for IMAGE in "${IMAGES[@]}"; do
    log "Pulling $IMAGE..."
    if [[ "$IMAGE" =~ ^[0-9]+\.dkr\.ecr\.[a-z0-9-]+\.amazonaws\.com/.*$ ]]; then
        CMD="crictl --runtime-endpoint unix:///run/containerd/containerd.sock pull --creds \"$ECR_USER:$ECR_PASSWORD\" \"$IMAGE\""
    else
        CMD="crictl --runtime-endpoint unix:///run/containerd/containerd.sock pull \"$IMAGE\""
    fi
    log "Executing: $CMD"
    eval $CMD
done

log "Image pull process completed. Sleeping for $INTERVAL seconds."
sleep "$INTERVAL"
EOF

# Make script executable
chmod +x /usr/local/bin/pull-images.sh

# Create systemd service to run pull-images.sh every 30 min
cat << 'EOF' | sudo tee /etc/systemd/system/pull-images.service
[Unit]
Description=Pull container images every 30 minutes
After=network.target containerd.service

[Service]
ExecStart=/usr/local/bin/pull-images.sh
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable pull-images.service
sudo systemctl start pull-images.service

echo "Node initialization complete." | tee -a /var/log/user-data.log