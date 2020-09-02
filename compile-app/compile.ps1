# Get the username
$USERNAME = $env:INPUT_USERNAME

# Get the password
$PASSWORD = $env:INPUT_PASSWORD

# Get the container name
$NAME = $env:INPUT_NAME

# Build the credentials
$CREDENTIAL = New-Object pscredential $USERNAME, (ConvertTo-SecureString -String $PASSWORD -AsPlainText -Force)

# Get the workspace
$WORKSPACE = $env:GITHUB_WORKSPACE

# Compile the application
Compile-AppInBCContainer `
    -containerName $NAME `
    -credential $CREDENTIAL `
    -appProjectFolder $WORKSPACE `
    -appOutputFolder $WORKSPACE `
    -updateSymbols `
    -copyAppToSymbolsFolder `
    -enableAppSourceCop `
    -rulesetFile "$WORKSPACE/goldenedi.ruleset.json" `

# Get the app file
$APP = (Get-ChildItem -Path $WORKSPACE -File "*.app").FullName

# Export variables
Write-Host "::set-output name=app::$APP"