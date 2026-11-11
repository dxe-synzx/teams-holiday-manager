Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Formular erstellen
$form = New-Object System.Windows.Forms.Form
$form.Text = "Teams Universal & International Holiday Manager"
$form.Size = New-Object System.Drawing.Size(480, 520)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# Label: Region / Land
$lblRegion = New-Object System.Windows.Forms.Label
$lblRegion.Location = New-Object System.Drawing.Point(20, 20)
$lblRegion.Size = New-Object System.Drawing.Size(420, 20)
$lblRegion.Text = "Region / Land & Bundesland waehlen:"
$form.Controls.Add($lblRegion)

# Dropdown: Universelle Auswahl (Deutschland, AT, CH, International)
$cmbRegion = New-Object System.Windows.Forms.ComboBox
$cmbRegion.Location = New-Object System.Drawing.Point(20, 45)
$cmbRegion.Size = New-Object System.Drawing.Size(420, 25)
$cmbRegion.DropDownStyle = "DropDownList"

$regions = @(
    # --- DEUTSCHLAND ---
    "Deutschland - Sachsen (DE-SN)",
    "Deutschland - Bayern (DE-BY)",
    "Deutschland - Baden-Württemberg (DE-BW)",
    "Deutschland - Berlin (DE-BE)",
    "Deutschland - Brandenburg (DE-BB)",
    "Deutschland - Bremen (DE-HB)",
    "Deutschland - Hamburg (DE-HH)",
    "Deutschland - Hessen (DE-HE)",
    "Deutschland - Mecklenburg-Vorpommern (DE-MV)",
    "Deutschland - Niedersachsen (DE-NI)",
    "Deutschland - Nordrhein-Westfalen (DE-NW)",
    "Deutschland - Rheinland-Pfalz (DE-RP)",
    "Deutschland - Saarland (DE-SL)",
    "Deutschland - Sachsen-Anhalt (DE-ST)",
    "Deutschland - Schleswig-Holstein (DE-SH)",
    "Deutschland - Thüringen (DE-TH)",
    "Deutschland - Alle Bundesländer (Bundeseinheitlich + Mix)",
    # --- ÖSTERREICH ---
    "Österreich - Gesamt (AT)",
    # --- SCHWEIZ ---
    "Schweiz - Zürich / Standard (CH)",
    # --- INTERNATIONAL ---
    "International - USA (Standard Federal)",
    "International - UK (United Kingdom)"
)
foreach ($r in $regions) { $cmbRegion.Items.Add($r) | Out-Null }
$cmbRegion.SelectedIndex = 0 # Standard: Sachsen
$form.Controls.Add($cmbRegion)

# Checkbox: Weihnachten inkl. Heiligabend
$chkXmas = New-Object System.Windows.Forms.CheckBox
$chkXmas.Location = New-Object System.Drawing.Point(20, 90)
$chkXmas.Size = New-Object System.Drawing.Size(420, 25)
$chkXmas.Text = "Weihnachten inklusive Heiligabend (24.12. - 27.12.)"
$form.Controls.Add($chkXmas)

# GroupBox: Zeitraum
$grpYears = New-Object System.Windows.Forms.GroupBox
$grpYears.Location = New-Object System.Drawing.Point(20, 130)
$grpYears.Size = New-Object System.Drawing.Size(420, 80)
$grpYears.Text = " Zeitraum (Jahre) "
$form.Controls.Add($grpYears)

$lblYearsInfo = New-Object System.Windows.Forms.Label
$lblYearsInfo.Location = New-Object System.Drawing.Point(15, 30)
$lblYearsInfo.Size = New-Object System.Drawing.Size(390, 30)
$lblYearsInfo.Text = "Automatischer Planungszeitraum: 2026 bis 2030 (5 Jahre)"
$grpYears.Controls.Add($lblYearsInfo)

# Status-Box / Log
$txtLog = New-Object System.Windows.Forms.TextBox
$txtLog.Location = New-Object System.Drawing.Point(20, 225)
$txtLog.Size = New-Object System.Drawing.Size(420, 100)
$txtLog.Multiline = $true
$txtLog.ScrollBars = "Vertical"
$txtLog.ReadOnly = $true
$txtLog.Text = "Bereit. Waehle deine Region aus und klicke auf 'Feiertage in Teams anlegen'."
$form.Controls.Add($txtLog)

# Button: Starten
$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Location = New-Object System.Drawing.Point(20, 345)
$btnRun.Size = New-Object System.Drawing.Size(420, 45)
$btnRun.Text = "Feiertage in Teams anlegen"
$btnRun.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 212)
$btnRun.ForeColor = [System.Drawing.Color]::White
$btnRun.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($btnRun)

