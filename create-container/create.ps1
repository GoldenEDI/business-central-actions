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

# Check if we got a URL
if (($INPUT_LICENSE_URL -ne $nil) -and ($INPUT_LICENSE_URL -ne "")) {
    # Check if the url contains information on if this is an FLF file or bclicense, default to flf.
    if ($INPUT_LICENSE_URL -like "*bclicense") {
        $LICENSE_FILE = "$WORKSPACE/License.bclicense"    
    } else {
        $LICENSE_FILE = "$WORKSPACE/License.flf" 
    }

    # Download the license file
    Invoke-WebRequest -Uri $INPUT_LICENSE_URL -OutFile $LICENSE_FILE
} elseif (($LICENSE_DATA -ne $nil) -and ($LICENSE_DATA -ne "")) {
    # Path to the license file
    $LICENSE_FILE = "$WORKSPACE/License.flf"

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
