# Get the username
$USERNAME = $env:INPUT_USERNAME

# Get the password
$PASSWORD = $env:INPUT_PASSWORD

# Get the container name
$NAME = $env:INPUT_NAME

# Get the compiled app path
$APP = $env:INPUT_APP

# Build the credentials
$CREDENTIAL = New-Object pscredential $USERNAME, (ConvertTo-SecureString -String $PASSWORD -AsPlainText -Force)

# Install the app
Publish-BCContainerApp `
    -containerName $NAME `
    -appFile $APP `
    -credential $CREDENTIAL `
    -skipVerification `
    -sync `
    -syncMode ForceSync `
    -install

# Export variables
Write-Host "::set-output name=app::$APP"