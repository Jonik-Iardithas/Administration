# ========== Initialization ===================================

[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null
[System.Windows.Forms.Application]::EnableVisualStyles()
[System.Drawing.FontFamily]::Families | ForEach-Object {$Fonts += @($_)}

# ========== Variables ========================================

$Offset = 0
$Padding = 10
$FontIndex = $Fonts.Name.IndexOf('Verdana')
$FontSize = 9
$FontStyle = [System.Drawing.FontStyle]::Regular
$FormSize = [System.Drawing.Size]::new(378,286)
$ButtonSizeA = [System.Drawing.Size]::new(280,28)
$ButtonSizeB = [System.Drawing.Size]::new(68,28)
$ButtonBackColor = [System.Drawing.Color]::PaleGoldenrod
$ButtonMouseOverBackColor = [System.Drawing.Color]::LightGoldenrodYellow
$L_Ptr = [System.IntPtr]::new(0)
$S_Ptr = [System.IntPtr]::new(0)
$SettingsFile = "$env:LOCALAPPDATA\PowerShellTools\Administration\Settings.ini"

$MB_List = @{
    Ini_01 = "Konnte Datei {0} nicht finden."
    Ini_02 = "Administration: Fehler!"
}

# ========== Functions ========================================

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

# ========== Win32Functions ===================================

$Member = @'
    [DllImport("Shell32.dll", EntryPoint = "ExtractIconExW", CharSet = CharSet.Unicode, ExactSpelling = true, CallingConvention = CallingConvention.StdCall)]
    public static extern int ExtractIconEx(string lpszFile, int nIconIndex, out IntPtr phiconLarge, out IntPtr phiconSmall, int nIcons);

    [DllImport("User32.dll", EntryPoint = "DestroyIcon")]
    public static extern bool DestroyIcon(IntPtr hIcon);
'@

Add-Type -MemberDefinition $Member -Name WinAPI -Namespace Win32Functions

# ========== Buttons ==========================================

$Buttons = @{
    "DirectX-Diagnoseprogramm" = @{
        Size = $ButtonSizeA
        Location = "Left"
        Image = "$env:windir\system32\dxdiag.exe|0"
        File = "$env:windir\system32\dxdiag.exe"
        Dir = "$env:windir\system32"
        }
    "Geräte-Manager" = @{
        Size = $ButtonSizeA
        Location = "Left"
        Image = "$env:windir\system32\devmgr.dll|5"
        File = "$env:windir\system32\hdwwiz.cpl"
        Dir = "$env:windir\system32"
        }
    "Gruppenrichtlinien" = @{
        Size = $ButtonSizeA
        Location = "Left"
        Image = "$env:windir\system32\imageres.dll|74"
        File = "$env:windir\system32\gpedit.msc"
        Dir = "$env:windir\system32"
        }
    "Registrierungs-Editor" = @{
        Size = $ButtonSizeA
        Location = "Left"
        Image = "$env:windir\regedit.exe|0"
        File = "$env:windir\regedit.exe"
        Dir = "$env:windir"
        }
    "Systemeigenschaften" = @{
        Size = $ButtonSizeA
        Location = "Left"
        Image = "$env:windir\system32\sysdm.cpl|0"
        File = "$env:windir\system32\sysdm.cpl"
        Dir = "$env:windir\system32"
        }
    "Systemsteuerung" = @{
        Size = $ButtonSizeA
        Location = "Left"
        Image = "$env:windir\system32\imageres.dll|22"
        File = "$env:windir\system32\control.exe"
        Dir = "$env:windir\system32"
        }
    "Task-Manager" = @{
        Size = $ButtonSizeA
        Location = "Left"
        Image = "$env:windir\system32\imageres.dll|139"
        File = "$env:windir\system32\taskmgr.exe"
        Dir = "$env:windir\system32"
        }
    "Verwaltungsprogramme" = @{
        Size = $ButtonSizeA
        Location = "Left"
        Image = "$env:windir\system32\imageres.dll|109"
        File = "$env:windir\system32\control.exe"
        Args = '"/name Microsoft.AdministrativeTools"'
        Dir = "$env:windir\system32"
        }
    "Exit" = @{
        Size = $ButtonSizeB
        Location = "Right"
        Exit = $true
        }
}

# ========== Paths ============================================

$Paths = Initialize-Me -FilePath $SettingsFile

# ========== Form =============================================

$Form = New-Object -TypeName System.Windows.Forms.Form
$Form.ClientSize = $FormSize
$Form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$Form.Icon = $Paths.IconFolder + "Administration.ico"
$Form.Text = "Administration"
$Form.BackColor = [System.Drawing.Color]::LightSkyBlue
$Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$Form.MaximizeBox = $false

# ========== Logo =============================================

$Logo = New-Object -TypeName System.Windows.Forms.PictureBox
$Logo.ImageLocation = $Paths.IconFolder + "Administration.ico"
$Logo.Size = [System.Drawing.Size]::new(([System.Drawing.Image]::FromFile($Logo.ImageLocation).Width + 4),([System.Drawing.Image]::FromFile($Logo.ImageLocation).Height + 4))
$Logo.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Normal
$Logo.Location = [System.Drawing.Point]::new(($Form.ClientSize.Width - $Padding - $Logo.Size.Width), $Padding)
$Logo.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
$Form.Controls.Add($Logo)
$Form.ActiveControl = $Logo

# ========== Insertions =======================================

ForEach ($Key in $Buttons.Keys | Sort-Object)
    {
        $Button = New-Object -TypeName System.Windows.Forms.Button
        $Button.Size = $Buttons[$Key].Size
        $Button.Font = New-Object -TypeName System.Drawing.Font($Fonts[$FontIndex].Name, $FontSize, $FontStyle)
        $Button.Text = [string]$Key
        $Button.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
        $Button.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
        $Button.BackColor = $ButtonBackColor
        $Button.FlatAppearance.MouseOverBackColor = $ButtonMouseOverBackColor
        $Button.Cursor = [System.Windows.Forms.Cursors]::Hand

        If ($Buttons[$Key].ContainsKey("Location"))
            {
                If($Buttons[$Key].Location -eq "Left")
                    {
                        $Button.Location = [System.Drawing.Point]::new($Padding,$Padding + $Offset)
                        $Offset += ($ButtonSizeA.Height + 6)
                    }
                ElseIf ($Buttons[$Key].Location -eq "Right")
                    {
                        $Button.Location = [System.Drawing.Point]::new($FormSize.Width - $ButtonSizeB.Width - $Padding,$FormSize.Height - $ButtonSizeB.Height - $Padding)
                    }
            }

        If ($Buttons[$Key].ContainsKey("Image"))
            {
                If (Test-Path -Path $Buttons[$Key].Image.ToString().Split("|")[0])
                    {
                        [Win32Functions.WinAPI]::ExtractIconEx($Buttons[$Key].Image.ToString().Split("|")[0], $Buttons[$Key].Image.ToString().Split("|")[-1], [ref]$L_Ptr, [ref]$S_Ptr, 1) | Out-Null
                        $Button.Image = [System.Drawing.Icon]::FromHandle($S_Ptr)
                        $Button.ImageAlign = [System.Drawing.ContentAlignment]::MiddleLeft
                        [Win32Functions.WinApi]::DestroyIcon($L_Ptr) | Out-Null
                        [Win32Functions.WinApi]::DestroyIcon($S_Ptr) | Out-Null
                    }
            }

        If ($Buttons[$Key].ContainsKey("File"))
            {
                If (Test-Path -Path $Buttons[$Key].File)
                    {
                        $Button.Add_Click(
                            {
                                $Form.ActiveControl = $Logo

                                $Cmd = "Start-Process -FilePath " + [string]$Buttons[$this.Text].File

                                If ($Buttons[$this.Text].ContainsKey("Args"))
                                    {
                                        $Cmd += " -ArgumentList " + [string]$Buttons[$this.Text].Args
                                    }

                                If ($Buttons[$this.Text].ContainsKey("Dir"))
                                    {
                                        $Cmd += " -WorkingDirectory " + [string]$Buttons[$this.Text].Dir
                                    }

                                Invoke-Expression $Cmd
                            })
                    }
                Else
                    {
                        $Button.Enabled = $false
                    }
            }

        If ($Buttons[$Key].ContainsKey("Exit"))
            {
                If ($Buttons[$Key].Exit)
                    {
                        $Form.CancelButton = $Button
                    }
            }

        
        $Form.Controls.Add($Button)
    }

# ========== Start ============================================

$Form.ShowDialog()