Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- HAUPTFENSTER (Windows 11 Fluent Style) ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "Teams Global Holiday Manager - Win11 Edition"
$form.Size = New-Object System.Drawing.Size(540, 680)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(243, 243, 243)

# --- HEADER ---
$lblHeader = New-Object System.Windows.Forms.Label
$lblHeader.Location = New-Object System.Drawing.Point(25, 20)
$lblHeader.Size = New-Object System.Drawing.Size(480, 35)
$lblHeader.Text = "Teams Global Holiday Manager"
$lblHeader.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$lblHeader.ForeColor = [System.Drawing.Color]::FromArgb(0, 95, 184)
$form.Controls.Add($lblHeader)

# --- LAND WAEHLEN (ALLE LAENDER DER WELT) ---
$lblCountry = New-Object System.Windows.Forms.Label
$lblCountry.Location = New-Object System.Drawing.Point(25, 70)
$lblCountry.Size = New-Object System.Drawing.Size(480, 20)
$lblCountry.Text = "Land waehlen (Alle Laender weltweit):"
$lblCountry.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($lblCountry)

$cmbCountry = New-Object System.Windows.Forms.ComboBox
$cmbCountry.Location = New-Object System.Drawing.Point(25, 95)
$cmbCountry.Size = New-Object System.Drawing.Size(480, 30)
$cmbCountry.DropDownStyle = "DropDownList"
$cmbCountry.Font = New-Object System.Drawing.Font("Segoe UI", 10)

