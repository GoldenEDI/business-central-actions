# Get the artifact country
$COUNTRY = $env:INPUT_COUNTRY

# Get the version
$VERSION = $env:INPUT_VERSION

# Get the type
$TYPE = $env:INPUT_TYPE

# Get the select variable
$SELECT = $env:INPUT_SELECT

Get-ChildItem env:

# Get the artifact URL
if ($SELECT -eq "") {
    $ARTIFACT_URL = Get-BCArtifactUrl -country $COUNTRY -type $TYPE -version $VERSION
} else {
    $ARTIFACT_URL = Get-BCArtifactUrl -country $COUNTRY -type $TYPE -version $VERSION -select $SELECT
}

# Download the artifact
Download-Artifacts -artifactUrl $ARTIFACT_URL

# Export the URL
Write-Host "::set-output name=artifact::$ARTIFACT_URL"