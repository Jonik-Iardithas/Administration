# =============================================================
# ========== Initialization ===================================
# =============================================================

If (!([System.Security.Principal.WindowsPrincipal][System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator))
    {
        Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$PSCommandPath`""
        Exit
    }

[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName('WindowsFormsIntegration') | Out-Null
[System.Windows.Forms.Application]::EnableVisualStyles()

# =============================================================
# ========== Variables ========================================
# =============================================================

$Margin = [System.Drawing.Size]::new(10,10)
$Padding = [System.Drawing.Size]::new(10,10)
$L_Ptr = [System.IntPtr]::new(0)
$S_Ptr = [System.IntPtr]::new(0)
$SettingsFile = "$env:LOCALAPPDATA\PowerShellTools\Administration\Settings.ini"
$Fonts = [System.Drawing.FontFamily]::Families
$Global:AppContext = New-Object System.Windows.Forms.ApplicationContext

$Layout = @{
    L = @{
        A = [System.Drawing.Size]::new(110,110)
        B = [System.Drawing.Size]::new(110,178)
        C = [System.Drawing.Size]::new(110,22)
    }
    R = @{
        D = [System.Drawing.Size]::new(290,330)
    }
}

$Rects = [HashTable]::new(0)
$Left = 0

ForEach ($L0 in $Layout.Keys | Sort-Object)
    {
        $Top = 0

        ForEach ($L1 in $Layout.$L0.Keys | Sort-Object)
            {
                $Rects += @{$L1 = [System.Drawing.Rectangle]::new($Left + $Margin.Width, $Top + $Margin.Height, $Layout.$L0.$L1.Width, $Layout.$L0.$L1.Height)}
                $Top += $Layout.$L0.$L1.Height + $Margin.Height
            }

        $Left += ($Layout.$L0.Values.Width | Measure-Object -Maximum).Maximum + $Margin.Width
    }

$Font = @{
    Index = $Fonts.Name.IndexOf('Verdana')
    Size = 8
    Style = [System.Drawing.FontStyle]::Regular
}

$Form = @{
    Size = [System.Drawing.Size]::new((($Rects.Values.Right | Measure-Object -Maximum).Maximum + $Padding.Width),(($Rects.Values.Bottom | Measure-Object -Maximum).Maximum + $Padding.Height))
}

$Button = @{
    Size = [System.Drawing.Size]::new(266,26)
    IconSize = [System.Drawing.Size]::new(20,20)
}

$CMI = @{
    IconSize = [System.Drawing.Size]::new(20,20)
}

$Ini_Bak = @{
    Autostart = 0
    ButtonBackColor = -1120086
    ButtonBorderColor = -16777216
    ButtonForeColor = -16777216
    ButtonHoverColor = -329006
    FontName = "Verdana"
    FormBackColor = -7876870
    IconFolder = "$env:ProgramFiles\PowerShellTools\Administration\Icons\"
    LogoBackColor = -7876870
    LogoBackground = "Logo_Back0.png"
    PanelBackColor = -7876870
    PanelBackground = "Panel_Back0.png"
    SysTray = 1
}

$Txt_List = @{
    MainForm                      = "Administration"
    GB                            = "Admin"
    Settings                      = "Optionen"
    SysIcon                       = "Administration"
    CMI_a_Restore                 = "Wiederherstellen"
    CMI_b_Exit                    = "Beenden"
    CMI_a_FormColor               = "Formularfarbe"
    CMI_b_LogoColor               = "Logofarbe"
    CMI_c_PanelColor              = "Panelfarbe"
    CMI_d_TextColor               = "Tasten-Textfarbe"
    CMI_e_BackColor               = "Tasten-Hintergrundfarbe"
    CMI_f_HoverColor              = "Tasten-Hover-Farbe"
    CMI_g_BorderColor             = "Tasten-Rahmenfarbe"
    CMI_a_LogoBack                = "Logo-Hintergrund"
    CMI_b_PanelBack               = "Panel-Hintergrund"
    CMI_a_SysTray                 = "Schließen in den Infobereich"
    CMI_b_Autostart               = "Autostart bei Anmeldung"
    CMI_a_ButtonFont              = "Tasten-Schriftart"
    CMI_a_HDDRepair               = "Laufwerk {0}:"
    CMI_a_SFC                     = "System File Checker (sfc.exe)"
    CMI_b_DISM                    = "Deployment Imaging Servicing and Management (dism.exe)"
    BT_TaskScheduler              = "Aufgabenplanung"
    BT_Cmd                        = "Eingabeaufforderung"
    BT_Cmd_help                   = "Befehlsübersicht"
    BT_Cmd_HDDRepair              = "HDD-Reparatur"
    BT_Cmd_ver                    = "Windows-Version"
    BT_Cmd_ipconfig               = "IP-/Netzwerkadresse"
    BT_Cmd_flushdns               = "DNS-Cache leeren"
    BT_Cmd_WinRepair              = "Windows-Reparatur"
    BT_DiskManagement             = "Datenträgerverwaltung"
    BT_DirectXDiagnosis           = "DirectX-Diagnoseprogramm"
    BT_ImmersiveControlPanel      = "Einstellungen"
    BT_PowerConfiguration         = "Energieoptionen"
    BT_EventViewer                = "Ereignisanzeige"
    BT_DeviceManager              = "Geräte-Manager"
    BT_GroupPolicyEditor          = "Gruppenrichtlinien"
    BT_NvidiaControlPanel         = "Nvidia-Control-Panel"
    BT_RealtekAudioConsole        = "Realtek-Audio-Console"
    BT_RegistryEditor             = "Registrierungs-Editor"
    BT_PerformanceMonitor         = "Leistungsüberwachung"
    BT_ResourceMonitor            = "Ressourcenmonitor"
    BT_ReliabilityMonitor         = "Zuverlässigkeitsüberwachung"
    BT_AppsFolder                 = "Applications"
    BT_ChangeRemoveProgramsFolder = "Programme und Features"
    BT_ConnectionsFolder          = "Netzwerkverbindungen"
    BT_PrintersFolder             = "Drucker"
    BT_RecycleBinFolder           = "Papierkorb"
    BT_SearchHomeFolder           = "Suchergebnisse"
    BT_AppUpdatesFolder           = "Installierte Updates"
    BT_UsersLibrariesFolder       = "Bibliotheken"
    BT_ComputerManagement         = "Computerverwaltung"
    BT_SystemProperties           = "Systemeigenschaften"
    BT_MSConfiguration            = "Systemkonfiguration"
    BT_ControlPanel               = "Systemsteuerung"
    BT_TaskManager                = "Task-Manager"
    BT_AdministrativeTools        = "Verwaltungsprogramme"
    BT_DriveOptimizer             = "Laufwerksoptimierung"
    BT_RecoveryDrive              = "Wiederherstellungslaufwerk"
    BT_MemoryDiagnosisScheduler   = "Windows-Speicherdiagnose"
    BT_ChangeColor                = "Farben anpassen"
    BT_ChangeBackground           = "Hintergrundbild anpassen"
    BT_ChangeBehavior             = "Verhalten anpassen"
    BT_ChangeFont                 = "Schriftart anpassen"
    TT_Cmd_HDDRepair              = "$env:windir\system32\cmd.exe /k chkdsk [Volume] /f /r /x"
    TT_Cmd_WinRepair              = "$env:windir\system32\cmd.exe /k [sfc /scannow][dism /Online /Cleanup-Image /RestoreHealth]"
}

$MB_List = @{
    Ini_01 = "Konnte Datei {0} nicht finden."
    Ini_02 = "Administration: Fehler!"
}

# =============================================================
# ========== Enums ============================================
# =============================================================

[Flags()] enum Method {
    Image = 1
    Associate = 2
    Extract = 4
}

# -------------------------------------------------------------

[Flags()] enum Radios {
    Verwaltung = 1
    Shell = 2
    Cmd = 4
    Tools = 8
    UWP = 16
    Monitor = 32
}

# -------------------------------------------------------------

[Flags()] enum Panels {
    Verwaltung = 1
    Shell = 2
    Cmd = 4
    Tools = 8
    UWP = 16
    Monitor = 32
    Start = 64
    Settings = 128
}

# =============================================================
# ========== Win32Functions ===================================
# =============================================================

$Member = @'
    [DllImport("Shell32.dll", EntryPoint = "ExtractIconExW", CharSet = CharSet.Unicode, ExactSpelling = true, CallingConvention = CallingConvention.StdCall)]
    public static extern int ExtractIconEx(string lpszFile, int nIconIndex, out IntPtr phiconLarge, out IntPtr phiconSmall, int nIcons);

    [DllImport("User32.dll", EntryPoint = "DestroyIcon")]
    public static extern bool DestroyIcon(IntPtr hIcon);

    [DllImport("User32.dll", EntryPoint = "ShowWindowAsync")]
    public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
'@

Add-Type -MemberDefinition $Member -Name WinAPI -Namespace Win32Functions

# =============================================================
# ========== Functions ========================================
# =============================================================

function Initialize-Me ([string]$FilePath)
    {
        If (!(Test-Path -Path $FilePath))
            {
                [System.Windows.Forms.MessageBox]::Show(($MB_List.Ini_01 -f $FilePath),$MB_List.Ini_02,0)
                Exit
            }

        $Data = [array](Get-Content -Path $FilePath)

        ForEach ($i in $Data)
            {
                $ht_Result += @{$i.Split("=")[0].Trim() = $i.Split("=")[-1].Trim()}
            }

        return $ht_Result
    }

# -------------------------------------------------------------

function Register-Autostart ([string]$Name, [string]$Path, [bool]$Active)
    {
        If (!(Get-ScheduledTask -TaskName $Name -ErrorAction SilentlyContinue))
            {
                $ht_Task = @{
                    TaskName = $Name
                    Principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest
                    Action = New-ScheduledTaskAction -Execute "$PSHOME\powershell.exe" -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$Path`" /Autostart"
                    Description = "Autostart $Name"
                    Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries
                    Trigger = New-ScheduledTaskTrigger -AtLogOn
                }

                Register-ScheduledTask @ht_Task | Out-Null

                $Task = Get-ScheduledTask -TaskName $Name
                $Task.Triggers[0].Delay = "PT5S"
                Set-ScheduledTask $Task | Out-Null
            }

        If ($Active)
            {
                Enable-ScheduledTask -TaskName $Name | Out-Null
            }
        Else
            {
                Disable-ScheduledTask -TaskName $Name | Out-Null
            }
    }