# Vollstaendige Liste aller Laender der Welt (Alphabetisch nach ISO)
$globalCountries = [ordered]@{
    "Afghanistan (AF)" = "AF"
    "Aegypten (EG)" = "EG"
    "Albanien (AL)" = "AL"
    "Algerien (DZ)" = "DZ"
    "Andorra (AD)" = "AD"
    "Angola (AO)" = "AO"
    "Antigua und Barbuda (AG)" = "AG"
    "Argentinien (AR)" = "AR"
    "Armenien (AM)" = "AM"
    "Aserbaidschan (AZ)" = "AZ"
    "Aethiopien (ET)" = "ET"
    "Australien (AU)" = "AU"
    "Bahamas (BS)" = "BS"
    "Bahrain (BH)" = "BH"
    "Bangladesch (BD)" = "BD"
    "Barbados (BB)" = "BB"
    "Belarus (BY)" = "BY"
    "Belgien (BE)" = "BE"
    "Belize (BZ)" = "BZ"
    "Benin (BJ)" = "BJ"
    "Bhutan (BT)" = "BT"
    "Bolivien (BO)" = "BO"
    "Bosnien und Herzegowina (BA)" = "BA"
    "Botsuana (BW)" = "BW"
    "Brasilien (BR)" = "BR"
    "Brunei (BN)" = "BN"
    "Bulgarien (BG)" = "BG"
    "Burkina Faso (BF)" = "BF"
    "Burundi (BI)" = "BI"
    "Chile (CL)" = "CL"
    "China (CN)" = "CN"
    "Costa Rica (CR)" = "CR"
    "Daenemark (DK)" = "DK"
    "Deutschland (DE)" = "DE"
    "Dominica (DM)" = "DM"
    "Dominikanische Republik (DO)" = "DO"
    "Dschibuti (DJ)" = "DJ"
    "Ecuador (EC)" = "EC"
    "El Salvador (SV)" = "SV"
    "Elfenbeinkueste (CI)" = "CI"
    "Eritrea (ER)" = "ER"
    "Estland (EE)" = "EE"
    "Eswatini (SZ)" = "SZ"
    "Fidschi (FJ)" = "FJ"
    "Finnland (FI)" = "FI"
    "Frankreich (FR)" = "FR"
    "Gabun (GA)" = "GA"
    "Gambia (GM)" = "GM"
    "Georgien (GE)" = "GE"
    "Ghana (GH)" = "GH"
    "Grenada (GD)" = "GD"
    "Griechenland (GR)" = "GR"
    "Großbritannien / UK (GB)" = "GB"
    "Guatemala (GT)" = "GT"
    "Guinea (GN)" = "GN"
    "Guinea-Bissau (GW)" = "GW"
    "Guyana (GY)" = "GY"
    "Haiti (HT)" = "HT"
    "Honduras (HN)" = "HN"
    "Indien (IN)" = "IN"
    "Indonesien (ID)" = "ID"
    "Irak (IQ)" = "IQ"
    "Iran (IR)" = "IR"
    "Irland (IE)" = "IE"
    "Island (IS)" = "IS"
    "Israel (IL)" = "IL"
    "Italien (IT)" = "IT"
    "Jamaika (JM)" = "JM"
    "Japan (JP)" = "JP"
    "Jemen (YE)" = "YE"
    "Jordanien (JO)" = "JO"
    "Kambodscha (KH)" = "KH"
    "Kamerun (CM)" = "CM"
    "Kanada (CA)" = "CA"
    "Kap Verde (CV)" = "CV"
    "Kasachstan (KZ)" = "KZ"
    "Katar (QA)" = "QA"
    "Kenia (KE)" = "KE"
    "Kirgisistan (KG)" = "KG"
    "Kiribati (KI)" = "KI"
    "Kolumbien (CO)" = "CO"
    "Komoren (KM)" = "KM"
    "Kongo, Demokratische Republik (CD)" = "CD"
    "Kongo, Republik (CG)" = "CG"
    "Kroatien (HR)" = "HR"
    "Kuba (CU)" = "CU"
    "Kuwait (KW)" = "KW"
    "Laos (LA)" = "LA"
    "Lesotho (LS)" = "LS"
    "Lettland (LV)" = "LV"
    "Libanon (LB)" = "LB"
    "Liberia (LR)" = "LR"
    "Libyen (LY)" = "LY"
    "Liechtenstein (LI)" = "LI"
    "Litauen (LT)" = "LT"
    "Luxemburg (LU)" = "LU"
    "Madagaskar (MG)" = "MG"
    "Malawi (MW)" = "MW"
    "Malaysia (MY)" = "MY"
    "Malediven (MV)" = "MV"
    "Mali (ML)" = "ML"
    "Malta (MT)" = "MT"
    "Marokko (MA)" = "MA"
    "Marshallinseln (MH)" = "MH"
    "Mauretanien (MR)" = "MR"
    "Mauritius (MU)" = "MU"
    "Mexiko (MX)" = "MX"
    "Mikronesien (FM)" = "FM"
    "Moldau (MD)" = "MD"
    "Monaco (MC)" = "MC"
    "Mongolei (MN)" = "MN"
    "Montenegro (ME)" = "ME"
    "Mosambik (MZ)" = "MZ"
    "Myanmar (MM)" = "MM"
    "Namibia (NA)" = "NA"
    "Nauru (NR)" = "NR"
    "Nepal (NP)" = "NP"
    "Neuseeland (NZ)" = "NZ"
    "Nicaragua (NI)" = "NI"
    "Niederlande (NL)" = "NL"
    "Niger (NE)" = "NE"
    "Nigeria (NG)" = "NG"
    "Nordkorea (KP)" = "KP"
    "Nordmazedonien (MK)" = "MK"
    "Norwegen (NO)" = "NO"
    "Oman (OM)" = "OM"
    "Oesterreich (AT)" = "AT"
    "Pakistan (PK)" = "PK"
    "Palau (PW)" = "PW"
    "Panama (PA)" = "PA"
    "Papua-Neuguinea (PG)" = "PG"
    "Paraguay (PY)" = "PY"
    "Peru (PE)" = "PE"
    "Philippinen (PH)" = "PH"
    "Polen (PL)" = "PL"
    "Portugal (PT)" = "PT"
    "Ruanda (RW)" = "RW"
    "Rumaenien (RO)" = "RO"
    "Russische Foederation (RU)" = "RU"
    "Salomonen (SB)" = "SB"
    "Sambia (ZM)" = "ZM"
    "Samoa (WS)" = "WS"
    "San Marino (SM)" = "SM"
    "Sao Tome und Principe (ST)" = "ST"
    "Saudi-Arabien (SA)" = "SA"
    "Schweden (SE)" = "SE"
    "Schweiz (CH)" = "CH"
    "Senegal (SN)" = "SN"
    "Serbien (RS)" = "RS"
    "Seychellen (SC)" = "SC"
    "Sierra Leone (SL)" = "SL"
    "Simbabwe (ZW)" = "ZW"
    "Singapur (SG)" = "SG"
    "Slowakei (SK)" = "SK"
    "Slowenien (SI)" = "SI"
    "Somalia (SO)" = "SO"
    "Spanien (ES)" = "ES"
    "Sri Lanka (LK)" = "LK"
    "St. Kitts und Nevis (KN)" = "KN"
    "St. Lucia (LC)" = "LC"
    "St. Vincent und die Grenadinen (VC)" = "VC"
    "Suedafrika (ZA)" = "ZA"
    "Sudan (SD)" = "SD"
    "Suedkorea (KR)" = "KR"
    "Suedsudan (SS)" = "SS"
    "Suriname (SR)" = "SR"
    "Syrien (SY)" = "SY"
    "Tadschikistan (TJ)" = "TJ"
    "Tansania (TZ)" = "TZ"
    "Thailand (TH)" = "TH"
    "Timor-Leste (TL)" = "TL"
    "Togo (TG)" = "TG"
    "Tonga (TO)" = "TO"
    "Trinidad und Tobago (TT)" = "TT"
    "Tschad (TD)" = "TD"
    "Tschechien (CZ)" = "CZ"
    "Tunesien (TN)" = "TN"
    "Tuerkei (TR)" = "TR"
    "Turkmenistan (TM)" = "TM"
    "Tuvalu (TV)" = "TV"
    "Uganda (UG)" = "UG"
    "Ukraine (UA)" = "UA"
    "Ungarn (HU)" = "HU"
    "Uruguay (UY)" = "UY"
    "Usbekistan (UZ)" = "UZ"
    "Vanuatu (VU)" = "VU"
    "Vatikanstadt (VA)" = "VA"
    "Venezuela (VE)" = "VE"
    "Vereinigte Arabische Emirate (AE)" = "AE"
    "USA (Vereinigte Staaten) (US)" = "US"
    "Vietnam (VN)" = "VN"
    "Zentralafrikanische Republik (CF)" = "CF"
    "Zypern (CY)" = "CY"
}

