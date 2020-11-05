# Get the username
$USERNAME = $env:INPUT_USERNAME

# Get the password
$PASSWORD = $env:INPUT_PASSWORD

# Get the container name
$NAME = $env:INPUT_NAME

# Get the current version
$CURRENT = $env:INPUT_CURRENT

# Build the credentials
$CREDENTIAL = New-Object pscredential $USERNAME, (ConvertTo-SecureString -String $PASSWORD -AsPlainText -Force)

# Get the workspace
$WORKSPACE = $env:GITHUB_WORKSPACE

# Check if we should validate against current
if ($CURRENT -eq "") {
    # Get the content as JSON
    $AppSourceCop = Get-Content -Path "$WORKSPACE\AppSourceCop.json" | ConvertFrom-Json

    # Remove the version flag
    $AppSourceCop.PSObject.Properties.Remove('version')

    # Save the file back as JSON
    $AppSourceCop | ConvertTo-Json -Depth 100 | Out-File "$WORKSPACE\AppSourceCop.json" -Force
} else {
    # Get the content as JSON
    $AppSourceCop = Get-Content -Path "$WORKSPACE\AppSourceCop.json" | ConvertFrom-Json

    # Check if the property exists
    if ($AppSourceCop.version -eq $nil) {
        # Add the current version to the file
        $AppSourceCop | Add-Member -Name "version" -Value $CURRENT -MemberType NoteProperty
    } else {
        # Update the version property
        $AppSourceCop.version = $CURRENT
    }

    # Save the file back as JSON
    $AppSourceCop | ConvertTo-Json -Depth 100 | Out-File "$WORKSPACE\AppSourceCop.json" -Force
}

# Compile the application
Compile-AppInBCContainer `
    -containerName $NAME `
    -credential $CREDENTIAL `
    -appProjectFolder $WORKSPACE `
    -appOutputFolder $WORKSPACE `
    -updateSymbols `
    -copyAppToSymbolsFolder `
    -enableAppSourceCop `
    -rulesetFile "$WORKSPACE\goldenedi.ruleset.json" `

# Get the app file
$APP = (Get-ChildItem -Path $WORKSPACE -File "*.app").FullName

# Export variables
Write-Host "::set-output name=app::$APP"