# Klick-Logik
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
        Connect-MicrosoftTeams -ErrorAction Stop
        
        $txtLog.Text = "Lese bestehende Feiertage aus Teams..."
        $form.Refresh()
        $ExistingSchedules = @(Get-CsOnlineSchedule -ErrorAction Stop)
        $ExistingNames = @($ExistingSchedules | ForEach-Object { $_.Name })

        $SelectedRegion = $cmbRegion.SelectedItem.ToString()
        # Kürzel aus dem String extrahieren (z.B. "DE-SN" oder "AT")
        $RegionCode = $SelectedRegion.Substring($SelectedRegion.LastIndexOf("(") + 1, $SelectedRegion.LastIndexOf(")") - $SelectedRegion.LastIndexOf("(") - 1)
        $Prefix = "$RegionCode - Feiertag"
        $XmasStartDay = if ($chkXmas.Checked) { "24" } else { "25" }
        $Years = 2026..2030

        $HolidayDefs = [ordered]@{}

        # --- GEMEINSAME BASIS-FEIERTAGE (DE / AT / CH) ---
        if ($RegionCode -like "DE*" -or $RegionCode -eq "AT" -or $RegionCode -eq "CH") {
            $HolidayDefs["Neujahr"] = foreach($y in $Years) { @{ Start = "$y-01-01"; End = "$y-01-02" } }
            $HolidayDefs["Tag der Arbeit"] = foreach($y in $Years) { @{ Start = "$y-05-01"; End = "$y-05-02" } }
            $HolidayDefs["Weihnachten"] = foreach($y in $Years) { @{ Start = "$y-12-$XmasStartDay"; End = "$y-12-27" } }
        }

        # --- REGIONALE LOGIK: DEUTSCHLAND ---
        if ($RegionCode -like "DE*") {
            $StateCode = $RegionCode.Split("-")[1]

            $HolidayDefs["Tag der Deutschen Einheit"] = foreach($y in $Years) { @{ Start = "$y-10-03"; End = "$y-10-04" } }
            
            # Ostern (Karfreitag bis Ostermontag)
            $HolidayDefs["Ostern"] = @(
                @{ Start = "2026-04-03"; End = "2026-04-07" },
                @{ Start = "2027-03-26"; End = "2027-03-30" },
                @{ Start = "2028-04-14"; End = "2028-04-18" },
                @{ Start = "2029-03-30"; End = "2029-04-03" },
                @{ Start = "2030-04-19"; End = "2030-04-23" }
            )
            # Christi Himmelfahrt
            $HolidayDefs["Christi Himmelfahrt"] = @(
                @{ Start = "2026-05-14"; End = "2026-05-15" },
                @{ Start = "2027-05-06"; End = "2027-05-07" },
                @{ Start = "2028-05-25"; End = "2028-05-26" },
                @{ Start = "2029-05-10"; End = "2029-05-11" },
                @{ Start = "2030-05-30"; End = "2030-05-31" }
            )
            # Pfingstmontag
            $HolidayDefs["Pfingstmontag"] = @(
                @{ Start = "2026-05-25"; End = "2026-05-26" },
                @{ Start = "2027-05-17"; End = "2027-05-18" },
                @{ Start = "2028-06-05"; End = "2028-06-06" },
                @{ Start = "2029-05-21"; End = "2029-05-22" },
                @{ Start = "2030-06-10"; End = "2030-06-11" }
            )

            # Bundeslandspezifisch
            if (@("BB", "HB", "HH", "MV", "NI", "SN", "ST", "SH", "TH", "ALL") -contains $StateCode) {
                $HolidayDefs["Reformationstag"] = foreach($y in $Years) { @{ Start = "$y-10-31"; End = "$y-11-01" } }
            }
            if ($StateCode -eq "SN" -or $StateCode -eq "ALL") {
                $BussName = "Bu$([char]0x00DF)- und Bettag"
                $HolidayDefs[$BussName] = @(
                    @{ Start = "2026-11-18"; End = "2026-11-19" },
                    @{ Start = "2027-11-17"; End = "2027-11-18" },
                    @{ Start = "2028-11-15"; End = "2028-11-16" },
                    @{ Start = "2029-11-21"; End = "2029-11-22" },
                    @{ Start = "2030-11-20"; End = "2030-11-21" }
                )
            }
            if (@("BW", "BY", "ST", "ALL") -contains $StateCode) {
                $HolidayDefs["Heilige Drei Könige"] = foreach($y in $Years) { @{ Start = "$y-01-06"; End = "$y-01-07" } }
            }
            if (@("BE", "MV", "ALL") -contains $StateCode) {
                $HolidayDefs["Frauentag"] = foreach($y in $Years) { @{ Start = "$y-03-08"; End = "$y-03-09" } }
            }
            if (@("BW", "BY", "HE", "NW", "RP", "SL", "ALL") -contains $StateCode) {
                $HolidayDefs["Fronleichnam"] = @(
                    @{ Start = "2026-06-04"; End = "2026-06-05" },
                    @{ Start = "2027-05-27"; End = "2027-05-28" },
                    @{ Start = "2028-06-15"; End = "2028-06-16" },
                    @{ Start = "2029-05-31"; End = "2029-06-01" },
                    @{ Start = "2030-06-20"; End = "2030-06-21" }
                )
            }
            if (@("SL", "BY", "ALL") -contains $StateCode) {
                $HolidayDefs["Mariä Himmelfahrt"] = foreach($y in $Years) { @{ Start = "$y-08-15"; End = "$y-08-16" } }
            }
            if ($StateCode -eq "TH" -or $StateCode -eq "ALL") {
                $HolidayDefs["Weltkindertag"] = foreach($y in $Years) { @{ Start = "$y-09-20"; End = "$y-09-21" } }
            }
            if (@("BW", "BY", "NW", "RP", "SL", "ALL") -contains $StateCode) {
                $HolidayDefs["Allerheiligen"] = foreach($y in $Years) { @{ Start = "$y-11-01"; End = "$y-11-02" } }
            }
        }

        # --- REGIONALE LOGIK: ÖSTERREICH (AT) ---
        elseif ($RegionCode -eq "AT") {
            $HolidayDefs["Staatsfeiertag"] = foreach($y in $Years) { @{ Start = "$y-05-01"; End = "$y-05-02" } }
            $HolidayDefs["Nationalfeiertag"] = foreach($y in $Years) { @{ Start = "$y-10-26"; End = "$y-10-27" } }
            $HolidayDefs["Mariä Empfängnis"] = foreach($y in $Years) { @{ Start = "$y-12-08"; End = "$y-12-09" } }
            $HolidayDefs["Christi Himmelfahrt"] = @(
                @{ Start = "2026-05-14"; End = "2026-05-15" },
                @{ Start = "2027-05-06"; End = "2027-05-07" },
                @{ Start = "2028-05-25"; End = "2028-05-26" },
                @{ Start = "2029-05-10"; End = "2029-05-11" },
                @{ Start = "2030-05-30"; End = "2030-05-31" }
            )
        }

        # --- REGIONALE LOGIK: SCHWEIZ (CH) ---
        elseif ($RegionCode -eq "CH") {
            $HolidayDefs["Berchtoldstag"] = foreach($y in $Years) { @{ Start = "$y-01-02"; End = "$y-01-03" } }
            $HolidayDefs["Bundesfeiertag"] = foreach($y in $Years) { @{ Start = "$y-08-01"; End = "$y-08-02" } }
            $HolidayDefs["Auffahrt"] = @(
                @{ Start = "2026-05-14"; End = "2026-05-15" },
                @{ Start = "2027-05-06"; End = "2027-05-07" },
                @{ Start = "2028-05-25"; End = "2028-05-26" },
                @{ Start = "2029-05-10"; End = "2029-05-11" },
                @{ Start = "2030-05-30"; End = "2030-05-31" }
            )
        }

        # --- INTERNATIONAL: USA ---
        elseif ($RegionCode -eq "USA") {
            $HolidayDefs["New Year's Day"] = foreach($y in $Years) { @{ Start = "$y-01-01"; End = "$y-01-02" } }
            $HolidayDefs["Independence Day"] = foreach($y in $Years) { @{ Start = "$y-07-04"; End = "$y-07-05" } }
            $HolidayDefs["Veterans Day"] = foreach($y in $Years) { @{ Start = "$y-11-11"; End = "$y-11-12" } }
            $HolidayDefs["Christmas Day"] = foreach($y in $Years) { @{ Start = "$y-12-25"; End = "$y-12-26" } }
        }

        # --- INTERNATIONAL: UK ---
        elseif ($RegionCode -eq "UK") {
            $HolidayDefs["New Year's Day"] = foreach($y in $Years) { @{ Start = "$y-01-01"; End = "$y-01-02" } }
            $HolidayDefs["Christmas Day"] = foreach($y in $Years) { @{ Start = "$y-12-25"; End = "$y-12-26" } }
            $HolidayDefs["Boxing Day"] = foreach($y in $Years) { @{ Start = "$y-12-26"; End = "$y-12-27" } }
        }

        $counter = 0
        foreach ($HolidayName in $HolidayDefs.Keys) {
            $FullScheduleName = "$Prefix - $HolidayName"
            if ($ExistingNames -contains $FullScheduleName) { continue }

            $txtLog.Text = "Erstelle: $HolidayName..."
            $form.Refresh()

            $Ranges = @()
            foreach ($Period in $HolidayDefs[$HolidayName]) {
                $StartDate = [datetime]::ParseExact($Period.Start, "yyyy-MM-dd", [Globalization.CultureInfo]::InvariantCulture)
                $EndDate   = [datetime]::ParseExact($Period.End,   "yyyy-MM-dd", [Globalization.CultureInfo]::InvariantCulture)
                
                $Ranges += New-CsOnlineDateTimeRange -Start ($StartDate.ToString("d/M/yyyy")) -End ($EndDate.ToString("d/M/yyyy"))
            }

            New-CsOnlineSchedule -Name $FullScheduleName -FixedSchedule -DateTimeRanges $Ranges | Out-Null
            $counter++
        }

        $txtLog.Text = "Fertig! $counter Feiertagsblöcke für $RegionCode erstellt."
        [System.Windows.Forms.MessageBox]::Show("Feiertage wurden erfolgreich für $RegionCode in Teams angelegt!", "Erfolg", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("Fehler: $_", "Fehler", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        $txtLog.Text = "Fehler aufgetreten."
    }
    $btnRun.Enabled = $true
})

[void]$form.ShowDialog()