foreach ($key in $globalCountries.Keys) {
    $cmbCountry.Items.Add($key) | Out-Null
}
$cmbCountry.SelectedIndex = 33 # Standard auf Deutschland
$form.Controls.Add($cmbCountry)

# --- OPTIONEN ---
$chkXmas = New-Object System.Windows.Forms.CheckBox
$chkXmas.Location = New-Object System.Drawing.Point(25, 145)
$chkXmas.Size = New-Object System.Drawing.Size(480, 25)
$chkXmas.Text = "Feiertage als optimierte Kalender-Bloecke anlegen"
$chkXmas.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$form.Controls.Add($chkXmas)

# --- ZEITRAUM ---
$grpYears = New-Object System.Windows.Forms.GroupBox
$grpYears.Location = New-Object System.Drawing.Point(25, 185)
$grpYears.Size = New-Object System.Drawing.Size(480, 75)
$grpYears.Text = " Planungszeitraum "
$grpYears.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($grpYears)

$lblFrom = New-Object System.Windows.Forms.Label
$lblFrom.Location = New-Object System.Drawing.Point(20, 33)
$lblFrom.Size = New-Object System.Drawing.Size(60, 20)
$lblFrom.Text = "Von Jahr:"
$lblFrom.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$grpYears.Controls.Add($lblFrom)

$txtStartYear = New-Object System.Windows.Forms.TextBox
$txtStartYear.Location = New-Object System.Drawing.Point(90, 30)
$txtStartYear.Size = New-Object System.Drawing.Size(80, 25)
$txtStartYear.Text = "2026"
$txtStartYear.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$grpYears.Controls.Add($txtStartYear)

$lblTo = New-Object System.Windows.Forms.Label
$lblTo.Location = New-Object System.Drawing.Point(210, 33)
$lblTo.Size = New-Object System.Drawing.Size(60, 20)
$lblTo.Text = "Bis Jahr:"
$lblTo.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$grpYears.Controls.Add($lblTo)

$txtEndYear = New-Object System.Windows.Forms.TextBox
$txtEndYear.Location = New-Object System.Drawing.Point(280, 30)
$txtEndYear.Size = New-Object System.Drawing.Size(80, 25)
$txtEndYear.Text = "2030"
$txtEndYear.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$grpYears.Controls.Add($txtEndYear)

