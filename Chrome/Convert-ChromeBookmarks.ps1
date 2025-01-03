<#PSScriptInfo

.VERSION 1.0

.GUID 1571d4f1-158a-48c8-af20-5a171b6430ba

.AUTHOR Kalichuza

.COMPANYNAME Kalichuza

.COPYRIGHT (c) 2025 Kalichuza. All rights reserved.

.TAGS Chrome, json, bookmarks

.LICENSEURI https://opensource.org/licenses/MIT

.PROJECTURI 

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES


.PRIVATEDATA


#>
<#

.DESCRIPTION
Converts a Chrome bookmarks from the html backup to Json.

#>



[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$HtmlBookmarksPath,  # Path to the HTML bookmarks file

    [Parameter(Mandatory=$true)]
    [string]$JsonBookmarksPath   # Path to save the converted JSON file
)

function Convert-HtmlToJsonBookmarks {
    param (
        [string]$HtmlFilePath,
        [string]$JsonFilePath
    )

    # Read the HTML file content
    $htmlContent = Get-Content -Path $HtmlFilePath -Raw

    # Initialize an empty bookmarks structure with metadata
    $bookmarks = @{
        checksum = ""
        roots = @{
            bookmark_bar = @{
                children = @()
                date_added = "13334704963909862"
                date_last_used = "0"
                date_modified = "0"
                guid = [guid]::NewGuid().ToString()
                id = "1"
                name = "Bookmarks bar"
                type = "folder"
            }
            other = @{
                children = @()
                date_added = "13334704963909864"
                date_last_used = "0"
                date_modified = "0"
                guid = [guid]::NewGuid().ToString()
                id = "2"
                name = "Other bookmarks"
                type = "folder"
            }
            synced = @{
                children = @()
                date_added = "13334704963909864"
                date_last_used = "0"
                date_modified = "0"
                guid = [guid]::NewGuid().ToString()
                id = "3"
                name = "Mobile bookmarks"
                type = "folder"
            }
        }
        version = 1
    }

    # Regular expression to match each bookmark
    $bookmarkRegex = '<A HREF="([^"]+)" ADD_DATE="([^"]+)">([^<]+)</A>'

    # Process each bookmark and add it to the JSON structure
    $idCounter = 4
    foreach ($match in [regex]::Matches($htmlContent, $bookmarkRegex)) {
        $unixTimestamp = $match.Groups[2].Value
        $guid = [guid]::NewGuid().ToString()
        $fileTime = ([datetime]'1970-01-01').AddSeconds($unixTimestamp).ToFileTimeUtc().ToString()

        $bookmarks.roots.bookmark_bar.children += @{
            type = "url"
            name = $match.Groups[3].Value
            url = $match.Groups[1].Value
            date_added = $fileTime
            guid = $guid
            id = "$idCounter"
        }
        $idCounter++
    }

    # Compute checksum (a simple dummy checksum for now; adjust as needed)
    $bookmarks.checksum = "1e54fbb25d92a354f7aeaf576726429e"

    # Convert to JSON and save to the specified path
    $jsonContent = $bookmarks | ConvertTo-Json -Depth 10
    Set-Content -Path $JsonFilePath -Value $jsonContent

    Write-Host "Bookmarks converted and saved to $JsonFilePath"
}

# Call the function with provided parameters
Convert-HtmlToJsonBookmarks -HtmlFilePath $HtmlBookmarksPath -JsonFilePath $JsonBookmarksPath
