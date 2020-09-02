# Get the artifact
$ARTIFACT = $env:INPUT_ARTIFACT

# Get the username
$USERNAME = $env:INPUT_USERNAME

# Get the password
$PASSWORD = $env:INPUT_PASSWORD

# Get the container name
$NAME = $env:INPUT_NAME

# Get the workspace folder
$WORKSPACE = $env:GITHUB_WORKSPACE

# Build the credentials
$CREDENTIAL = New-Object pscredential $USERNAME, (ConvertTo-SecureString -String $PASSWORD -AsPlainText -Force)

# Create the container
New-BCContainer -accept_eula -containerName $NAME -artifactUrl $ARTIFACT -Credential $CREDENTIAL -auth UserPassword -updateHosts -additionalParameters @("--volume $WORKSPACE`:c:\project")

# Export variables
Write-Host "::set-output name=name::$NAME"