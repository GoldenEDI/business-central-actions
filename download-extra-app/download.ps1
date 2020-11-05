# Get the URL
$URI = $env:INPUT_URL

# Get the target file name
$NAME = $env:INPUT_NAME

# Get the workspace
$WORKSPACE = $env:GITHUB_WORKSPACE

# Download the file
Invoke-WebRequest -Uri $URI -OutFile "$WORKSPACE/$Name" -Force

# Export the URL
Write-Host "::set-output name=app::$WORKSPACE/$Name"
