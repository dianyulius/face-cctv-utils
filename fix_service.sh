#!/bin/bash
#######################################
# Face CCTV - Service File Updater
# Fixes NoNewPrivileges restriction for Spy Pen hotspot support
#######################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SERVICE_FILE="/etc/systemd/system/face_cctv.service"

# Check if running non-interactively (piped input)
if [ ! -t 0 ]; then
    AUTO_YES=true
else
    AUTO_YES=false
fi

echo ""
echo "============================================================"
echo "      Face CCTV - Service File Update"
echo "============================================================"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}❌ This script must be run as root${NC}"
    echo ""
    echo "Please run: sudo bash $0"
    echo ""
    exit 1
fi

# Check if service file exists
if [ ! -f "$SERVICE_FILE" ]; then
    echo -e "${RED}❌ Service file not found: $SERVICE_FILE${NC}"
    echo ""
    echo "Face CCTV doesn't appear to be installed as a service."
    echo ""
    exit 1
fi

# Check if update is needed
if grep -q "NoNewPrivileges=true" "$SERVICE_FILE"; then
    echo -e "${YELLOW}📝 Old service file detected${NC}"
    echo ""
    echo "Current configuration blocks Spy Pen hotspot management."
    echo "This update will enable hotspot support for Spy Pen devices."
    echo ""
    
    # Show what will change
    echo -e "${BLUE}Changes:${NC}"
    echo "  - Remove: NoNewPrivileges=true"
    echo "  - Add comment: # NoNewPrivileges disabled to allow nmcli/sudo for Spy Pen hotspot management"
    echo ""
    
    # Confirm (skip if non-interactive)
    if [ "$AUTO_YES" = false ]; then
        read -p "Update service file? (y/n): " -n 1 -r
        echo ""
        
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Update cancelled."
            exit 0
        fi
    else
        echo -e "${GREEN}Running in non-interactive mode - auto-applying fix${NC}"
    fi
    
    echo ""
    echo -e "${BLUE}🔧 Updating service file...${NC}"
    
    # Backup original
    cp "$SERVICE_FILE" "${SERVICE_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    echo "  ✓ Backup created"
    
    # Update file
    sed -i 's/NoNewPrivileges=true/# NoNewPrivileges disabled to allow nmcli\/sudo for Spy Pen hotspot management/' "$SERVICE_FILE"
    echo "  ✓ Service file updated"
    
    # Validate the fix was applied
    if grep -q "NoNewPrivileges=true" "$SERVICE_FILE"; then
        echo ""
        echo -e "${RED}❌ Update failed - NoNewPrivileges=true still present${NC}"
        echo ""
        echo "Restoring backup..."
        mv "${SERVICE_FILE}.backup."* "$SERVICE_FILE" 2>/dev/null || true
        exit 1
    fi
    
    if ! grep -q "# NoNewPrivileges disabled" "$SERVICE_FILE"; then
        echo ""
        echo -e "${RED}❌ Update validation failed - Fix not applied correctly${NC}"
        echo ""
        echo "Restoring backup..."
        mv "${SERVICE_FILE}.backup."* "$SERVICE_FILE" 2>/dev/null || true
        exit 1
    fi
    
    echo "  ✓ Fix validated"
    
    # Reload systemd
    systemctl daemon-reload
    echo "  ✓ Systemd reloaded"
    
    echo ""
    echo -e "${GREEN}✅ Service file updated successfully!${NC}"
    echo ""
    
    # Show what changed
    echo -e "${BLUE}Verification:${NC}"
    echo "  Before: NoNewPrivileges=true"
    echo "  After:  # NoNewPrivileges disabled to allow nmcli/sudo for Spy Pen hotspot management"
    echo ""
    
    # Auto-restart service if running
    if systemctl is-active --quiet face_cctv; then
        echo "Service is currently running. Restarting..."
        echo ""
        echo -e "${BLUE}🔄 Restarting service...${NC}"
        systemctl restart face_cctv
        sleep 2
        
        if systemctl is-active --quiet face_cctv; then
            echo -e "${GREEN}✅ Service restarted successfully${NC}"
            echo ""
            systemctl status face_cctv --no-pager -l | head -15
        else
            echo -e "${RED}❌ Service failed to start${NC}"
            echo ""
            echo "Check logs: sudo journalctl -u face_cctv -n 50"
            exit 1
        fi
    else
        echo -e "${YELLOW}ℹ️  Service is not running${NC}"
        echo "Changes will take effect when service is started."
        echo ""
        echo "Start service: sudo systemctl start face_cctv"
    fi
    
    echo ""
    echo "============================================================"
    echo "      ✅ Update Complete!"
    echo "============================================================"
    echo ""
    
else
    echo -e "${GREEN}✅ Service file is already up to date!${NC}"
    echo ""
    echo "No changes needed. Spy Pen hotspot support is enabled."
    echo ""
    
    # Show current service status
    if systemctl is-active --quiet face_cctv; then
        echo "Service status:"
        systemctl status face_cctv --no-pager -l | head -12
    fi
    echo ""
fi