# --- LOG-FENSTER ---
$txtLog = New-Object System.Windows.Forms.TextBox
$txtLog.Location = New-Object System.Drawing.Point(25, 280)
$txtLog.Size = New-Object System.Drawing.Size(480, 230)
$txtLog.Multiline = $true
$txtLog.ScrollBars = "Vertical"
$txtLog.ReadOnly = $true
$txtLog.BackColor = [System.Drawing.Color]::FromArgb(255, 255, 255)
$txtLog.ForeColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$txtLog.Font = New-Object System.Drawing.Font("Consolas", 9)
$txtLog.Text = "Bereit. Waehle ein Land aus, um fortzufahren..."
$form.Controls.Add($txtLog)

# --- START BUTTON ---
$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Location = New-Object System.Drawing.Point(25, 530)
$btnRun.Size = New-Object System.Drawing.Size(480, 45)
$btnRun.Text = "Feiertage in Teams anlegen"
$btnRun.BackColor = [System.Drawing.Color]::FromArgb(0, 95, 184)
$btnRun.ForeColor = [System.Drawing.Color]::White
$btnRun.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnRun.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnRun.FlatAppearance.BorderSize = 0
$form.Controls.Add($btnRun)

# --- AUSFUEHRUNGS-LOGIK ---
$btnRun.Add_Click({
    $startYear = 0
    $endYear = 0
    if (-not [int]::TryParse($txtStartYear.Text, [ref]$startYear) -or -not [int]::TryParse($txtEndYear.Text, [ref]$endYear)) {
        return
    }

    $btnRun.Enabled = $false
    $txtLog.Text = "Verbinde mit Microsoft Teams...`r`n"
    $form.Refresh()

    try {
        if (-not (Get-Module -ListAvailable -Name MicrosoftTeams)) {
            Install-Module MicrosoftTeams -Scope CurrentUser -Force -AllowClobber
        }
        Import-Module MicrosoftTeams -ErrorAction Stop
        Connect-MicrosoftTeams -ErrorAction Stop
        
        $SelectedKey = $cmbCountry.SelectedItem.ToString()
        $CountryCode = $globalCountries[$SelectedKey]
        $Prefix = "$CountryCode - Holiday"

        $txtLog.AppendText("Lade offizielle Feiertage fuer $CountryCode...`r`n")
        $form.Refresh()

        $ExistingSchedules = @(Get-CsOnlineSchedule -ErrorAction Stop)
        $ExistingNames = @($ExistingSchedules | ForEach-Object { $_.Name })

        $counter = 0
        $Years = $startYear..$endYear

        foreach ($y in $Years) {
            $apiUrl = "https://date.nager.at/api/v3/PublicHolidays/$y/$CountryCode"
            
            try {
                $response = Invoke-RestMethod -Uri $apiUrl -Method Get -ErrorAction Stop
                
                foreach ($h in $response) {
                    $HolidayName = $h.localName
                    $FullScheduleName = "$Prefix - $HolidayName ($y)"

                    if ($ExistingNames -contains $FullScheduleName) { continue }

                    $StartDate = [datetime]::ParseExact($h.date, "yyyy-MM-dd", [Globalization.CultureInfo]::InvariantCulture)
                    $EndDate = $StartDate.AddDays(1)

                    $Range = New-CsOnlineDateTimeRange -Start ($StartDate.ToString("d/M/yyyy")) -End ($EndDate.ToString("d/M/yyyy"))
                    
                    New-CsOnlineSchedule -Name $FullScheduleName -FixedSchedule -DateTimeRanges @($Range) | Out-Null
                    $txtLog.AppendText("Erstellt: $FullScheduleName`r`n")
                    $form.Refresh()
                    $counter++
                }
            }
            catch {
                $msg = "Hinweis fuer Jahr " + $y + ": Keine Daten oder API nicht erreichbar.`r`n"
                $txtLog.AppendText($msg)
            }
        }

        $txtLog.AppendText("`r`nFertig! $counter Feiertage erfolgreich importiert.")
        [System.Windows.Forms.MessageBox]::Show("Feiertage wurden erfolgreich angelegt!", "Erfolg", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("Fehler aufgetreten.", "Fehler", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
    $btnRun.Enabled = $true
})

[void]$form.ShowDialog()