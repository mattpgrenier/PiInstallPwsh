
###################################
# Prerequisites (https://learn.microsoft.com/en-us/powershell/scripting/install/community-support)

# Update package lists
sudo apt-get update

# Install dependencies
sudo apt-get install jq libssl1.1 libunwind8 -y


###################################
# Download the latest package

# Detect OS CPU Architecture
architecture=$(
	case $(uname -m) in
		x86_64) echo "x64" ;;
		aarch64) echo "arm64";;
		armv7l) echo "arm32" ;;
		*) echo "Unknown" ;;
		esac
	)

#Get list of latest releases
release=$(curl -sL https://api.github.com/repos/PowerShell/PowerShell/releases/latest)

#Identify the package that matches the OS CPU Architecture
package=$(echo $release | jq -r ".assets[].browser_download_url" | grep "linux-$architecture.tar.gz")

# Identify the name of the package downloaded
packagename=$(echo $package | awk -F/ '{print $NF}')

#Download the package
wget -O $packagename $package


###################################
# Unpack and install (https://learn.microsoft.com/en-us/powershell/scripting/install/install-other-linux)

#Identify the major version as the first integer after the "v" in the package URL
majorver=$(echo $packagename | sed -n 's/.*v\([0-9]\+\)\..*/\1/p')

# Create the target folder where powershell will be placed
sudo mkdir -p /opt/microsoft/powershell/$majorver

# Expand the powershell package to the target folder
sudo tar zxf ./$packagename -C /opt/microsoft/powershell/$majorver

# Set execute permissions
sudo chmod +x /opt/microsoft/powershell/$majorver/pwsh

# Create the symbolic link that points to pwsh
sudo ln -sf /opt/microsoft/powershell/$majorver/pwsh /usr/bin/pwsh

