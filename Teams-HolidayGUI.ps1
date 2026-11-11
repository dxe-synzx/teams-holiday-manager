Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- MAIN WINDOW (Windows 11 Fluent Style) ---
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

# --- SELECT COUNTRY ---
$lblCountry = New-Object System.Windows.Forms.Label
$lblCountry.Location = New-Object System.Drawing.Point(25, 70)
$lblCountry.Size = New-Object System.Drawing.Size(480, 20)
$lblCountry.Text = "Select Country (Worldwide):"
$lblCountry.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($lblCountry)

$cmbCountry = New-Object System.Windows.Forms.ComboBox
$cmbCountry.Location = New-Object System.Drawing.Point(25, 95)
$cmbCountry.Size = New-Object System.Drawing.Size(480, 30)
$cmbCountry.DropDownStyle = "DropDownList"
$cmbCountry.Font = New-Object System.Drawing.Font("Segoe UI", 10)

# Complete global list of countries (Alphabetical by ISO code)
$globalCountries = [ordered]@{
    "Afghanistan (AF)" = "AF"
    "Albania (AL)" = "AL"
    "Algeria (DZ)" = "DZ"
    "Andorra (AD)" = "AD"
    "Angola (AO)" = "AO"
    "Antigua and Barbuda (AG)" = "AG"
    "Argentina (AR)" = "AR"
    "Armenia (AM)" = "AM"
    "Australia (AU)" = "AU"
    "Austria (AT)" = "AT"
    "Azerbaijan (AZ)" = "AZ"
    "Bahamas (BS)" = "BS"
    "Bahrain (BH)" = "BH"
    "Bangladesh (BD)" = "BD"
    "Barbados (BB)" = "BB"
    "Belarus (BY)" = "BY"
    "Belgium (BE)" = "BE"
    "Belize (BZ)" = "BZ"
    "Benin (BJ)" = "BJ"
    "Bhutan (BT)" = "BT"
    "Bolivia (BO)" = "BO"
    "Bosnia and Herzegovina (BA)" = "BA"
    "Botswana (BW)" = "BW"
    "Brazil (BR)" = "BR"
    "Brunei (BN)" = "BN"
    "Bulgaria (BG)" = "BG"
    "Burkina Faso (BF)" = "BF"
    "Burundi (BI)" = "BI"
    "Cabo Verde (CV)" = "CV"
    "Canada (CA)" = "CA"
    "Central African Republic (CF)" = "CF"
    "Chad (TD)" = "TD"
    "Chile (CL)" = "CL"
    "China (CN)" = "CN"
    "Colombia (CO)" = "CO"
    "Comoros (KM)" = "KM"
    "Congo, Democratic Republic of the (CD)" = "CD"
    "Congo, Republic of the (CG)" = "CG"
    "Costa Rica (CR)" = "CR"
    "Cote d'Ivoire (CI)" = "CI"
    "Croatia (HR)" = "HR"
    "Cuba (CU)" = "CU"
    "Cyprus (CY)" = "CY"
    "Czechia (CZ)" = "CZ"
    "Denmark (DK)" = "DK"
    "Djibouti (DJ)" = "DJ"
    "Dominica (DM)" = "DM"
    "Dominican Republic (DO)" = "DO"
    "Ecuador (EC)" = "EC"
    "Egypt (EG)" = "EG"
    "El Salvador (SV)" = "SV"
    "Eritrea (ER)" = "ER"
    "Estonia (EE)" = "EE"
    "Eswatini (SZ)" = "SZ"
    "Ethiopia (ET)" = "ET"
    "Fiji (FJ)" = "FJ"
    "Finland (FI)" = "FI"
    "France (FR)" = "FR"
    "Gabon (GA)" = "GA"
    "Gambia (GM)" = "GM"
    "Georgia (GE)" = "GE"
    "Germany (DE)" = "DE"
    "Ghana (GH)" = "GH"
    "Greece (GR)" = "GR"
    "Grenada (GD)" = "GD"
    "Guatemala (GT)" = "GT"
    "Guinea (GN)" = "GN"
    "Guinea-Bissau (GW)" = "GW"
    "Guyana (GY)" = "GY"
    "Haiti (HT)" = "HT"
    "Honduras (HN)" = "HN"
    "Hungary (HU)" = "HU"
    "Iceland (IS)" = "IS"
    "India (IN)" = "IN"
    "Indonesia (ID)" = "ID"
    "Iran (IR)" = "IR"
    "Iraq (IQ)" = "IQ"
    "Ireland (IE)" = "IE"
    "Israel (IL)" = "IL"
    "Italy (IT)" = "IT"
    "Jamaica (JM)" = "JM"
    "Japan (JP)" = "JP"
    "Jordan (JO)" = "JO"
    "Kazakhstan (KZ)" = "KZ"
    "Kenya (KE)" = "KE"
    "Kiribati (KI)" = "KI"
    "Kuwait (KW)" = "KW"
    "Kyrgyzstan (KG)" = "KG"
    "Laos (LA)" = "LA"
    "Latvia (LV)" = "LV"
    "Lebanon (LB)" = "LB"
    "Lesotho (LS)" = "LS"
    "Liberia (LR)" = "LR"
    "Libya (LY)" = "LY"
    "Liechtenstein (LI)" = "LI"
    "Lithuania (LT)" = "LT"
    "Luxembourg (LU)" = "LU"
    "Madagascar (MG)" = "MG"
    "Malawi (MW)" = "MW"
    "Malaysia (MY)" = "MY"
    "Maldives (MV)" = "MV"
    "Mali (ML)" = "ML"
    "Malta (MT)" = "MT"
    "Marshall Islands (MH)" = "MH"
    "Mauritania (MR)" = "MR"
    "Mauritius (MU)" = "MU"
    "Mexico (MX)" = "MX"
    "Micronesia (FM)" = "FM"
    "Moldova (MD)" = "MD"
    "Monaco (MC)" = "MC"
    "Mongolia (MN)" = "MN"
    "Montenegro (ME)" = "ME"
    "Morocco (MA)" = "MA"
    "Mozambique (MZ)" = "MZ"
    "Myanmar (MM)" = "MM"
    "Namibia (NA)" = "NA"
    "Nauru (NR)" = "NR"
    "Nepal (NP)" = "NP"
    "Netherlands (NL)" = "NL"
    "New Zealand (NZ)" = "NZ"
    "Nicaragua (NI)" = "NI"
    "Niger (NE)" = "NE"
    "Nigeria (NG)" = "NG"
    "North Korea (KP)" = "KP"
    "North Macedonia (MK)" = "MK"
    "Norway (NO)" = "NO"
    "Oman (OM)" = "OM"
    "Pakistan (PK)" = "PK"
    "Palau (PW)" = "PW"
    "Panama (PA)" = "PA"
    "Papua New Guinea (PG)" = "PG"
    "Paraguay (PY)" = "PY"
    "Peru (PE)" = "PE"
    "Philippines (PH)" = "PH"
    "Poland (PL)" = "PL"
    "Portugal (PT)" = "PT"
    "Qatar (QA)" = "QA"
    "Romania (RO)" = "RO"
    "Russia (RU)" = "RU"
    "Rwanda (RW)" = "RW"
    "Saint Kitts and Nevis (KN)" = "KN"
    "Saint Lucia (LC)" = "LC"
    "Saint Vincent and the Grenadines (VC)" = "VC"
    "Samoa (WS)" = "WS"
    "San Marino (SM)" = "SM"
    "Sao Tome and Principe (ST)" = "ST"
    "Saudi Arabia (SA)" = "SA"
    "Senegal (SN)" = "SN"
    "Serbia (RS)" = "RS"
    "Seychelles (SC)" = "SC"
    "Sierra Leone (SL)" = "SL"
    "Singapore (SG)" = "SG"
    "Slovakia (SK)" = "SK"
    "Slovenia (SI)" = "SI"
    "Solomon Islands (SB)" = "SB"
    "Somalia (SO)" = "SO"
    "South Africa (ZA)" = "ZA"
    "South Korea (KR)" = "KR"
    "South Sudan (SS)" = "SS"
    "Spain (ES)" = "ES"
    "Sri Lanka (LK)" = "LK"
    "Sudan (SD)" = "SD"
    "Suriname (SR)" = "SR"
    "Sweden (SE)" = "SE"
    "Switzerland (CH)" = "CH"
    "Syria (SY)" = "SY"
    "Tajikistan (TJ)" = "TJ"
    "Tanzania (TZ)" = "TZ"
    "Thailand (TH)" = "TH"
    "Timor-Leste (TL)" = "TL"
    "Togo (TG)" = "TG"
    "Tonga (TO)" = "TO"
    "Trinidad and Tobago (TT)" = "TT"
    "Tunisia (TN)" = "TN"
    "Turkey (TR)" = "TR"
    "Turkmenistan (TM)" = "TM"
    "Tuvalu (TV)" = "TV"
    "Uganda (UG)" = "UG"
    "Ukraine (UA)" = "UA"
    "United Arab Emirates (AE)" = "AE"
    "United Kingdom (GB)" = "GB"
    "USA (United States) (US)" = "US"
    "Uruguay (UY)" = "UY"
    "Uzbekistan (UZ)" = "UZ"
    "Vanuatu (VU)" = "VU"
    "Vatican City (VA)" = "VA"
    "Venezuela (VE)" = "VE"
    "Vietnam (VN)" = "VN"
    "Yemen (YE)" = "YE"
    "Zambia (ZM)" = "ZM"
    "Zimbabwe (ZW)" = "ZW"
}