# -------------------------------------------------------------

function Synchronize-Me ([HashTable]$Table, [string]$Path)
    {
        $Content = [object[]]::new(0)
        $Table.Keys | Sort-Object | ForEach-Object {$Content += @("$_ = " + $Table[$_])}
        Set-Content -Value $Content -Path $Path -Force
    }

# -------------------------------------------------------------

function Create-Object ([string]$Name, [string]$Type, [HashTable]$Data, [array]$Events, [string]$Control)
    {
        New-Variable -Name $Name -Value (New-Object -TypeName System.Windows.Forms.$Type) -Scope Global -Force

        ForEach ($k in $Data.Keys)
            {
                Invoke-Expression -Command ("`$$Name.$k = " + {$Data.$k})
            }

        ForEach ($i in $Events)
            {
                Invoke-Expression -Command ("`$$Name.$i")
            }

        If ($Control)
            {
                Invoke-Expression -Command ("`$$Control.Controls.Add(`$$Name)")
            }
    }

# -------------------------------------------------------------

function Get-Image ([string]$Path, [string]$Method, [object]$Size)
    {
        $L_Ptr = [System.IntPtr]::new(0)
        $S_Ptr = [System.IntPtr]::new(0)

        If (Test-Path -Path $Path.Split(",")[0])
            {
                If ($Method -eq [Method]::Associate)
                    {
                        $Image = [System.Drawing.Icon]::ExtractAssociatedIcon($Path)
                    }
                ElseIf ($Method -eq [Method]::Extract -and $Path.Contains(","))
                    {
                        [Win32Functions.WinAPI]::ExtractIconEx($Path.Split(",")[0], $Path.Split(",")[-1], [ref]$L_Ptr, [ref]$S_Ptr, 1) | Out-Null
                        $Image = ([System.Drawing.Icon]::FromHandle($S_Ptr)).Clone()
                        [Win32Functions.WinApi]::DestroyIcon($L_Ptr) | Out-Null
                        [Win32Functions.WinApi]::DestroyIcon($S_Ptr) | Out-Null
                    }
                ElseIf ($Method -eq [Method]::Image)
                    {
                        $Image = [System.Drawing.Image]::FromFile($Path)
                    }

                If ($Image)
                    {
                        $Bitmap = [System.Drawing.Bitmap]::new($Size.Width, $Size.Height)
                        $Graphics = [System.Drawing.Graphics]::FromImage($Bitmap)
                        $Graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
                        $Graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
                        $Graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
                        $Graphics.DrawImage($Image,[System.Drawing.Rectangle]::new(0, 0, $Bitmap.Width, $Bitmap.Height))
                        $Image.Dispose()
                    }
            }

        return $Bitmap
    }

# -------------------------------------------------------------

function Change-Background ([string]$Title, [string]$Path, [string]$SearchMask, [ScriptBlock]$Action)
    {
        $ht_Data = @{
            Text = $Title
            Name = "BackgroundForm"
            AutoSize = $true
            AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
            MinimumSize = [System.Drawing.Size]::new(320,20)
            Padding = [System.Windows.Forms.Padding]::new(20)
            StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
            FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
            MaximizeBox = $false
            MinimizeBox = $false
        }

        $ar_Events = @(
            {Add_Load(
                {
                    $MainForm.TopMost = $false
                    $this.TopMost = $true
                }
            )}
            {Add_FormClosing(
                {
                    $this.TopMost = $false
                    $MainForm.TopMost = $true
                }
            )}
        )

        Create-Object -Name BackgroundForm -Type Form -Data $ht_Data -Events $ar_Events

        $Images = Get-ChildItem -Path $Path -Filter $SearchMask -File | Select-Object -ExpandProperty FullName | Sort-Object

        For($i = 0; $i -lt $Images.Count; $i++)
            {
                $X = (20 + (($i % 5) * 70))
                $Y = (20 + ($i * 14) - (($i % 5) * 14))

                $ht_Data = @{
                    TabStop = $false
                    Location = [System.Drawing.Point]::new($X,$Y)
                    Size = [System.Drawing.Size]::new(64,64)
                    ImageLocation = $Images[$i]
                    SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::StretchImage
                    BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
                    BackColor = [System.Drawing.Color]::Transparent
                    Cursor = [System.Windows.Forms.Cursors]::Hand
                }

                $ar_Events = @(
                    {Add_MouseHover({$Tooltip.SetToolTip($this,[System.IO.Path]::GetFileName($this.ImageLocation))})}
                    $Action
                )

                Create-Object -Name PB -Type PictureBox -Data $ht_Data -Events $ar_Events -Control BackgroundForm
            }

        $BackgroundForm.ShowDialog()
        $BackgroundForm.Dispose()
    }

# -------------------------------------------------------------

function Change-Color ([string]$Title, [ScriptBlock]$Action)
    {
        $ht_Data = @{
            Text = $Title
            Name = "ColorForm"
            AutoSize = $true
            AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
            MinimumSize = [System.Drawing.Size]::new(320,20)
            Padding = [System.Windows.Forms.Padding]::new(20)
            StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
            FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
            MaximizeBox = $false
            MinimizeBox = $false
        }

        $ar_Events = @(
            {Add_Load(
                {
                    $MainForm.TopMost = $false
                    $this.TopMost = $true
                }
            )}
            {Add_FormClosing(
                {
                    $this.TopMost = $false
                    $MainForm.TopMost = $true
                }
            )}
        )

        Create-Object -Name ColorForm -Type Form -Data $ht_Data -Events $ar_Events

        $Colors = [System.Drawing.Color].DeclaredProperties | Where-Object {$_.PropertyType -eq [System.Drawing.Color] -and $_.Name -notcontains "Transparent"} | Select-Object -ExpandProperty Name | Sort-Object

        For($i = 0; $i -lt $Colors.Count; $i++)
            {
                $X = (20 + (($i % 10) * 30))
                $Y = (20 + ($i * 3) - (($i % 10) * 3))

                $ht_Data = @{
                    TabStop = $false
                    Location = [System.Drawing.Point]::new($X,$Y)
                    Size = [System.Drawing.Size]::new(24,24)
                    TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
                    BackColor = $Colors[$i]
                    FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
                    'FlatAppearance.BorderColor' = $ColorForm.BackColor
                    Cursor = [System.Windows.Forms.Cursors]::Hand
                }

                $ar_Events = @(
                    {Add_MouseEnter({$this.FlatAppearance.BorderColor = [System.Drawing.Color]::Black})}
                    {Add_MouseLeave({$this.FlatAppearance.BorderColor = $this.Parent.BackColor})}
                    {Add_MouseHover({$Tooltip.SetToolTip($this,$this.BackColor.Name)})}
                    $Action
                )

                Create-Object -Name BT -Type Button -Data $ht_Data -Events $ar_Events -Control ColorForm
            }

        $ColorForm.ShowDialog()
        $ColorForm.Dispose()
    }

