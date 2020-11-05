# Get the certificate data
$CERTIFICATE_DATA = $env:INPUT_CERTIFICATE

# Get the password
$PASSWORD = $env:INPUT_PASSWORD | ConvertTo-SecureString -AsPlainText -Force

# Get the container name
$CONTAINER = $env:INPUT_CONTAINER

# Get the app to sign
$APP = $env:INPUT_APP

# Get the workspace
$WORKSPACE = $env:GITHUB_WORKSPACE

# Path to the license file
$CERTIFICATE = "$WORKSPACE/SigningCert.pfx"

# Decode and create the license file
[IO.File]::WriteAllBytes($CERTIFICATE, [Convert]::FromBase64String($CERTIFICATE_DATA))

# Sign the app
Sign-BCContainerApp -containerName $CONTAINER -appFile $APP -pfxFile $CERTIFICATE -pfxPassword $PASSWORD

# Export the app
Write-Host "::set-output name=app::$APP"