foreach ($key in $globalCountries.Keys) {
    $cmbCountry.Items.Add($key) | Out-Null
}
$cmbCountry.SelectedIndex = 33 # Default to Germany
$form.Controls.Add($cmbCountry)

# --- OPTIONS ---
$chkXmas = New-Object System.Windows.Forms.CheckBox
$chkXmas.Location = New-Object System.Drawing.Point(25, 145)
$chkXmas.Size = New-Object System.Drawing.Size(480, 25)
$chkXmas.Text = "Create holidays as optimized calendar blocks"
$chkXmas.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$form.Controls.Add($chkXmas)

# --- DATE RANGE ---
$grpYears = New-Object System.Windows.Forms.GroupBox
$grpYears.Location = New-Object System.Drawing.Point(25, 185)
$grpYears.Size = New-Object System.Drawing.Size(480, 75)
$grpYears.Text = " Planning Period "
$grpYears.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($grpYears)

$lblFrom = New-Object System.Windows.Forms.Label
$lblFrom.Location = New-Object System.Drawing.Point(20, 33)
$lblFrom.Size = New-Object System.Drawing.Size(70, 20)
$lblFrom.Text = "Start Year:"
$lblFrom.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$grpYears.Controls.Add($lblFrom)

$txtStartYear = New-Object System.Windows.Forms.TextBox
$txtStartYear.Location = New-Object System.Drawing.Point(95, 30)
$txtStartYear.Size = New-Object System.Drawing.Size(75, 25)
$txtStartYear.Text = "2026"
$txtStartYear.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$grpYears.Controls.Add($txtStartYear)

