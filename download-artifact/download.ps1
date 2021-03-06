# Get the artifact country
$COUNTRY = $env:INPUT_COUNTRY

# Get the version
$VERSION = $env:INPUT_VERSION

# Get the type
$TYPE = $env:INPUT_TYPE

# Get the select variable
$SELECT = $env:INPUT_SELECT

# Get the token
$TOKEN = $env:INPUT_TOKEN

# Get the artifact URL
if ($SELECT -eq "") {
    $ARTIFACT_URL = Get-BCArtifactUrl -country $COUNTRY -type $TYPE -version $VERSION -sasToken $TOKEN
} else {
    $ARTIFACT_URL = Get-BCArtifactUrl -country $COUNTRY -type $TYPE -version $VERSION -select $SELECT -sasToken $TOKEN
}

# Download the artifact
Download-Artifacts -artifactUrl $ARTIFACT_URL

# Export the URL
Write-Host "::set-output name=artifact::$ARTIFACT_URL"
