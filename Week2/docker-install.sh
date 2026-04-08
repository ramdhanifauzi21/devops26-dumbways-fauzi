#!/bin/bash

# ===============================
# DOCKER INSTALL 
# ===============================

# Warna
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${CYAN}==> $1${NC}"
}

print_success() {
    echo -e "${GREEN}[SUCCESS] $1${NC}"
}

print_error() {
    echo -e "${RED}[ERROR] $1${NC}"
    exit 1
}

clear

# ==============================
# VALIDATION
# ==============================

print_step "Checking root access..."
if [ "$EUID" -ne 0 ]; then
    print_error "Jalankan script dengan sudo/root"
fi

print_success "Root OK"

# ==============================
# REMOVE CONFLICTING PACKAGES
# ==============================

echo "===================================="
echo "===================================="
print_step "Removing conflicting packages..."

apt remove -y $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1) \
|| print_success "Tidak ada package konflik atau sudah bersih"

# ==============================
# Add Docker's GPG key
# ==============================

echo "--------------------------------------"
echo "--------------------------------------"
print_step "Add docker GPG Key..."
apt update
apt install ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg \
|| print_error "ERROR"

print_success "GPG KEY ADD SUCCESS"

# ==============================
# ADD REPOSITORY
# ==============================

echo "--------------------------------------"
echo "--------------------------------------"

print_step "Add the repository..."

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
|| print_error "ERROR"

apt update

apt-cache policy docker-ce

print_success "Repository Added"

# ==============================
# INSTALL DOCKER PACKAGES
# ==============================

echo "--------------------------------------"
echo "--------------------------------------"
print_step "Install Packages Docker..."

apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
|| print_error "Docker Install Failed"

print_success "Docker Installed"

# ==============================
# DOCKER SERVICE STARTS
# ==============================

echo "--------------------------------------"
echo "--------------------------------------"
print_step "Start Docker Service...${CYAN}"
systemctl status docker
systemctl start docker

print_success "Docker running"

# ==============================
# VERIFY DOCKER
# ==============================

echo "--------------------------------------"
echo "--------------------------------------"
print_step "Verifying installation..."

docker --version || print_error "Docker Gagal Di Install"

print_success "Docker installation completed successfully."

echo ""
echo "======================================"
echo " INTALLATION COMPLETE "
echo "======================================"
