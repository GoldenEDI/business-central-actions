# Get the artifact
$ARTIFACT = $env:INPUT_ARTIFACT

# Get the username
$USERNAME = $env:INPUT_USERNAME

# Get the password
$PASSWORD = $env:INPUT_PASSWORD

# Get the container name
$NAME = $env:INPUT_NAME

# Get the license file data (base64 encoded)
$LICENSE_DATA = $env:INPUT_LICENSE

# Get the workspace folder
$WORKSPACE = $env:GITHUB_WORKSPACE

if (($LICENSE_DATA -ne $nil) -and ($LICENSE_DATA -ne "")) {
    # Path to the license file
    if (($INPUT_LICENSE_IS_FLF -ne $nil) -and ($INPUT_LICENSE_IS_FLF -ne "")) {
        $LICENSE_FILE = "$WORKSPACE/License.flf"
    } else {
        $LICENSE_FILE = "$WORKSPACE/License.bclicense"
    }

    # Decode and create the license file
    [IO.File]::WriteAllBytes($LICENSE_FILE, [Convert]::FromBase64String($LICENSE_DATA))
}

# Build the credentials
$CREDENTIAL = New-Object pscredential $USERNAME, (ConvertTo-SecureString -String $PASSWORD -AsPlainText -Force)

if (($LICENSE_FILE -ne $nil) -and ($LICENSE_FILE -ne "")) {
    # Create the container
    New-BCContainer -accept_eula -containerName $NAME -artifactUrl $ARTIFACT -Credential $CREDENTIAL -auth UserPassword -updateHosts -additionalParameters @("--volume $WORKSPACE`:c:\project") -licenseFile $LICENSE_FILE
} else {
    # Create the container without license
    New-BCContainer -accept_eula -containerName $NAME -artifactUrl $ARTIFACT -Credential $CREDENTIAL -auth UserPassword -updateHosts -additionalParameters @("--volume $WORKSPACE`:c:\project")
}

# Export variables
Write-Host "::set-output name=name::$NAME"