# -------------------------------------------------------------

function Change-Font ([string]$Title, [ScriptBlock]$Action)
    {
        $ht_Data = @{
            Text = $Title
            Name = "FontForm"
            AutoSize = $true
            AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
            MinimumSize = [System.Drawing.Size]::new(320,20)
            Padding = [System.Windows.Forms.Padding]::new(20)
            StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
            FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
            MaximizeBox = $false
            MinimizeBox = $false
        }

        $ar_Events = @(
            {Add_Load(
                {
                    $MainForm.TopMost = $false
                    $this.TopMost = $true
                }
            )}
            {Add_FormClosing(
                {
                    $this.TopMost = $false
                    $MainForm.TopMost = $true
                }
            )}
        )

        Create-Object -Name FontForm -Type Form -Data $ht_Data -Events $ar_Events

        $Fonts = [System.Drawing.FontFamily]::Families

        For($i = 0; $i -lt $Fonts.Count; $i++)
            {
                $X = (20 + (($i % 5) * 120))
                $Y = (20 + ($i * 6) - (($i % 5) * 6))

                If ($Fonts[$i].Name.Length -lt 11)
                    {
                        $Sub = $Fonts[$i].Name.Length
                        $Addendum = [string]::Empty
                    }
                Else
                    {
                        $Sub = 8
                        $Addendum = "..."
                    }

                $ht_Data = @{
                    TabStop = $false
                    Location = [System.Drawing.Point]::new($X,$Y)
                    Size = [System.Drawing.Size]::new(114,24)
                    Text = $Fonts[$i].Name.Substring(0,$Sub) + $Addendum
                    TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
                    Font = New-Object -TypeName System.Drawing.Font($Fonts[$i].Name, $Font.Size, $Font.Style)
                    FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
                    BorderStyle = [System.Windows.Forms.BorderStyle]::None
                    BackColor = [System.Drawing.Color]::Transparent
                    Cursor = [System.Windows.Forms.Cursors]::Hand
                }

                $ar_Events = @(
                    {Add_MouseEnter({$this.Font = New-Object -TypeName System.Drawing.Font($this.Font.Name, $this.Font.Size, [System.Drawing.FontStyle]::Underline)})}
                    {Add_MouseLeave({$this.Font = New-Object -TypeName System.Drawing.Font($this.Font.Name, $this.Font.Size, [System.Drawing.FontStyle]::Regular)})}
                    {Add_MouseHover({$Tooltip.SetToolTip($this,$this.Font.Name)})}
                    $Action
                )

                Create-Object -Name LB -Type Label -Data $ht_Data -Events $ar_Events -Control FontForm
            }

        $FontForm.ShowDialog()
        $FontForm.Dispose()
    }

# -------------------------------------------------------------

function Insert-ContextMenuItems ([HashTable]$ItemList)
    {
        $ItemRange = [object[]]::new(0)

        ForEach ($Key in $ItemList.Keys | Sort-Object)
            {
                $ht_Data = @{Name = $Key}

                $ar_Events = [object[]]::new(0)

                If ($ItemList[$Key].ContainsKey("Text"))
                    {
                        $ht_Data.Text = $ItemList[$Key].Text
                    }

                If ($ItemList[$Key].ContainsKey("Image") -and $ItemList[$Key].ContainsKey("Method"))
                    {
                        $ht_Data.Image = Get-Image -Path $ItemList[$Key].Image -Method $ItemList[$Key].Method -Size $CMI.IconSize
                    }

                If ($ItemList[$Key].ContainsKey("Action"))
                    {
                        $ar_Events += @($ItemList[$Key].Action)
                    }

                Create-Object -Name ("CMI_{0}" -f $Key) -Type ToolStripMenuItem -Data $ht_Data -Events $ar_Events

                If ($ItemList[$Key].ContainsKey("Extra"))
                    {
                        Invoke-Expression -Command ("`$CMI_{0} | Add-Member -MemberType NoteProperty -Name Extra -Value `$ItemList[`$Key].Extra -Force" -f $Key)
                    }

                Invoke-Expression -Command ("`$ItemRange += `$CMI_{0}" -f $Key)
            }

        return $ItemRange
}

# -------------------------------------------------------------

function Insert-RadioButtons ([array]$Radios, [object]$Template)
    {
        ForEach ($Item in $Radios | Sort-Object)
            {
                $Count = ($MainForm.Controls | Where-Object {$_.GetType().Name -eq "RadioButton"}).Count

                $ht_Data = @{
                    Left = $Template.Left + $Padding.Width
                    Top = $Template.Top + $Padding.Height * 2 + $Count * 22
                    Text = $Item
                    Name = $Item
                    Appearance = [System.Windows.Forms.Appearance]::Normal
                    Dock = [System.Windows.Forms.DockStyle]::None
                    FlatStyle = [System.Windows.Forms.FlatStyle]::System
                    Width = 90
                }

                $ar_Events = @(
                    {Add_Click(
                        {
                            $MainForm.Controls | Where-Object {$_.GetType().Name -eq "Panel"} | ForEach-Object {If ($_.Name -eq $this.Name) {$_.Show()} Else {$_.Hide()}}
                        }
                    )}
                )

                Create-Object -Name ("RB_{0}" -f $Item) -Type RadioButton -Data $ht_Data -Events $ar_Events -Control MainForm

                Invoke-Expression -Command ("`$RB_$Item.BringToFront()")
            }
    }

# -------------------------------------------------------------

function Insert-Panels ([array]$Panels, [object]$Template)
    {
        ForEach ($Item in $Panels | Sort-Object)
            {
                $ht_Data = @{
                    Location = $Template.Location
                    Size = $Template.Size
                    BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
                    BackColor = [System.Drawing.Color]::FromArgb([int]$Ini.PanelBackColor)
                    Name = $Item
                    AutoScroll = $true
                    BackgroundImage = [System.Drawing.Image]::FromFile($Ini.IconFolder + $Ini.PanelBackground)
                    BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::Stretch
                }

                Create-Object -Name ("PN_{0}" -f $Item) -Type Panel -Data $ht_Data -Control MainForm

                If ($Item -ne [Panels]::Start)
                    {
                        Invoke-Expression -Command ("`$PN_$Item.Hide()")
                    }
            }
    }

# -------------------------------------------------------------

