# ==============================================================================
# 🚀 Y-ChatApp Automated Setup for AWS Windows Server 2022/2025
# ==============================================================================

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "   🚀 Installing Y-ChatApp on AWS Windows Server  " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

# 1. Open Windows Firewall ports (80, 8080, 3306)
Write-Host "🛡️ Opening Firewall ports for HTTP & Web..." -ForegroundColor Yellow
New-NetFirewallRule -DisplayName "YChat Web Port 80" -Direction Inbound -LocalPort 80 -Protocol TCP -Action Allow -ErrorAction SilentlyContinue
New-NetFirewallRule -DisplayName "YChat Tomcat Port 8080" -Direction Inbound -LocalPort 8080 -Protocol TCP -Action Allow -ErrorAction SilentlyContinue

# 2. Setup Working Directory
$installDir = "C:\ychat-server"
New-Item -ItemType Directory -Path $installDir -Force | Out-Null
Set-Location $installDir

# 3. Install Chocolatey if not present
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "📦 Installing Chocolatey package manager..." -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# 4. Install OpenJDK 21 & MySQL
Write-Host "☕ Installing OpenJDK 21 & MySQL..." -ForegroundColor Yellow
choco install openjdk21 mysql -y --no-progress

# 5. Download and Extract Apache Tomcat 10.1
$tomcatZip = "$installDir\tomcat10.zip"
$tomcatUrl = "https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.24/bin/apache-tomcat-10.1.24-windows-x64.zip"

if (-not (Test-Path "$installDir\apache-tomcat-10.1.24")) {
    Write-Host "🐱 Downloading Apache Tomcat 10.1..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $tomcatUrl -OutFile $tomcatZip -UseBasicParsing
    Expand-Archive -Path $tomcatZip -DestinationPath $installDir -Force
    Remove-Item $tomcatZip -Force
}

$tomcatHome = "$installDir\apache-tomcat-10.1.24"

# 6. Copy Y-ChatApp WAR file from redirected local drive
Write-Host "🚀 Copying Y-ChatApp WAR file..." -ForegroundColor Yellow
$localWar = "\\tsclient\C\pleiades-2025-12-ultimate-win-64bit-jre_20251214\workspace\ychatApp\target\ychatApp-1.0.0.war"

if (Test-Path $localWar) {
    Remove-Item "$tomcatHome\webapps\*" -Recurse -Force -ErrorAction SilentlyContinue
    Copy-Item -Path $localWar -Destination "$tomcatHome\webapps\ROOT.war" -Force
    Write-Host "✅ Copied ychatApp as ROOT.war successfully!" -ForegroundColor Green
} else {
    Write-Host "⚠️ Local WAR not found at $localWar, please place ROOT.war in $tomcatHome\webapps" -ForegroundColor Red
}

# 7. Start Tomcat
Write-Host "🚀 Starting Tomcat server on Port 8080..." -ForegroundColor Cyan
Start-Process "$tomcatHome\bin\startup.bat"

Write-Host "==================================================" -ForegroundColor Green
Write-Host "🎉 Y-ChatApp Windows Server Setup Complete!" -ForegroundColor Green
Write-Host "🌐 Access URL: http://localhost:8080/" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
