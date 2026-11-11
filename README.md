# Teams Universal & International Holiday Manager (GUI)

A powerful, lightweight PowerShell graphical user interface (GUI) tool designed for Microsoft Teams Administrators to automatically provision regional and international holiday schedules (for Auto Attendants) without manual repetition.

## Features
- **Graphical User Interface (GUI):** Choose your region/state via a clean dropdown menu.
- **Global & Regional Support:** Supports all 16 German federal states (with exact religious/regional holiday laws like Fronleichnam, Buß- und Bettag, Reformationstag), Austria, Switzerland, USA, and the UK.
- **Grouped Holiday Blocks:** Automatically combines multi-day holidays (such as Easter or Christmas) into single calendar blocks to keep the Teams Admin Center organized.
- **Smart Duplicate Detection:** Scans your tenant beforehand to avoid creating duplicate schedules.
- **Multi-Year Coverage:** Pre-configured for a 5-year span (2026–2030).

## Prerequisites
- Windows PowerShell 5.1 or PowerShell 7+
- Microsoft Teams PowerShell Module (automatically installed if missing)
- Global Administrator or Teams Administrator permissions in your Microsoft 365 Tenant.

## Usage
1. Clone or download this repository.
2. Run `Teams-HolidayGUI.ps1` via PowerShell.
3. Authenticate with your administrator credentials.
4. Select your target region/state, check optional settings (like Christmas Eve inclusion), and click **Feiertage in Teams anlegen**.

## Contributing
Contributions, bug reports, and feature requests for additional countries/regions are welcome! Feel free to open an issue or pull request.

## License
Distributed under the MIT License. See `LICENSE` for more information.