@echo off
title Vibe Code Project
color 0B
chcp 65001 >nul 2>&1
call :header
echo    Press any key to launch this app...
pause >nul

set "_ps=%TEMP%\~jvcp_%RANDOM%.ps1"
powershell -ExecutionPolicy Bypass -Command "$s=[IO.File]::ReadAllText('%~f0');$t='# --- PS_START';$m=$s.LastIndexOf($t);$s=$s.Substring($m);[IO.File]::WriteAllText('%_ps%',$s)"
cls
call :header
echo    App is running...
echo.
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "%_ps%"
goto :eof

:header
echo.
echo   +========================================================+
echo   :              A Vibe Coding Project                     : 
echo   +========================================================+
echo.
echo    Goal         : Lightweight portable web launcher, works offline, runs anywhere on Windows 7+
echo    Built For    : Portable solution for restricted or corporate lockdowns Windows machines 
echo    Crafted With : Visual Studio Code, AI Tools
echo.
goto :eof

# --- PS_START ---
$_me=$MyInvocation.MyCommand.Path
Add-Type -Name W -Namespace H -MemberDefinition '[DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h,int c);[DllImport("kernel32.dll")] public static extern IntPtr GetConsoleWindow();'
$cw=[H.W]::GetConsoleWindow();if($cw -ne [IntPtr]::Zero){[H.W]::ShowWindow($cw,0)|Out-Null}
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()
try {
  $n=[System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName|Split-Path -Leaf
  $r='HKCU:\Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION'
  if(!(Test-Path $r)){New-Item -Path $r -Force|Out-Null}
  Set-ItemProperty -Path $r -Name $n -Value 11001 -Type DWord
  $r2='HKCU:\Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_96DPI_PIXEL'
  if(!(Test-Path $r2)){New-Item -Path $r2 -Force|Out-Null}
  Set-ItemProperty -Path $r2 -Name $n -Value 1 -Type DWord
  $r3='HKCU:\Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_GPU_RENDERING'
  if(!(Test-Path $r3)){New-Item -Path $r3 -Force|Out-Null}
  Set-ItemProperty -Path $r3 -Name $n -Value 1 -Type DWord
} catch {}
# --- FLAGS ---
$showNavBar = $false
$debugMode = $false
$allowDrop = $false
$showContextMenu = $false
$allowShortcuts = $false
$suppressScriptErrors = $true
# --- FLAGS ---

$bg=[Drawing.SystemColors]::Control
$fg=[Drawing.SystemColors]::ControlText
$accent=[Drawing.Color]::FromArgb(0,120,215)
$accentHover=[Drawing.Color]::FromArgb(30,150,245)
$fieldBg=[Drawing.SystemColors]::Window
$borderCol=[Drawing.SystemColors]::ControlDark
$fontUI=New-Object Drawing.Font('Segoe UI',10)
$fontTitle=New-Object Drawing.Font('Segoe UI',16,[Drawing.FontStyle]::Bold)
$fontBtn=New-Object Drawing.Font('Segoe UI',11,[Drawing.FontStyle]::Bold)
$fontSmall=New-Object Drawing.Font('Segoe UI',8)
$f=New-Object Windows.Forms.Form
$f.Text=""
$f.Width=540;$f.Height=340
$f.StartPosition='CenterScreen'
$f.FormBorderStyle='FixedDialog'
$f.MaximizeBox=$false
$f.Font=$fontUI
$f.Icon=[Drawing.SystemIcons]::Application
$title=New-Object Windows.Forms.Label
$title.Text="Portable-Powershell-Html-Launcher"
$title.Font=$fontTitle;$title.ForeColor=$accent
$title.Location=New-Object Drawing.Point(20,15)
$title.AutoSize=$true
$f.Controls.Add($title)
$sep=New-Object Windows.Forms.Label
$sep.Height=1;$sep.Width=490
$sep.Location=New-Object Drawing.Point(20,55)
$sep.BackColor=$borderCol
$f.Controls.Add($sep)
$l=New-Object Windows.Forms.Label
$l.Text='Enter Valid URL or Browse for a local HTML file:'
$l.Location=New-Object Drawing.Point(20,70)
$l.ForeColor=[Drawing.SystemColors]::GrayText
$l.AutoSize=$true
$f.Controls.Add($l)
$t=New-Object Windows.Forms.TextBox
$t.Location=New-Object Drawing.Point(20,100)
$t.Width=390;$t.Height=30;$t.Font=$fontUI
$t.BorderStyle='FixedSingle'
$f.Controls.Add($t)
$bb=New-Object Windows.Forms.Button
$bb.Text='Browse...';$bb.Location=New-Object Drawing.Point(420,98)
$bb.Width=90;$bb.Height=30;$bb.FlatStyle='Flat'
$bb.FlatAppearance.BorderColor=$borderCol
$bb.Cursor='Hand'
$bb.Add_MouseEnter({$bb.BackColor=[Drawing.SystemColors]::ControlLight})
$bb.Add_MouseLeave({$bb.BackColor=[Drawing.SystemColors]::Control})
$bb.Add_Click({
  $d=New-Object Windows.Forms.OpenFileDialog
  $d.Filter='HTML Files (*.html;*.htm)|*.html;*.htm|All Files (*.*)|*.*'
  if($d.ShowDialog() -eq 'OK'){$t.Text=$d.FileName}
})
$f.Controls.Add($bb)
$lb=New-Object Windows.Forms.Button
$lb.Text='Launch';$lb.Location=New-Object Drawing.Point(20,150)
$lb.Width=490;$lb.Height=38;$lb.Font=$fontBtn
$lb.FlatStyle='Flat';$lb.FlatAppearance.BorderSize=0
$lb.BackColor=$accent;$lb.ForeColor=[Drawing.Color]::White;$lb.Cursor='Hand'
$lb.Add_MouseEnter({$this.BackColor=$accentHover})
$lb.Add_MouseLeave({$this.BackColor=$accent})
$f.AcceptButton=$lb
$script:sel=$null
$lb.Add_Click({
  $v=$t.Text.Trim()
  if($v -eq ''){[Windows.Forms.MessageBox]::Show('Please enter a URL or browse for an HTML file.','Input Required','OK','Warning');return}
  if(!(Test-Path $v) -and $v -notmatch '^https?://'){[Windows.Forms.MessageBox]::Show('File not found and not a valid URL.','Error','OK','Warning');return}
  $script:sel=$v
  $f.Close()
})
$f.Controls.Add($lb)
$sep2=New-Object Windows.Forms.Label
$sep2.Height=1;$sep2.Width=490
$sep2.Location=New-Object Drawing.Point(20,200);$sep2.BackColor=$borderCol
$f.Controls.Add($sep2)
$info=New-Object Windows.Forms.Label
$info.Text="DISCLAIMER: This tool renders content using the built-in Windows WebBrowser`ncontrol (IE engine). Use at your own risk. No warranty is provided.`nThe authors are not responsible for any content loaded or any damages arising from use."
$info.Font=$fontSmall;$info.ForeColor=[Drawing.SystemColors]::GrayText
$info.Location=New-Object Drawing.Point(20,215)
$info.Size=New-Object Drawing.Size(490,55)
$f.Controls.Add($info)
$sep3=New-Object Windows.Forms.Label
$sep3.Height=1;$sep3.Width=490
$sep3.Location=New-Object Drawing.Point(20,270);$sep3.BackColor=$borderCol
$f.Controls.Add($sep3)
$footer=New-Object Windows.Forms.Label
$footer.Text="Jasper | 2026 | 1.0.1"
$footer.Font=$fontSmall;$footer.ForeColor=[Drawing.SystemColors]::GrayText
$footer.Location=New-Object Drawing.Point(20,275);$footer.Size=New-Object Drawing.Size(490,45)
$f.Controls.Add($footer)
[Windows.Forms.Application]::Run($f)
if(!$script:sel){exit}
$ti=if($script:sel -match '^https?://'){$script:sel}else{[IO.Path]::GetFileName($script:sel)}
$w=New-Object Windows.Forms.Form
$w.Text=$ti;$w.Width=1024;$w.Height=768
$w.StartPosition='CenterScreen'
$w.Icon=[Drawing.SystemIcons]::Application
$nav=New-Object Windows.Forms.Panel
$nav.Dock='Top';$nav.Height=40
$nav.BackColor=[Drawing.SystemColors]::ControlDarkDark
$nav.Visible=$showNavBar
$w.Controls.Add($nav)
$btnBack=New-Object Windows.Forms.Button
$btnBack.Text='<';$btnBack.Width=36;$btnBack.Height=30
$btnBack.Location=New-Object Drawing.Point(5,5)
$btnBack.FlatStyle='Flat';$btnBack.FlatAppearance.BorderSize=0
$btnBack.BackColor=[Drawing.SystemColors]::ControlDarkDark
$btnBack.ForeColor=[Drawing.Color]::White;$btnBack.Cursor='Hand'
$btnBack.Font=New-Object Drawing.Font('Segoe UI',10)
$nav.Controls.Add($btnBack)
$btnFwd=New-Object Windows.Forms.Button
$btnFwd.Text='>';$btnFwd.Width=36;$btnFwd.Height=30
$btnFwd.Location=New-Object Drawing.Point(42,5)
$btnFwd.FlatStyle='Flat';$btnFwd.FlatAppearance.BorderSize=0
$btnFwd.BackColor=[Drawing.SystemColors]::ControlDarkDark
$btnFwd.ForeColor=[Drawing.Color]::White;$btnFwd.Cursor='Hand'
$btnFwd.Font=New-Object Drawing.Font('Segoe UI',10)
$nav.Controls.Add($btnFwd)
$urlBar=New-Object Windows.Forms.TextBox
$urlBar.Location=New-Object Drawing.Point(85,8)
$urlBar.Width=820;$urlBar.Height=26;$urlBar.Font=$fontUI
$urlBar.BorderStyle='FixedSingle';$urlBar.ReadOnly=$true
$urlBar.Text=$script:sel
$nav.Controls.Add($urlBar)
$urlBar.Anchor='Top,Left,Right'

$b=New-Object Windows.Forms.WebBrowser
$b.Dock='Fill'
$b.ScriptErrorsSuppressed=if($debugMode){$false}else{$suppressScriptErrors}
$b.AllowWebBrowserDrop=$allowDrop
$b.IsWebBrowserContextMenuEnabled=$showContextMenu
$b.WebBrowserShortcutsEnabled=$allowShortcuts
$b.Navigate($script:sel)
$b.Add_DocumentCompleted({
  try {
    if($b.ReadyState -ne 'Complete'){return}
    $b.Document.InvokeScript('eval',@('document.body.style.zoom="100%";document.body.style.overflow="auto";document.body.style.width="100%";document.body.style.margin="0";document.documentElement.style.overflow="auto"'))
  } catch {}
})
$b.Add_DocumentTitleChanged({$w.Text=$b.DocumentTitle})
$b.Add_Navigated({$urlBar.Text=$b.Url.ToString()})
$btnBack.Add_Click({if($b.CanGoBack){$b.GoBack()}})
$btnFwd.Add_Click({if($b.CanGoForward){$b.GoForward()}})
$w.Controls.Add($b)
$b.BringToFront
[Windows.Forms.Application]::Run($w)
try{Remove-Item $_me -Force -ErrorAction SilentlyContinue}catch{}
