# Face CCTV - Utility Scripts

Public repository for Face CCTV utility scripts and client deployment tools.

## 🛠️ Available Scripts

### fix_service.sh

**Purpose:** Fix Face CCTV systemd service file for Spy Pen hotspot support

**Issue:** Older installations have `NoNewPrivileges=true` which blocks WiFi hotspot management via `sudo nmcli`.

**Solution:** This script automatically:
- ✅ Removes the NoNewPrivileges restriction
- ✅ Creates timestamped backup of service file
- ✅ Validates the fix was applied correctly
- ✅ Restarts the service automatically
- ✅ Shows service status after fix

**Usage:**

```bash
# One-liner (download and execute):
curl -fsSL https://raw.githubusercontent.com/dianyulius/face-cctv-utils/main/fix_service.sh | sudo bash

# Or download first, then execute:
curl -O https://raw.githubusercontent.com/dianyulius/face-cctv-utils/main/fix_service.sh
sudo bash fix_service.sh
```

**Safe to run:**
- ✅ Idempotent (can run multiple times safely)
- ✅ Creates backup before making changes
- ✅ Validates fix was applied
- ✅ Restores backup if validation fails
- ✅ Skip if already fixed

**Requirements:**
- Root/sudo access
- Face CCTV installed at `/etc/systemd/system/face_cctv.service`

**What it changes:**

```diff
# Before:
- NoNewPrivileges=true

# After:
+ # NoNewPrivileges disabled to allow nmcli/sudo for Spy Pen hotspot management
```

---

## 📦 For Face CCTV v1.1.0+

**Note:** Face CCTV v1.1.0 and later automatically fix this during installation. This script is only needed for devices installed with v1.0.9 or earlier.

**Auto-update:** All devices will receive v1.1.0 automatically within 10 minutes. After auto-update, run this script to fix the service file if needed.

---

## 🔒 Security

This is a **public repository** for easy client access. The scripts only modify Face CCTV service files and do not contain sensitive information.

Main Face CCTV repository (private): [dianyulius/face_cctv](https://github.com/dianyulius/face_cctv)

---

## 📞 Support

For issues with Face CCTV or these utilities, contact your administrator.

**Version:** 1.0.0  
**Last Updated:** October 21, 2025  
**Compatible with:** Face CCTV v1.0.9+
