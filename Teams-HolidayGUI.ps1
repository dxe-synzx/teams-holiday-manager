Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Formular erstellen
$form = New-Object System.Windows.Forms.Form
$form.Text = "Teams Holiday Manager - Setup"
$form.Size = New-Object System.Drawing.Size(450, 420)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# Label: Bundesland
$lblState = New-Object System.Windows.Forms.Label
$lblState.Location = New-Object System.Drawing.Point(20, 20)
$lblState.Size = New-Object System.Drawing.Size(390, 20)
$lblState.Text = "Bundesland waehlen:"
$form.Controls.Add($lblState)

# Dropdown: Bundesländer
$cmbState = New-Object System.Windows.Forms.ComboBox
$cmbState.Location = New-Object System.Drawing.Point(20, 45)
$cmbState.Size = New-Object System.Drawing.Size(390, 25)
$cmbState.DropDownStyle = "DropDownList"
# Aktuell liegt der Fokus auf Sachsen, lässt sich aber leicht erweitern
$cmbState.Items.Add("Sachsen (SN) - Inkl. Bufs- und Bettag") | Out-Null
$cmbState.SelectedIndex = 0
$form.Controls.Add($cmbState)

# Checkbox: Weihnachten inkl. Heiligabend
$chkXmas = New-Object System.Windows.Forms.CheckBox
$chkXmas.Location = New-Object System.Drawing.Point(20, 90)
$chkXmas.Size = New-Object System.Drawing.Size(390, 25)
$chkXmas.Text = "Weihnachten inklusive Heiligabend (24.12. - 27.12.)"
$form.Controls.Add($chkXmas)

# GroupBox: Zeitraum
$grpYears = New-Object System.Windows.Forms.GroupBox
$grpYears.Location = New-Object System.Drawing.Point(20, 130)
$grpYears.Size = New-Object System.Drawing.Size(390, 90)
$grpYears.Text = " Zeitraum (Jahre) "
$form.Controls.Add($grpYears)

$rb5Years = New-Object System.Windows.Forms.RadioButton
$rb5Years.Location = New-Object System.Drawing.Point(15, 25)
$rb5Years.Size = New-Object System.Drawing.Size(350, 20)
$rb5Years.Text = "2026 bis 2030 (Standard)"
$rb5Years.Checked = $true
$grpYears.Controls.Add($rb5Years)

# Status-Box / Log
$txtLog = New-Object System.Windows.Forms.TextBox
$txtLog.Location = New-Object System.Drawing.Point(20, 235)
$txtLog.Size = New-Object System.Drawing.Size(390, 75)
$txtLog.Multiline = $true
$txtLog.ScrollBars = "Vertical"
$txtLog.ReadOnly = $true
$txtLog.Text = "Bereit. Bitte waehle deine Optionen und klicke auf 'Feiertage in Teams anlegen'."
$form.Controls.Add($txtLog)

# Button: Starten
$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Location = New-Object System.Drawing.Point(20, 325)
$btnRun.Size = New-Object System.Drawing.Size(390, 35)
$btnRun.Text = "Feiertage in Teams anlegen"
$btnRun.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 212)
$btnRun.ForeColor = [System.Drawing.Color]::White
$btnRun.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($btnRun)