function Insert-Buttons ([HashTable]$Buttons)
    {
        ForEach ($Key in $Buttons.Keys | Sort-Object -Property {$Buttons[$_].Text})
            {
                $ht_Data = @{
                    Name = $Key
                    Font = New-Object -TypeName System.Drawing.Font($Ini.FontName, $Font.Size, $Font.Style)
                    TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
                    FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
                    ForeColor = [System.Drawing.Color]::FromArgb([int]$Ini.ButtonForeColor)
                    BackColor = [System.Drawing.Color]::FromArgb([int]$Ini.ButtonBackColor)
                    'FlatAppearance.MouseOverBackColor' = [System.Drawing.Color]::FromArgb([int]$Ini.ButtonHoverColor)
                    'FlatAppearance.BorderColor' = [System.Drawing.Color]::FromArgb([int]$Ini.ButtonBorderColor)
                    Cursor = [System.Windows.Forms.Cursors]::Hand
                }

                $ar_Events = [object[]]::new(0)

                If ($Buttons[$Key].ContainsKey("Size"))
                    {
                        $ht_Data.Size = $Buttons[$Key].Size
                    }

                If ($Buttons[$Key].ContainsKey("Text"))
                    {
                        $ht_Data.Text = $Buttons[$Key].Text
                    }

                If ($Buttons[$Key].ContainsKey("Image") -and $Buttons[$Key].ContainsKey("Method"))
                    {
                        $ht_Data.Image = Get-Image -Path $Buttons[$Key].Image -Method $Buttons[$Key].Method -Size $Button.IconSize
                        $ht_Data.ImageAlign = [System.Drawing.ContentAlignment]::MiddleLeft
                    }

                If ($Buttons[$Key].ContainsKey("File") -and (Test-Path -Path $Buttons[$Key].File))
                    {
                        $CMD = "Start-Process -FilePath `"" + $Buttons[$Key].File + '"'
                        $TT = $Buttons[$Key].File

                        If ($Buttons[$Key].ContainsKey("Args"))
                            {
                                $CMD += " -ArgumentList `"" + $Buttons[$Key].Args + '"'
                                $TT += [char]32 + $Buttons[$Key].Args
                            }

                        If ($Buttons[$Key].ContainsKey("Dir"))
                            {
                                $CMD += " -WorkingDirectory `"" + $Buttons[$Key].Dir + '"'
                            }

                        New-Variable -Name ("CMD_{0}" -f $Key) -Value $CMD -Scope Global -Force
                        New-Variable -Name ("TT_{0}" -f $Key) -Value $TT -Scope Global -Force

                        $ar_Events += @(
                            {Add_Click(
                                {
                                    $MainForm.ActiveControl = $Logo
                                    Invoke-Expression -Command (Get-Variable -Name ("CMD_{0}" -f $this.Name) -ValueOnly)
                                }
                            )}
                            {Add_MouseHover(
                                {
                                    $Tooltip.SetToolTip($this,(Get-Variable -Name ("TT_{0}" -f $this.Name) -ValueOnly))
                                }
                            )}
                        )
                    }
                ElseIf ($Buttons[$Key].ContainsKey("Tooltip"))
                    {
                        New-Variable -Name ("TT_{0}" -f $Key) -Value $Buttons[$Key].Tooltip -Scope Global -Force

                        $ar_Events += @({Add_MouseHover({$Tooltip.SetToolTip($this,(Get-Variable -Name ("TT_{0}" -f $this.Name) -ValueOnly))})})
                    }

                If ($Buttons[$Key].ContainsKey("ContextMenuStrip"))
                    {
                        $ht_Data.ContextMenuStrip = $Buttons[$Key].ContextMenuStrip

                        $ar_Events += @(
                            {Add_Click(
                                {
                                    $MainForm.ActiveControl = $Logo

                                    If ($_.Button -eq [System.Windows.Forms.MouseButtons]::Left)
                                        {
                                            $Point = [System.Drawing.Point]::new([System.Windows.Forms.Cursor]::Position.X, [System.Windows.Forms.Cursor]::Position.Y)
                                            $this.ContextMenuStrip.Show($this, $this.PointToClient($Point))
                                        }
                                }
                            )}
                        )
                    }

                If ($Buttons[$Key].ContainsKey("Location"))
                    {
                        $Panel = $MainForm.Controls | Where-Object {$_.GetType().Name -eq "Panel" -and $_.Name -eq $Buttons[$Key].Location}
                        $Count = ($Panel.Controls | Where-Object {$_.GetType().Name -eq "Button"}).Count
                        $ht_Data.Location = [System.Drawing.Point]::new($Padding.Width,($Padding.Height + $Count * ($Button.Size.Height + 5)))
                    }

                If ($ht_Data.ContainsKey("Location") -and $ht_Data.ContainsKey("Size") -and $ht_Data.ContainsKey("Text"))
                    {
                        Create-Object -Name ("BT_{0}" -f $Key) -Type Button -Data $ht_Data -Events $ar_Events -Control ("PN_{0}" -f $Buttons[$Key].Location)
                    }
            }
    }

# =============================================================
# ========== ScriptBlocks =====================================
# =============================================================

$ActionLogoBackground = {
    Add_Click({
        $MainForm.Controls['Logo'].BackgroundImage = [System.Drawing.Image]::FromFile($this.ImageLocation)
        $Ini.LogoBackground = [System.IO.Path]::GetFileName($this.ImageLocation)
        Synchronize-Me -Table $Ini -Path $SettingsFile
        $this.Parent.Close()
    })
}

$ActionLogoBackColor = {
    Add_Click({
        $MainForm.Controls['Logo'].BackColor = $this.BackColor
        $Ini.LogoBackColor = $this.BackColor.ToArgb()
        Synchronize-Me -Table $Ini -Path $SettingsFile
        $this.Parent.Close()
    })
}

$ActionPanelBackground = {
    Add_Click({
        $MainForm.Controls | Where-Object {$_.GetType().Name -eq "Panel"} | ForEach-Object {$_.BackgroundImage = [System.Drawing.Image]::FromFile($this.ImageLocation)}
        $Ini.PanelBackground = [System.IO.Path]::GetFileName($this.ImageLocation)
        Synchronize-Me -Table $Ini -Path $SettingsFile
        $this.Parent.Close()
    })
}

$ActionButtonForeColor = {
    Add_Click({
        $Panels = $MainForm.Controls | Where-Object {$_.GetType().Name -eq 'Panel'}
        $Panels.Controls | Where-Object {$_.GetType().Name -eq 'Button'} | ForEach-Object {$_.ForeColor = $this.BackColor}
        $Ini.ButtonForeColor = $this.BackColor.ToArgb()
        Synchronize-Me -Table $Ini -Path $SettingsFile
        $this.Parent.Close()
    })
}

$ActionButtonBackColor = {
    Add_Click({
        $Panels = $MainForm.Controls | Where-Object {$_.GetType().Name -eq 'Panel'}
        $Panels.Controls | Where-Object {$_.GetType().Name -eq 'Button'} | ForEach-Object {$_.BackColor = $this.BackColor}
        $Ini.ButtonBackColor = $this.BackColor.ToArgb()
        Synchronize-Me -Table $Ini -Path $SettingsFile
        $this.Parent.Close()
    })
}

$ActionButtonHoverColor = {
    Add_Click({
        $Panels = $MainForm.Controls | Where-Object {$_.GetType().Name -eq 'Panel'}
        $Panels.Controls | Where-Object {$_.GetType().Name -eq 'Button'} | ForEach-Object {$_.FlatAppearance.MouseOverBackColor = $this.BackColor}
        $Ini.ButtonHoverColor = $this.BackColor.ToArgb()
        Synchronize-Me -Table $Ini -Path $SettingsFile
        $this.Parent.Close()
    })
}

$ActionButtonBorderColor = {
    Add_Click({
        $Panels = $MainForm.Controls | Where-Object {$_.GetType().Name -eq 'Panel'}
        $Panels.Controls | Where-Object {$_.GetType().Name -eq 'Button'} | ForEach-Object {$_.FlatAppearance.BorderColor = $this.BackColor}
        $Ini.ButtonBorderColor = $this.BackColor.ToArgb()
        Synchronize-Me -Table $Ini -Path $SettingsFile
        $this.Parent.Close()
    })
}

$ActionButtonFont = {
    Add_Click({
        $Panels = $MainForm.Controls | Where-Object {$_.GetType().Name -eq 'Panel'}
        $Panels.Controls | Where-Object {$_.GetType().Name -eq 'Button'} | ForEach-Object {$_.Font = New-Object -TypeName System.Drawing.Font($this.Font.Name, $Font.Size, $Font.Style)}
        $Ini.FontName = $this.Font.Name
        Synchronize-Me -Table $Ini -Path $SettingsFile
        $this.Parent.Close()
    })
}

$ActionFormBackColor = {
    Add_Click({
        $MainForm.BackColor = $this.BackColor
        $Ini.FormBackColor = $this.BackColor.ToArgb()
        Synchronize-Me -Table $Ini -Path $SettingsFile
        $this.Parent.Close()
    })
}

$ActionPanelBackColor = {
    Add_Click({
        $MainForm.Controls | Where-Object {$_.GetType().Name -eq 'Panel'} | ForEach-Object {$_.BackColor = $this.BackColor}
        $Ini.PanelBackColor = $this.BackColor.ToArgb()
        Synchronize-Me -Table $Ini -Path $SettingsFile
        $this.Parent.Close()
    })
}

# =============================================================
# ========== Settings.ini =====================================
# =============================================================

$Ini = Initialize-Me -FilePath $SettingsFile

# -------------------------------------------------------------

