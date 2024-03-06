# Define the log entries
$logEntries = @(
    "C:\Program Files\SmartBear\SoapUI-5.7.2\lib\ant-junit-1.10.8.jar",
    "C:\Program Files\SmartBear\SoapUI-5.7.2\lib\groovy-3.0.6.jar",
    "C:\Program Files\SmartBear\SoapUI-5.7.2\lib\junit-4.13.1.jar",
    "C:\Program Files\SmartBear\SoapUI-5.7.2\lib\testng-7.3.0.jar"
)

foreach ($entry in $logEntries) {
    # Extract the JAR file name
    $jarFileName = Split-Path $entry -Leaf
    # Assuming the format before the version is artifactId and the groupId is constant
    $artifactId = $jarFileName -split "-" | Select-Object -First 1
    $groupId = "com.example" # Replace with your actual groupId

    # Try to extract version number from the file name
    $version = if ($jarFileName -match "\d+\.\d+(\.\d+)?") {
        $matches[0]
    } else {
        "1.0.0"
    }

    # Construct the Maven command
    $mavenCmd = "mvn install:install-file " +
                "-Dfile=`"$entry`" " +
                "-DgroupId=$groupId " +
                "-DartifactId=$artifactId " +
                "-Dversion=$version " +
                "-Dpackaging=jar " +
                "-DgeneratePom=true"

    Write-Host "Executing: $mavenCmd"
    # Execute the Maven command
    Invoke-Expression $mavenCmd
}
