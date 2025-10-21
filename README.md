# Face CCTV - Utility Scripts

Public repository for Face CCTV utility scripts and client deployment tools.

## 🛠️ Available Scripts

### fix.sh (Recommended)

**Purpose:** Fix Face CCTV systemd service file for Spy Pen hotspot support

**Issue:** Older installations have `NoNewPrivileges=true` which blocks WiFi hotspot management via `sudo nmcli`.

**Solution:** This script automatically:
- ✅ Removes the NoNewPrivileges restriction
- ✅ Works non-interactively when piped (no prompts)
- ✅ Creates timestamped backup of service file
- ✅ Validates the fix was applied correctly
- ✅ Restarts the service automatically
- ✅ Shows service status after fix

**Usage:**

```bash
# One-liner (easiest - works non-interactively):
curl -fsSL https://raw.githubusercontent.com/dianyulius/face-cctv-utils/main/fix.sh | sudo bash

# Or download first, then execute:
curl -O https://raw.githubusercontent.com/dianyulius/face-cctv-utils/main/fix.sh
sudo bash fix.sh
```

**Safe to run:**
- ✅ Idempotent (can run multiple times safely)
- ✅ Auto-detects piped execution (no prompts needed)
- ✅ Creates backup before making changes
- ✅ Validates fix was applied
- ✅ Restores backup if validation fails
- ✅ Skips if already fixed

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

### fix_service.sh (Legacy)

Same functionality as `fix.sh` but older version. Use `fix.sh` for latest updates.

---

## 📦 For Face CCTV v1.1.0+

**Note:** Face CCTV v1.1.0+ with Spy Pen hotspot support requires this service file fix.

**Auto-update:** All devices will receive v1.1.2 automatically. After auto-update, run this script once to fix the service file:

```bash
curl -fsSL https://raw.githubusercontent.com/dianyulius/face-cctv-utils/main/fix.sh | sudo bash
```

---

## 🔒 Security

This is a **public repository** for easy client access. The scripts only modify Face CCTV service files and do not contain sensitive information.

Main Face CCTV repository (private): [dianyulius/face_cctv](https://github.com/dianyulius/face_cctv)

---

## 📞 Support

For issues with Face CCTV or these utilities, contact your administrator.

**Version:** 1.1.0  
**Last Updated:** October 21, 2025  
**Compatible with:** Face CCTV v1.0.9+
