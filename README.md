# Teams Holiday Manager (GUI)

A lightweight PowerShell graphical user interface (GUI) tool designed for Microsoft Teams Administrators to automatically provision regional holiday schedules (for Auto Attendants) without clicking through the Teams Admin Center 55+ times.

## Features
- **Graphical User Interface (GUI):** Easy selection of regions and date ranges.
- **Grouped Holiday Blocks:** Combines multi-day holidays (like Easter or Christmas) into single calendar entries to keep the Teams Admin Center clean and easy to manage for Auto Attendant greetings.
- **Smart Duplicate Detection:** Automatically checks existing schedules in your tenant to prevent duplicates.
- **Multi-Year Support:** Generates schedules ranging from 2026 up to 2030.

## Prerequisites
- Windows PowerShell 5.1 or PowerShell 7+
- Microsoft Teams PowerShell Module (will be installed automatically if missing)
- Global Admin or Teams Administrator permissions in your Microsoft 365 Tenant.

## Usage
1. Download or clone this repository.
2. Right-click `Teams-HolidayGUI.ps1` and choose **Run with PowerShell** (or run it from your favorite terminal).
3. Authenticate with your Microsoft 365 administrator account when prompted.
4. Click **Feiertage in Teams anlegen** to provision the schedules.

## License
Distributed under the MIT License. See `LICENSE` for more information.