$Result = Compare-Object -ReferenceObject @($Ini_Bak.Keys) -DifferenceObject @($Ini.Keys) -PassThru

If ($Result)
    {
        $Result | ForEach-Object {If ($_ -notin $Ini.Keys) {$Ini.$_ = $Ini_Bak.$_}}
        Synchronize-Me -Table $Ini -Path $SettingsFile
    }

# =============================================================
# ========== Autostart ========================================
# =============================================================

Register-Autostart -Name Administration -Path $PSCommandPath -Active ([bool][int]$Ini.Autostart)

# =============================================================
# ========== Tooltips =========================================
# =============================================================

Create-Object -Name Tooltip -Type Tooltip

# =============================================================
# ========== SysTrayContextMenuItems ==========================
# =============================================================

$SysTrayContextMenuItems = @{
    a_Restore = @{
        Text = $Txt_List.CMI_a_Restore
        Image = "$env:windir\system32\imageres.dll,228"
        Method = [Method]::Extract
        Action = {Add_Click({$MainForm.ShowDialog()})}
    }
    b_Exit = @{
        Text = $Txt_List.CMI_b_Exit
        Image = "$env:windir\system32\imageres.dll,276"
        Method = [Method]::Extract
        Action = {Add_Click({$Global:AppContext.ExitThread()})}
    }
}

# =============================================================
# ========== ChangeBehaviorContextMenuItems ===================
# =============================================================

$ChangeBehaviorContextMenuItems = @{
    a_SysTray = @{
        Text = $Txt_List.CMI_a_SysTray
        Image = If ([bool][int]$Ini.SysTray) {"$env:windir\system32\imageres.dll,232"} Else {"$env:windir\system32\imageres.dll,229"}
        Method = [Method]::Extract
        Extra = If ([bool][int]$Ini.SysTray) {$true} Else {$false}
        Action = {Add_Click(
            {
                If ($this.Extra)
                    {
                        $this.Image = Get-Image -Path "$env:windir\system32\imageres.dll,229" -Method ([Method]::Extract) -Size $CMI.IconSize
                    }
                Else
                    {
                        $this.Image = Get-Image -Path "$env:windir\system32\imageres.dll,232" -Method ([Method]::Extract) -Size $CMI.IconSize
                    }

                $this.Extra = !($this.Extra)
                $Ini.SysTray = [int]$this.Extra
                Synchronize-Me -Table $Ini -Path $SettingsFile
            }
        )}
    }
    b_Autostart = @{
        Text = $Txt_List.CMI_b_Autostart
        Image = If ([bool][int]$Ini.Autostart) {"$env:windir\system32\imageres.dll,232"} Else {"$env:windir\system32\imageres.dll,229"}
        Method = [Method]::Extract
        Extra = If ([bool][int]$Ini.Autostart) {$true} Else {$false}
        Action = {Add_Click(
            {
                If ($this.Extra)
                    {
                        $this.Image = Get-Image -Path "$env:windir\system32\imageres.dll,229" -Method ([Method]::Extract) -Size $CMI.IconSize
                        Disable-ScheduledTask -TaskName 'Administration' | Out-Null
                    }
                Else
                    {
                        $this.Image = Get-Image -Path "$env:windir\system32\imageres.dll,232" -Method ([Method]::Extract) -Size $CMI.IconSize
                        Enable-ScheduledTask -TaskName 'Administration' | Out-Null
                    }

                $this.Extra = !($this.Extra)
                $Ini.Autostart = [int]$this.Extra
                Synchronize-Me -Table $Ini -Path $SettingsFile
            }
        )}
    }
}

# =============================================================
# ========== ChangeBackgroundContextMenuItems =================
# =============================================================

$ChangeBackgroundContextMenuItems = @{
    a_LogoBack = @{
        Text = $Txt_List.CMI_a_LogoBack
        Image = "$env:windir\system32\imageres.dll,190"
        Method = [Method]::Extract
        Action = {Add_Click({Change-Background -Title $Txt_List.CMI_a_LogoBack -Path $Ini.IconFolder -SearchMask 'Logo*.png' -Action $ActionLogoBackground})}
    }
    b_PanelBack = @{
        Text = $Txt_List.CMI_b_PanelBack
        Image = "$env:windir\system32\imageres.dll,190"
        Method = [Method]::Extract
        Action = {Add_Click({Change-Background -Title $Txt_List.CMI_b_PanelBack -Path $Ini.IconFolder -SearchMask 'Panel*.png' -Action $ActionPanelBackground})}
    }
}

# =============================================================
# ========== ChangeColorContextMenuItems ======================
# =============================================================

$ChangeColorContextMenuItems = @{
    a_FormColor = @{
        Text = $Txt_List.CMI_a_FormColor
        Image = "$env:windir\system32\imageres.dll,186"
        Method = [Method]::Extract
        Action = {Add_Click({Change-Color -Title $Txt_List.CMI_a_FormColor -Action $ActionFormBackColor})}
    }
    b_LogoColor = @{
        Text = $Txt_List.CMI_b_LogoColor
        Image = "$env:windir\system32\imageres.dll,186"
        Method = [Method]::Extract
        Action = {Add_Click({Change-Color -Title $Txt_List.CMI_b_LogoColor -Action $ActionLogoBackColor})}
    }
    c_PanelColor = @{
        Text = $Txt_List.CMI_c_PanelColor
        Image = "$env:windir\system32\imageres.dll,186"
        Method = [Method]::Extract
        Action = {Add_Click({Change-Color -Title $Txt_List.CMI_c_PanelColor -Action $ActionPanelBackColor})}
    }
    d_TextColor = @{
        Text = $Txt_List.CMI_d_TextColor
        Image = "$env:windir\system32\imageres.dll,186"
        Method = [Method]::Extract
        Action = {Add_Click({Change-Color -Title $Txt_List.CMI_d_TextColor -Action $ActionButtonForeColor})}
    }
    e_BackColor = @{
        Text = $Txt_List.CMI_e_BackColor
        Image = "$env:windir\system32\imageres.dll,186"
        Method = [Method]::Extract
        Action = {Add_Click({Change-Color -Title $Txt_List.CMI_e_BackColor -Action $ActionButtonBackColor})}
    }
    f_HoverColor = @{
        Text = $Txt_List.CMI_f_HoverColor
        Image = "$env:windir\system32\imageres.dll,186"
        Method = [Method]::Extract
        Action = {Add_Click({Change-Color -Title $Txt_List.CMI_f_HoverColor -Action $ActionButtonHoverColor})}
    }
    g_BorderColor = @{
        Text = $Txt_List.CMI_g_BorderColor
        Image = "$env:windir\system32\imageres.dll,186"
        Method = [Method]::Extract
        Action = {Add_Click({Change-Color -Title $Txt_List.CMI_g_BorderColor -Action $ActionButtonBorderColor})}
    }
}

# =============================================================
# ========== ChangeFontContextMenuItems =======================
# =============================================================

$ChangeFontContextMenuItems = @{
    a_ButtonFont = @{
        Text = $Txt_List.CMI_a_ButtonFont
        Image = "$env:windir\system32\imageres.dll,122"
        Method = [Method]::Extract
        Action = {Add_Click({Change-Font -Title $Txt_List.CMI_a_ButtonFont -Action $ActionButtonFont})}
    }
}

# =============================================================
# ========== HDDRepairContextMenuItems ========================
# =============================================================

$HDDRepairContextMenuItems = [HashTable]::new()

