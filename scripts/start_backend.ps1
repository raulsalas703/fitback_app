$root = Split-Path -Parent $PSScriptRoot

$authDir = Join-Path $root "microservices\auth_service"
$workoutDir = Join-Path $root "microservices\workout_service"
$logDir = Join-Path $root "logs"

New-Item -ItemType Directory -Path $logDir -Force | Out-Null

foreach ($dir in @($authDir, $workoutDir)) {
  if (-not (Test-Path (Join-Path $dir "node_modules"))) {
    Write-Host "Instalando dependencias en $dir ..."
    Push-Location $dir
    npm install --no-fund --no-audit
    Pop-Location
  }
}

function Test-Service($port) {
  try {
    Invoke-RestMethod -Uri "http://localhost:$port/health" -Method Get -TimeoutSec 2 | Out-Null
    return $true
  } catch {
    return $false
  }
}

function Ensure-Service([string]$name, [int]$port, [string]$dir) {
  if (Test-Service $port) {
    Write-Host "[$name] ya esta corriendo en el puerto $port"
    return
  }

  $out = Join-Path $logDir "$name.log"
  $err = Join-Path $logDir "$name.err.log"

  Start-Process -FilePath "node" -ArgumentList "index.js" -WorkingDirectory $dir -WindowStyle Hidden -RedirectStandardOutput $out -RedirectStandardError $err

  for ($i = 0; $i -lt 20; $i++) {
    Start-Sleep -Milliseconds 500
    if (Test-Service $port) {
      Write-Host "[$name] iniciado en el puerto $port"
      return
    }
  }

  Write-Host "[$name] ERROR: no respondio en el puerto $port. Revisa logs\$name.err.log" -ForegroundColor Red
}

Ensure-Service "auth_service" 3001 $authDir
Ensure-Service "workout_service" 3002 $workoutDir

Write-Host "Backend listo."
