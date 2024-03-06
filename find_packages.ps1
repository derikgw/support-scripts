# Set JAVA_HOME
$env:JAVA_HOME = "C:\Users\Derik\.jdks\corretto-17.0.10"

# Define the directory to search for JAR files
$directoryToSearch = "C:\Program Files\SmartBear\SoapUI-5.7.2\lib"
$packageName = "TestRunner" # Partial or full package name to search for

# Generate a unique file name using the current date and time for the report
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$fileName = "JarSearchResults_$timestamp.txt"
# Store the report in the same directory as the script
$filePath = Join-Path -Path $PSScriptRoot -ChildPath $fileName

# Recursively find all jar files in the specified directory
$jarFiles = Get-ChildItem -Path $directoryToSearch -Filter *.jar -Recurse

# Initialize the output file
"" | Out-File -FilePath $filePath

foreach ($jarFile in $jarFiles) {
    # Use the jar tool to list contents of each jar file and search for the package name
    $jarContents = & "$($env:JAVA_HOME)\bin\jar.exe" -tf $jarFile.FullName | Where-Object { $_ -match $packageName.Replace('.', '/') }

    if ($jarContents) {
        # Print the path of the JAR file
        "Found in $($jarFile.FullName):" | Out-File -FilePath $filePath -Append
        foreach ($content in $jarContents) {
            # Extract and print the package name in package format
            $packageNameFormat = $content -replace "/", "." -replace "\.class$", ""
            "    $packageNameFormat" | Out-File -FilePath $filePath -Append
        }
    }
}

Write-Output "Search results have been saved to $filePath"