ForEach($i in Get-PSDrive | Where-Object {$_.Free})
    {
        $HDDRepairContextMenuItems += @{
            $i.Name = @{
                Text = $Txt_List.CMI_a_HDDRepair -f $i.Name
                Image = "$env:windir\system32\mycomput.dll,1"
                Method = [Method]::Extract
                Action = {Add_Click({Invoke-Expression -Command ("Start-Process -FilePath `"$env:windir\system32\cmd.exe`" -ArgumentList `"/k chkdsk {0}: /f /r /x`"" -f $this.Name)})}
            }
        }
    }

# =============================================================
# ========== WinRepairContextMenuItems ========================
# =============================================================

$WinRepairContextMenuItems = @{
    a_SFC = @{
        Text = $Txt_List.CMI_a_SFC
        Image = "$env:windir\system32\mycomput.dll,0"
        Method = [Method]::Extract
        Action = {Add_Click({Invoke-Expression -Command ("Start-Process -FilePath `"$env:windir\system32\cmd.exe`" -ArgumentList `"/k sfc /scannow`" -WorkingDirectory `"$env:windir\system32`"")})}
    }
    b_DISM = @{
        Text = $Txt_List.CMI_b_DISM
        Image = "$env:windir\system32\mycomput.dll,0"
        Method = [Method]::Extract
        Action = {Add_Click({Invoke-Expression -Command ("Start-Process -FilePath `"$env:windir\system32\cmd.exe`" -ArgumentList `"/k dism /Online /Cleanup-Image /RestoreHealth`" -WorkingDirectory `"$env:windir\system32`"")})}
    }
}

# =============================================================
# ========== Insertions: SysTrayContextMenuItems ==============
# =============================================================

$ItemRange = Insert-ContextMenuItems -ItemList $SysTrayContextMenuItems

# =============================================================
# ========== SysTrayContextMenu ===============================
# =============================================================

$ht_Data = @{Cursor = [System.Windows.Forms.Cursors]::Hand}

$ar_Events = @({Items.AddRange(@($ItemRange))})

Create-Object -Name SysTrayContextMenu -Type ContextMenuStrip -Data $ht_Data -Events $ar_Events

# =============================================================
# ========== Insertions: ChangeBehaviorContextMenuItems =======
# =============================================================

$ItemRange = Insert-ContextMenuItems -ItemList $ChangeBehaviorContextMenuItems

# =============================================================
# ========== ChangeBehaviorContextMenu ========================
# =============================================================

$ar_Events = @({Items.AddRange(@($ItemRange))})

Create-Object -Name ChangeBehaviorContextMenu -Type ContextMenuStrip -Data $ht_Data -Events $ar_Events

# =============================================================
# ========== Insertions: ChangeBackgroundContextMenuItems =====
# =============================================================

$ItemRange = Insert-ContextMenuItems -ItemList $ChangeBackgroundContextMenuItems

# =============================================================
# ========== ChangeBackgroundContextMenu ======================
# =============================================================

$ar_Events = @({Items.AddRange(@($ItemRange))})

Create-Object -Name ChangeBackgroundContextMenu -Type ContextMenuStrip -Data $ht_Data -Events $ar_Events

# =============================================================
# ========== Insertions: ChangeColorContextMenuItems ==========
# =============================================================

$ItemRange = Insert-ContextMenuItems -ItemList $ChangeColorContextMenuItems

# =============================================================
# ========== ChangeColorContextMenu ===========================
# =============================================================

$ar_Events = @({Items.AddRange(@($ItemRange))})

Create-Object -Name ChangeColorContextMenu -Type ContextMenuStrip -Data $ht_Data -Events $ar_Events

# =============================================================
# ========== Insertions: ChangeFontContextMenuItems ===========
# =============================================================

$ItemRange = Insert-ContextMenuItems -ItemList $ChangeFontContextMenuItems

# =============================================================
# ========== ChangeFontContextMenu ============================
# =============================================================

$ar_Events = @({Items.AddRange(@($ItemRange))})

Create-Object -Name ChangeFontContextMenu -Type ContextMenuStrip -Data $ht_Data -Events $ar_Events

# =============================================================
# ========== Insertions: HDDRepairContextMenuItems ============
# =============================================================

$ItemRange = Insert-ContextMenuItems -ItemList $HDDRepairContextMenuItems

# =============================================================
# ========== HDDRepairContextMenu =============================
# =============================================================

$ar_Events = @({Items.AddRange(@($ItemRange))})

Create-Object -Name HDDRepairContextMenu -Type ContextMenuStrip -Data $ht_Data -Events $ar_Events

# =============================================================
# ========== Insertions: WinRepairContextMenuItems ============
# =============================================================

$ItemRange = Insert-ContextMenuItems -ItemList $WinRepairContextMenuItems

# =============================================================
# ========== WinRepairContextMenu =============================
# =============================================================

$ar_Events = @({Items.AddRange(@($ItemRange))})

Create-Object -Name WinRepairContextMenu -Type ContextMenuStrip -Data $ht_Data -Events $ar_Events

# =============================================================
# ========== Buttons-List =====================================
# =============================================================

$Buttons_List = @{
    TaskScheduler = @{
        Size = $Button.Size
        Text = $Txt_List.BT_TaskScheduler
        Location = [Panels]::Verwaltung
        Image = "$env:windir\system32\taskschd.msc"
        Method = [Method]::Associate
        File = "$env:windir\system32\taskschd.msc"
        Args = "/s"
        Dir = "$env:windir\system32"
        }
    Cmd = @{
        Size = $Button.Size
        Text = $Txt_List.BT_Cmd
        Location = [Panels]::Cmd
        Image = "$env:windir\system32\cmd.exe"
        Method = [Method]::Associate
        File = "$env:windir\system32\cmd.exe"
        Dir = "$env:windir\system32"
        }
    Cmd_help = @{
        Size = $Button.Size
        Text = $Txt_List.BT_Cmd_help
        Location = [Panels]::Cmd
        Image = "$env:windir\system32\cmd.exe"
        Method = [Method]::Associate
        File = "$env:windir\system32\cmd.exe"
        Args = "/k help"
        Dir = "$env:windir\system32"
        }
    Cmd_HDDRepair = @{
        Size = $Button.Size
        Text = $Txt_List.BT_Cmd_HDDRepair
        Location = [Panels]::Cmd
        Image = "$env:windir\system32\cmd.exe"
        Method = [Method]::Associate
        ContextMenuStrip = $HDDRepairContextMenu
        Tooltip = $Txt_List.TT_Cmd_HDDRepair
        }
    Cmd_ver = @{
        Size = $Button.Size
        Text = $Txt_List.BT_Cmd_ver
        Location = [Panels]::Cmd
        Image = "$env:windir\system32\cmd.exe"
        Method = [Method]::Associate
        File = "$env:windir\system32\cmd.exe"
        Args = "/k ver"
        Dir = "$env:windir\system32"
        }
    Cmd_ipconfig = @{
        Size = $Button.Size
        Text = $Txt_List.BT_Cmd_ipconfig
        Location = [Panels]::Cmd
        Image = "$env:windir\system32\cmd.exe"
        Method = [Method]::Associate
        File = "$env:windir\system32\cmd.exe"
        Args = "/k ipconfig"
        Dir = "$env:windir\system32"
        }
    Cmd_flushdns = @{
        Size = $Button.Size
        Text = $Txt_List.BT_Cmd_flushdns
        Location = [Panels]::Cmd
        Image = "$env:windir\system32\cmd.exe"
        Method = [Method]::Associate
        File = "$env:windir\system32\cmd.exe"
        Args = "/k ipconfig /flushdns"
        Dir = "$env:windir\system32"
        }
    Cmd_WinRepair = @{
        Size = $Button.Size
        Text = $Txt_List.BT_Cmd_WinRepair
        Location = [Panels]::Cmd
        Image = "$env:windir\system32\cmd.exe"
        Method = [Method]::Associate
        ContextMenuStrip = $WinRepairContextMenu
        Tooltip = $Txt_List.TT_Cmd_WinRepair
        }
    DiskManagement = @{
        Size = $Button.Size
        Text = $Txt_List.BT_DiskManagement
        Location = [Panels]::Verwaltung
        Image = "$env:windir\system32\diskmgmt.msc"
        Method = [Method]::Associate
        File = "$env:windir\system32\diskmgmt.msc"
        Dir = "$env:windir\system32"
        }
    DirectXDiagnosis = @{
        Size = $Button.Size
        Text = $Txt_List.BT_DirectXDiagnosis
        Location = [Panels]::Tools
        Image = "$env:windir\system32\dxdiag.exe"
        Method = [Method]::Associate
        File = "$env:windir\system32\dxdiag.exe"
        Dir = "$env:windir\system32"
        }
    ImmersiveControlPanel = @{
        Size = $Button.Size
        Text = $Txt_List.BT_ImmersiveControlPanel
        Location = [Panels]::UWP
        Image = (Get-AppxPackage -Name "*immersivecontrolpanel*" | Select-Object -ExpandProperty InstallLocation -First 1) + "\SystemSettings.exe"
        Method = [Method]::Associate
        File = "$env:windir\explorer.exe"
        Args = "shell:AppsFolder\" + (Get-StartApps -Name "*Einstellungen*" | Select-Object -ExpandProperty AppID -First 1)
        }
    PowerConfiguration = @{
        Size = $Button.Size
        Text = $Txt_List.BT_PowerConfiguration
        Location = [Panels]::Verwaltung
        Image = "$env:windir\system32\powercpl.dll,0"
        Method = [Method]::Extract
        File = "$env:windir\system32\powercfg.cpl"
        Dir = "$env:windir\system32"
        }
    EventViewer = @{
        Size = $Button.Size
        Text = $Txt_List.BT_EventViewer
        Location = [Panels]::Monitor
        Image = "$env:windir\system32\eventvwr.msc"
        Method = [Method]::Associate
        File = "$env:windir\system32\eventvwr.msc"
        Args = "/s"
        Dir = "$env:windir\system32"
        }
    DeviceManager = @{
        Size = $Button.Size
        Text = $Txt_List.BT_DeviceManager
        Location = [Panels]::Verwaltung
        Image = "$env:windir\system32\devmgr.dll,5"
        Method = [Method]::Extract
        File = "$env:windir\system32\hdwwiz.cpl"
        Dir = "$env:windir\system32"
        }
    GroupPolicyEditor = @{
        Size = $Button.Size
        Text = $Txt_List.BT_GroupPolicyEditor
        Location = [Panels]::Verwaltung
        Image = "$env:windir\system32\imageres.dll,74"
        Method = [Method]::Extract
        File = "$env:windir\system32\gpedit.msc"
        Dir = "$env:windir\system32"
        }
    NvidiaControlPanel = @{
        Size = $Button.Size
        Text = $Txt_List.BT_NvidiaControlPanel
        Location = [Panels]::UWP
        Image = (Get-AppxPackage -Name "*NVIDIAControlPanel*" | Select-Object -ExpandProperty InstallLocation -First 1) + "\nvcplui.exe"
        Method = [Method]::Associate
        File = "$env:windir\explorer.exe"
        Args = "shell:AppsFolder\" + (Get-StartApps -Name "*NVIDIA Control Panel*" | Select-Object -ExpandProperty AppID -First 1)
        }
    RealtekAudioConsole = @{
        Size = $Button.Size
        Text = $Txt_List.BT_RealtekAudioConsole
        Location = [Panels]::UWP
        Image = Get-ChildItem -Path ((Get-AppxPackage -Name "*RealtekAudioControl*" | Select-Object -ExpandProperty InstallLocation -First 1) + "\Assets\") -Filter "*.png" -File | Select-Object -ExpandProperty FullName -First 1
        Method = [Method]::Image
        File = "$env:windir\explorer.exe"
        Args = "shell:AppsFolder\" + (Get-StartApps -Name "*Realtek Audio Console*" | Select-Object -ExpandProperty AppID -First 1)
        }
    RegistryEditor = @{
        Size = $Button.Size
        Text = $Txt_List.BT_RegistryEditor
        Location = [Panels]::Tools
        Image = "$env:windir\regedit.exe"
        Method = [Method]::Associate
        File = "$env:windir\regedit.exe"
        Dir = "$env:windir"
        }
    PerformanceMonitor = @{
        Size = $Button.Size
        Text = $Txt_List.BT_PerformanceMonitor
        Location = [Panels]::Monitor
        Image = "$env:windir\system32\wdc.dll,4"
        Method = [Method]::Extract
        File = "$env:windir\system32\perfmon.exe"
        Dir = "$env:windir\system32"
        }
    ResourceMonitor = @{
        Size = $Button.Size
        Text = $Txt_List.BT_ResourceMonitor
        Location = [Panels]::Monitor
        Image = "$env:windir\system32\perfmon.exe"
        Method = [Method]::Associate
        File = "$env:windir\system32\perfmon.exe"
        Args = "/res"
        Dir = "$env:windir\system32"
        }
    ReliabilityMonitor = @{
        Size = $Button.Size
        Text = $Txt_List.BT_ReliabilityMonitor
        Location = [Panels]::Monitor
        Image = "$env:windir\system32\ActionCenterCPL.dll,0"
        Method = [Method]::Extract
        File = "$env:windir\system32\perfmon.exe"
        Args = "/rel"
        Dir = "$env:windir\system32"
        }
    AppsFolder = @{
        Size = $Button.Size
        Text = $Txt_List.BT_AppsFolder
        Location = [Panels]::Shell
        Image = "$env:windir\system32\imageres.dll,7"
        Method = [Method]::Extract
        File = "$env:windir\explorer.exe"
        Args = "shell:AppsFolder"
        }
    ChangeRemoveProgramsFolder = @{
        Size = $Button.Size
        Text = $Txt_List.BT_ChangeRemoveProgramsFolder
        Location = [Panels]::Shell
        Image = "$env:windir\system32\imageres.dll,82"
        Method = [Method]::Extract
        File = "$env:windir\explorer.exe"
        Args = "shell:ChangeRemoveProgramsFolder"
        }
    ConnectionsFolder = @{
        Size = $Button.Size
        Text = $Txt_List.BT_ConnectionsFolder
        Location = [Panels]::Shell
        Image = "$env:windir\system32\netcenter.dll,3"
        Method = [Method]::Extract
        File = "$env:windir\explorer.exe"
        Args = "shell:ConnectionsFolder"
        }
    PrintersFolder = @{
        Size = $Button.Size
        Text = $Txt_List.BT_PrintersFolder
        Location = [Panels]::Shell
        Image = "$env:windir\system32\imageres.dll,21"
        Method = [Method]::Extract
        File = "$env:windir\explorer.exe"
        Args = "shell:PrintersFolder"
        }
    RecycleBinFolder = @{
        Size = $Button.Size
        Text = $Txt_List.BT_RecycleBinFolder
        Location = [Panels]::Shell
        Image = "$env:windir\system32\imageres.dll,50"
        Method = [Method]::Extract
        File = "$env:windir\explorer.exe"
        Args = "shell:RecycleBinFolder"
        }
    SearchHomeFolder = @{
        Size = $Button.Size
        Text = $Txt_List.BT_SearchHomeFolder
        Location = [Panels]::Shell
        Image = "$env:windir\system32\imageres.dll,13"
        Method = [Method]::Extract
        File = "$env:windir\explorer.exe"
        Args = "shell:SearchHomeFolder"
        }
    AppUpdatesFolder = @{
        Size = $Button.Size
        Text = $Txt_List.BT_AppUpdatesFolder
        Location = [Panels]::Shell
        Image = "$env:windir\system32\imageres.dll,141"
        Method = [Method]::Extract
        File = "$env:windir\explorer.exe"
        Args = "shell:AppUpdatesFolder"
        }
    UsersLibrariesFolder = @{
        Size = $Button.Size
        Text = $Txt_List.BT_UsersLibrariesFolder
        Location = [Panels]::Shell
        Image = "$env:windir\system32\imageres.dll,117"
        Method = [Method]::Extract
        File = "$env:windir\explorer.exe"
        Args = "shell:UsersLibrariesFolder"
        }
    ComputerManagement = @{
        Size = $Button.Size
        Text = $Txt_List.BT_ComputerManagement
        Location = [Panels]::Verwaltung
        Image = "$env:windir\system32\Mycomput.dll,2"
        Method = [Method]::Extract
        File = "$env:windir\system32\compmgmt.msc"
        Args = "/s"
        Dir = "$env:windir\system32"
        }
    SystemProperties = @{
        Size = $Button.Size
        Text = $Txt_List.BT_SystemProperties
        Location = [Panels]::Verwaltung
        Image = "$env:windir\system32\sysdm.cpl"
        Method = [Method]::Associate
        File = "$env:windir\system32\sysdm.cpl"
        Dir = "$env:windir\system32"
        }
    MSConfiguration = @{
        Size = $Button.Size
        Text = $Txt_List.BT_MSConfiguration
        Location = [Panels]::Verwaltung
        Image = "$env:windir\system32\msconfig.exe"
        Method = [Method]::Associate
        File = "$env:windir\system32\msconfig.exe"
        Dir = "$env:windir\system32"
        }
    ControlPanel = @{
        Size = $Button.Size
        Text = $Txt_List.BT_ControlPanel
        Location = [Panels]::Verwaltung
        Image = "$env:windir\system32\imageres.dll,22"
        Method = [Method]::Extract
        File = "$env:windir\system32\control.exe"
        Dir = "$env:windir\system32"
        }
    TaskManager = @{
        Size = $Button.Size
        Text = $Txt_List.BT_TaskManager
        Location = [Panels]::Tools
        Image = "$env:windir\system32\taskmgr.exe"
        Method = [Method]::Associate
        File = "$env:windir\system32\taskmgr.exe"
        Dir = "$env:windir\system32"
        }
    AdministrativeTools = @{
        Size = $Button.Size
        Text = $Txt_List.BT_AdministrativeTools
        Location = [Panels]::Verwaltung
        Image = "$env:windir\system32\imageres.dll,109"
        Method = [Method]::Extract
        File = "$env:windir\system32\control.exe"
        Args = "/name Microsoft.AdministrativeTools"
        Dir = "$env:windir\system32"
        }
    DriveOptimizer = @{
        Size = $Button.Size
        Text = $Txt_List.BT_DriveOptimizer
        Location = [Panels]::Tools
        Image = "$env:windir\system32\dfrgui.exe"
        Method = [Method]::Associate
        File = "$env:windir\system32\dfrgui.exe"
        Dir = "$env:windir\system32"
        }
    RecoveryDrive = @{
        Size = $Button.Size
        Text = $Txt_List.BT_RecoveryDrive
        Location = [Panels]::Tools
        Image = "$env:windir\system32\imageres.dll,31"
        Method = [Method]::Extract
        File = "$env:windir\system32\RecoveryDrive.exe"
        Dir = "$env:windir\system32"
        }
    MemoryDiagnosisScheduler = @{
        Size = $Button.Size
        Text = $Txt_List.BT_MemoryDiagnosisScheduler
        Location = [Panels]::Tools
        Image = "$env:windir\system32\imageres.dll,29"
        Method = [Method]::Extract
        File = "$env:windir\system32\MdSched.exe"
        Dir = "$env:windir\system32"
        }
    ChangeColor = @{
        Size = $Button.Size
        Text = $Txt_List.BT_ChangeColor
        Location = [Panels]::Settings
        Image = "$env:windir\system32\colorcpl.exe"
        Method = [Method]::Associate
        ContextMenuStrip = $ChangeColorContextMenu
        }
    ChangeBackground = @{
        Size = $Button.Size
        Text = $Txt_List.BT_ChangeBackground
        Location = [Panels]::Settings
        Image = "$env:windir\system32\imageres.dll,67"
        Method = [Method]::Extract
        ContextMenuStrip = $ChangeBackgroundContextMenu
        }
    ChangeBehavior = @{
        Size = $Button.Size
        Text = $Txt_List.BT_ChangeBehavior
        Location = [Panels]::Settings
        Image = "$env:windir\system32\imageres.dll,63"
        Method = [Method]::Extract
        ContextMenuStrip = $ChangeBehaviorContextMenu
        }
    ChangeFont = @{
        Size = $Button.Size
        Text = $Txt_List.BT_ChangeFont
        Location = [Panels]::Settings
        Image = "$env:windir\system32\imageres.dll,118"
        Method = [Method]::Extract
        ContextMenuStrip = $ChangeFontContextMenu
        }
}

# =============================================================
# ========== MainForm =========================================
# =============================================================

$ht_Data = @{
    ClientSize = $Form.Size
    StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    Icon = $Ini.IconFolder + "Administration.ico"
    Text = $Txt_List.MainForm
    BackColor = [System.Drawing.Color]::FromArgb([int]$Ini.FormBackColor)
    FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
    TopMost = $true
    MaximizeBox = $false
}

$ar_Events = @(
    {Add_Load(
        {
            $this.ActiveControl = $Logo
            $SysIcon.Visible = $false
            [Win32Functions.WinAPI]::ShowWindowAsync($this.Handle, 1)
        }
    )}

    {Add_FormClosing(
        {
            If ([bool][int]$Ini.SysTray)
                {
                    $SysIcon.Visible = $true
                }
            Else
                {
                    $SysIcon.Visible = $false
                    $Global:AppContext.ExitThread()
                }
        }
    )}
)

Create-Object -Name MainForm -Type Form -Data $ht_Data -Events $ar_Events

# =============================================================
# ========== Logo =============================================
# =============================================================

$ht_Data = @{
    ImageLocation = $Ini.IconFolder + "Icon_Logo.png"
    Location = $Rects.A.Location
    Size = $Rects.A.Size
    SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Normal
    Name = "Logo"
    BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
    BackgroundImage = [System.Drawing.Image]::FromFile($Ini.IconFolder + $Ini.LogoBackground)
    BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::Stretch
    BackColor = [System.Drawing.Color]::FromArgb([int]$Ini.LogoBackColor)
}

Create-Object -Name Logo -Type PictureBox -Data $ht_Data -Control MainForm

# =============================================================
# ========== Settings =========================================
# =============================================================

$ht_Data = @{
    Location = $Rects.C.Location
    Size = $Rects.C.Size
    Font = New-Object -TypeName System.Drawing.Font($Fonts[$Font.Index].Name, $Font.Size, $Font.Style)
    Text = $Txt_List.Settings
    Name = [Panels]::Settings
    TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
    Cursor = [System.Windows.Forms.Cursors]::Hand
}

$ar_Events = @(
    {Add_Click(
        {
            $MainForm.Controls | Where-Object {$_.GetType().Name -eq "Panel"} | ForEach-Object {If ($_.Name -eq $this.Name) {$_.Show()} Else {$_.Hide()}}
            $MainForm.Controls | Where-Object {$_.GetType().Name -eq "RadioButton"} | ForEach-Object {$_.Checked = $false}
            $MainForm.ActivateControl($PN_Settings)
        }
    )}
    {Add_MouseEnter(
        {
            $this.Font = New-Object -TypeName System.Drawing.Font($this.Font.Name, $this.Font.Size, [System.Drawing.FontStyle]::Underline)
        }
    )}
    {Add_MouseLeave(
        {
            $this.Font = New-Object -TypeName System.Drawing.Font($this.Font.Name, $this.Font.Size, [System.Drawing.FontStyle]::Regular)
        }
    )}
)

Create-Object -Name Settings -Type Label -Data $ht_Data -Events $ar_Events -Control MainForm

# =============================================================
# ========== Group-Box ========================================
# =============================================================

$ht_Data = @{
    Location = $Rects.B.Location
    Size = $Rects.B.Size
    Text = $Txt_List.GB
}

Create-Object -Name GB -Type GroupBox -Data $ht_Data -Control MainForm

# =============================================================
# ========== SysIcon ==========================================
# =============================================================

$ht_Data = @{
    Text = $Txt_List.SysIcon
    Icon = $Ini.IconFolder + "Administration.ico"
    ContextMenuStrip = $SysTrayContextMenu
}

$ar_Events = @(
    {Add_Click(
        {
            If ($_.Button -eq [System.Windows.Forms.MouseButtons]::Left)
                {
                    $this.GetType().GetMethod("ShowContextMenu",[System.Reflection.BindingFlags]::Instance -bor [System.Reflection.BindingFlags]::NonPublic).Invoke($this,$null)
                }
        }
    )}
)

Create-Object -Name SysIcon -Type NotifyIcon -Data $ht_Data -Events $ar_Events

# =============================================================
# ========== Insertions: RadioButtons =========================
# =============================================================

Insert-RadioButtons -Radios ([Radios].GetEnumNames()) -Template $Rects.B

# =============================================================
# ========== Insertions: Panels ===============================
# =============================================================

Insert-Panels -Panels ([Panels].GetEnumNames()) -Template $Rects.D

# =============================================================
# ========== Insertions: Buttons ==============================
# =============================================================

Insert-Buttons -Buttons $Buttons_List

# =============================================================
# ========== Start ============================================
# =============================================================

If ('/Autostart' -in $args -and [bool][int]$Ini.SysTray)
    {
        $SysIcon.Visible = $true
    }
Else
    {
        $MainForm.ShowDialog()
    }

If ([bool][int]$Ini.SysTray)
    {
        [void][System.Windows.Forms.Application]::Run($Global:AppContext)
    }

# =============================================================
# ========== Clean-Up =========================================
# =============================================================

$SysIcon.Dispose()
$MainForm.Dispose()
$Global:AppContext.Dispose()
[System.GC]::Collect()