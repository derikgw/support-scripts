# Setting JAVA_HOME temporarily for the session
$env:JAVA_HOME = "C:\Users\Derik\.jdks\corretto-17.0.10"

# Define the log entries
$logEntries = @(
    "C:\Program Files\SmartBear\SoapUI-5.7.2\lib\ant-junit-1.10.8.jar",
    "C:\Program Files\SmartBear\SoapUI-5.7.2\lib\groovy-3.0.6.jar",
    "C:\Program Files\SmartBear\SoapUI-5.7.2\lib\junit-4.13.1.jar",
    "C:\Program Files\SmartBear\SoapUI-5.7.2\lib\testng-7.3.0.jar"
)

# Initialize an array to hold the dependency XML snippets
$dependenciesXml = @()

foreach ($entry in $logEntries) {
    # Extract the JAR file name
    $jarFileName = Split-Path $entry -Leaf
    # Assuming the format before the version is artifactId and the groupId is constant
    $artifactId = $jarFileName -split "-" | Select-Object -First 1
    $groupId = "org.soapui" # Replace with your actual groupId

    # Try to extract version number from the file name
    $version = if ($jarFileName -match "\d+\.\d+(\.\d+)?") {
        $matches[0]
    } else {
        "1.0.0"
    }

    # Construct the Maven command
    $mavenCmd = "cmd /c '" +
                "mvn install:install-file " +
                "-Dfile=`"$entry`" " +
                "-DgroupId=$groupId " +
                "-DartifactId=$artifactId " +
                "-Dversion=$version " +
                "-Dpackaging=jar " +
                "-DgeneratePom=true" +
                "'"

    Write-Host "Executing: $mavenCmd"
    # Execute the Maven command
    Invoke-Expression $mavenCmd

    # Add the dependency to the array
    $dependencyXml = @"
        <dependency>
            <groupId>$groupId</groupId>
            <artifactId>$artifactId</artifactId>
            <version>$version</version>
        </dependency>
"@
    $dependenciesXml += $dependencyXml
}

# Combine the dependencies into a single string
$dependenciesSection = "    <dependencies>`n" + ($dependenciesXml -join "`n`n") + "`n    </dependencies>"

# Output the dependencies XML snippet to a file
$dependenciesSection | Out-File -FilePath "dependencies.xml"

Write-Host "Wrote dependencies.xml"
