import os
import subprocess

# Setting JAVA_HOME temporarily for the session
os.environ['JAVA_HOME'] = "C:\\Users\\Derik\\.jdks\\corretto-17.0.10"

# Define the log entries
log_entries = [
    "C:\\Program Files\\SmartBear\\SoapUI-5.7.2\\lib\\ant-junit-1.10.8.jar",
    "C:\\Program Files\\SmartBear\\SoapUI-5.7.2\\lib\\groovy-3.0.6.jar",
    "C:\\Program Files\\SmartBear\\SoapUI-5.7.2\\lib\\junit-4.13.1.jar",
    "C:\\Program Files\\SmartBear\\SoapUI-5.7.2\\lib\\testng-7.3.0.jar"
]


# Initialize dependencies XML snippet
dependencies_xml = "    <dependencies>"

for entry in log_entries:
    # Extract the JAR file name
    jar_file_name = os.path.basename(entry)
    # Assuming the format before the version is artifactId and the groupId is constant
    artifact_id = jar_file_name.split("-")[0]
    group_id = "org.soapui"  # Replace with your actual groupId

    # Try to extract version number from the file name
    import re
    version_match = re.search(r"\d+\.\d+(\.\d+)?", jar_file_name)
    version = version_match.group(0) if version_match else "1.0.0"

    # Append dependency to the dependencies XML snippet
    dependencies_xml += f"""        
        <dependency>
            <groupId>{group_id}</groupId>
            <artifactId>{artifact_id}</artifactId>
            <version>{version}</version>
        </dependency>
    """

    # Construct the Maven command
    maven_cmd = f'mvn install:install-file -Dfile="{entry}" -DgroupId={group_id} -DartifactId={artifact_id} -Dversion={version} -Dpackaging=jar -DgeneratePom=true'

    print(f"Executing: {maven_cmd}")
    # Execute the Maven command
    subprocess.run(maven_cmd, shell=True)
    
# Close the dependencies XML snippet
dependencies_xml += "</dependencies>"

with open("dependencies.xml", "w") as dependencies_file:
    dependencies_file.write(dependencies_xml)

print("Wrote dependencies.xml")
    