$lblTo = New-Object System.Windows.Forms.Label
$lblTo.Location = New-Object System.Drawing.Point(210, 33)
$lblTo.Size = New-Object System.Drawing.Size(65, 20)
$lblTo.Text = "End Year:"
$lblTo.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$grpYears.Controls.Add($lblTo)

$txtEndYear = New-Object System.Windows.Forms.TextBox
$txtEndYear.Location = New-Object System.Drawing.Point(280, 30)
$txtEndYear.Size = New-Object System.Drawing.Size(75, 25)
$txtEndYear.Text = "2030"
$txtEndYear.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$grpYears.Controls.Add($txtEndYear)

# --- LOG WINDOW ---
$txtLog = New-Object System.Windows.Forms.TextBox
$txtLog.Location = New-Object System.Drawing.Point(25, 280)
$txtLog.Size = New-Object System.Drawing.Size(480, 230)
$txtLog.Multiline = $true
$txtLog.ScrollBars = "Vertical"
$txtLog.ReadOnly = $true
$txtLog.BackColor = [System.Drawing.Color]::FromArgb(255, 255, 255)
$txtLog.ForeColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$txtLog.Font = New-Object System.Drawing.Font("Consolas", 9)
$txtLog.Text = "Ready. Select a country to begin..."
$form.Controls.Add($txtLog)

# --- START BUTTON ---
$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Location = New-Object System.Drawing.Point(25, 530)
$btnRun.Size = New-Object System.Drawing.Size(480, 45)
$btnRun.Text = "Create Holidays in Teams"
$btnRun.BackColor = [System.Drawing.Color]::FromArgb(0, 95, 184)
$btnRun.ForeColor = [System.Drawing.Color]::White
$btnRun.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnRun.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnRun.FlatAppearance.BorderSize = 0
$form.Controls.Add($btnRun)

# --- EXECUTION LOGIC ---
$btnRun.Add_Click({
    $startYear = 0
    $endYear = 0
    if (-not [int]::TryParse($txtStartYear.Text, [ref]$startYear) -or -not [int]::TryParse($txtEndYear.Text, [ref]$endYear)) {
        [System.Windows.Forms.MessageBox]::Show("Please enter a valid year range.", "Invalid Input", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }

    $btnRun.Enabled = $false
    $txtLog.Text = "Connecting to Microsoft Teams...`r`n"
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

        $txtLog.AppendText("Fetching official holidays for $CountryCode...`r`n")
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
                    $txtLog.AppendText("Created: $FullScheduleName`r`n")
                    $form.Refresh()
                    $counter++
                }
            }
            catch {
                $msg = "Notice for year " + $y + ": No data or API unreachable.`r`n"
                $txtLog.AppendText($msg)
            }
        }

        $txtLog.AppendText("`r`nDone! $counter holiday schedules imported successfully.")
        [System.Windows.Forms.MessageBox]::Show("Holidays were successfully created in Teams!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("An error occurred: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        $txtLog.AppendText("Error: $_`r`n")
    }
    $btnRun.Enabled = $true
})

[void]$form.ShowDialog()