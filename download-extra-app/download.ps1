# Get the URL
$URI = $env:INPUT_URI

# Get the target file name
$NAME = $env:INPUT_NAME

# Get the workspace
$WORKSPACE = $env:GITHUB_WORKSPACE

# Create directory
New-Item -ItemType Directory -Path (Split-Path "$WORKSPACE/$Name") -Force

# Download the file
Invoke-WebRequest -Uri $URI -OutFile "$WORKSPACE/$Name"

# Export the URL
Write-Host "::set-output name=app::$WORKSPACE/$Name"