# Klick-Logik des Buttons
$btnRun.Add_Click({
    $btnRun.Enabled = $false
    $txtLog.Text = "Verbinde mit Microsoft Teams..."
    $form.Refresh()

    try {
        if (-not (Get-Module -ListAvailable -Name MicrosoftTeams)) {
            $txtLog.Text = "Installiere MicrosoftTeams-Modul..."
            $form.Refresh()
            Install-Module MicrosoftTeams -Scope CurrentUser -Force -AllowClobber
        }
        Import-Module MicrosoftTeams -ErrorAction Stop

        $txtLog.Text = "Authentifiziere im Teams-Tenant..."
        $form.Refresh()
        $Session = Connect-MicrosoftTeams -ErrorAction Stop
        
        $txtLog.Text = "Verbunden! Lese bestehende Feiertage..."
        $form.Refresh()
        $ExistingSchedules = @(Get-CsOnlineSchedule -ErrorAction Stop)
        $ExistingNames = @($ExistingSchedules | ForEach-Object { $_.Name })

        $Prefix = "SN - Feiertag"
        $BussUndBettag = "Bu$([char]0x00DF)- und Bettag"
        $XmasStartDay = if ($chkXmas.Checked) { "24" } else { "25" }

        # Sachsen Feiertagsdefinitionen (2026-2030)
        $HolidayDefinitions = [ordered]@{
            "Neujahr" = @(
                @{ Start = "2026-01-01"; End = "2026-01-02" },
                @{ Start = "2027-01-01"; End = "2027-01-02" },
                @{ Start = "2028-01-01"; End = "2028-01-02" },
                @{ Start = "2029-01-01"; End = "2029-01-02" },
                @{ Start = "2030-01-01"; End = "2030-01-02" }
            )
            "Ostern" = @(
                @{ Start = "2026-04-03"; End = "2026-04-07" },
                @{ Start = "2027-03-26"; End = "2027-03-30" },
                @{ Start = "2028-04-14"; End = "2028-04-18" },
                @{ Start = "2029-03-30"; End = "2029-04-03" },
                @{ Start = "2030-04-19"; End = "2030-04-23" }
            )
            "Tag der Arbeit" = @(
                @{ Start = "2026-05-01"; End = "2026-05-02" },
                @{ Start = "2027-05-01"; End = "2027-05-02" },
                @{ Start = "2028-05-01"; End = "2028-05-02" },
                @{ Start = "2029-05-01"; End = "2029-05-02" },
                @{ Start = "2030-05-01"; End = "2030-05-02" }
            )
            "Christi Himmelfahrt" = @(
                @{ Start = "2026-05-14"; End = "2026-05-15" },
                @{ Start = "2027-05-06"; End = "2027-05-07" },
                @{ Start = "2028-05-25"; End = "2028-05-26" },
                @{ Start = "2029-05-10"; End = "2029-05-11" },
                @{ Start = "2030-05-30"; End = "2030-05-31" }
            )
            "Pfingstmontag" = @(
                @{ Start = "2026-05-25"; End = "2026-05-26" },
                @{ Start = "2027-05-17"; End = "2027-05-18" },
                @{ Start = "2028-06-05"; End = "2028-06-06" },
                @{ Start = "2029-05-21"; End = "2029-05-22" },
                @{ Start = "2030-06-10"; End = "2030-06-11" }
            )
            "Tag der Deutschen Einheit" = @(
                @{ Start = "2026-10-03"; End = "2026-10-04" },
                @{ Start = "2027-10-03"; End = "2027-10-04" },
                @{ Start = "2028-10-03"; End = "2028-10-04" },
                @{ Start = "2029-10-03"; End = "2029-10-04" },
                @{ Start = "2030-10-03"; End = "2030-10-04" }
            )
            "Reformationstag" = @(
                @{ Start = "2026-10-31"; End = "2026-11-01" },
                @{ Start = "2027-10-31"; End = "2027-11-01" },
                @{ Start = "2028-10-31"; End = "2028-11-01" },
                @{ Start = "2029-10-31"; End = "2029-11-01" },
                @{ Start = "2030-10-31"; End = "2030-11-01" }
            )
            $BussUndBettag = @(
                @{ Start = "2026-11-18"; End = "2026-11-19" },
                @{ Start = "2027-11-17"; End = "2027-11-18" },
                @{ Start = "2028-11-15"; End = "2028-11-16" },
                @{ Start = "2029-11-21"; End = "2029-11-22" },
                @{ Start = "2030-11-20"; End = "2030-11-21" }
            )
            "Weihnachten" = @(
                @{ Start = "2026-12-$XmasStartDay"; End = "2026-12-27" },
                @{ Start = "2027-12-$XmasStartDay"; End = "2027-12-27" },
                @{ Start = "2028-12-$XmasStartDay"; End = "2028-12-27" },
                @{ Start = "2029-12-$XmasStartDay"; End = "2029-12-27" },
                @{ Start = "2030-12-$XmasStartDay"; End = "2030-12-27" }
            )
        }

        $counter = 0
        foreach ($HolidayName in $HolidayDefinitions.Keys) {
            $FullScheduleName = "$Prefix - $HolidayName"
            if ($ExistingNames -contains $FullScheduleName) { continue }

            $txtLog.Text = "Erstelle: $HolidayName..."
            $form.Refresh()

            $Ranges = @()
            foreach ($Period in $HolidayDefinitions[$HolidayName]) {
                $StartDate = [datetime]::ParseExact($Period.Start, "yyyy-MM-dd", [Globalization.CultureInfo]::InvariantCulture)
                $EndDate   = [datetime]::ParseExact($Period.End,   "yyyy-MM-dd", [Globalization.CultureInfo]::InvariantCulture)
                
                $Ranges += New-CsOnlineDateTimeRange -Start ($StartDate.ToString("d/M/yyyy")) -End ($EndDate.ToString("d/M/yyyy"))
            }

            New-CsOnlineSchedule -Name $FullScheduleName -FixedSchedule -DateTimeRanges $Ranges | Out-Null
            $counter++
        }

        $txtLog.Text = "Fertig! $counter neue Feiertagsblöcke erstellt."
        [System.Windows.Forms.MessageBox]::Show("Feiertage wurden erfolgreich in Teams eingepflegt!", "Erfolg", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("Fehler: $_", "Fehler", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        $txtLog.Text = "Fehler aufgetreten."
    }
    $btnRun.Enabled = $true
})

[void]$form.ShowDialog()