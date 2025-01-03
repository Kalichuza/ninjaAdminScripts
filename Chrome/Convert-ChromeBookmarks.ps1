
<#PSScriptInfo

.VERSION 1.2

.GUID 7edf5e62-7b9a-4f57-ac18-c73a7be301f8

.AUTHOR Kalichuza

.COMPANYNAME

.COPYRIGHT

.TAGS

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES Worked out a bug that left some bookmarks out of the JSON output.


.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Converts Chrome bookmarks from an HTML backup to JSON. 

#> 

param (
    [string]$inputFile,
    [string]$outputFile
)

function Convert-ToChromeTimestamp {
    param ([string]$unixTime)
    # Convert Unix timestamp to Chrome's timestamp format (microseconds since 1601-01-01)
    return [math]::Round(([double]$unixTime * 1000000) + 11644473600000000).ToString()
}

function Generate-Guid {
    # Generate a random GUID
    return [guid]::NewGuid().ToString()
}

function Parse-Bookmarks {
    param (
        [string]$content,
        [int]$idCounter
    )

    $bookmarks = @()

    # Regex for bookmarks
    $bookmarkRegex = '<A HREF="(.*?)".*?ADD_DATE="(\d+)".*?>(.*?)<\/A>'
    $matches = [regex]::Matches($content, $bookmarkRegex)

    foreach ($match in $matches) {
        $bookmark = [PSCustomObject]@{
            name          = $match.Groups[3].Value
            url           = $match.Groups[1].Value
            type          = 'url'
            id            = ($idCounter++).ToString()
            guid          = Generate-Guid
            date_added    = Convert-ToChromeTimestamp -unixTime $match.Groups[2].Value
            date_last_used = "0"
        }
        $bookmarks += $bookmark
    }

    return $bookmarks
}

function Convert-BookmarksToJSON {
    param (
        [string]$filePath
    )

    # Read the HTML content
    $htmlContent = Get-Content -Path $filePath -Raw
    $htmlContent = $htmlContent -replace '\r', '' -replace '\n', '' # Normalize line endings

    # Parse bookmarks into the "Bookmarks bar"
    $bookmarks = Parse-Bookmarks -content $htmlContent -idCounter 1

    # Construct output object
    $outputObject = [PSCustomObject]@{
        checksum = [BitConverter]::ToString(
            [System.Security.Cryptography.MD5]::Create().ComputeHash(
                [System.Text.Encoding]::UTF8.GetBytes($htmlContent)
            )
        ).Replace("-", "").ToLower()
        version  = 1
        roots    = [PSCustomObject]@{
            bookmark_bar = [PSCustomObject]@{
                name         = "Bookmarks bar"
                type         = "folder"
                id           = "1"
                guid         = Generate-Guid
                date_added   = Convert-ToChromeTimestamp -unixTime ([datetime]::UtcNow.ToFileTimeUtc() / 10000000 - 11644473600)
                date_modified = "0"
                date_last_used = "0"
                children     = $bookmarks
            }
            other        = [PSCustomObject]@{
                name         = "Other bookmarks"
                type         = "folder"
                id           = "2"
                guid         = Generate-Guid
                date_added   = Convert-ToChromeTimestamp -unixTime ([datetime]::UtcNow.ToFileTimeUtc() / 10000000 - 11644473600)
                date_modified = "0"
                date_last_used = "0"
                children     = @()
            }
            synced       = [PSCustomObject]@{
                name         = "Mobile bookmarks"
                type         = "folder"
                id           = "3"
                guid         = Generate-Guid
                date_added   = Convert-ToChromeTimestamp -unixTime ([datetime]::UtcNow.ToFileTimeUtc() / 10000000 - 11644473600)
                date_modified = "0"
                date_last_used = "0"
                children     = @()
            }
        }
    }

    return $outputObject
}

try {
    Write-Output "Processing file: $inputFile"
    $jsonOutput = Convert-BookmarksToJSON -filePath $inputFile
    $jsonOutput | ConvertTo-Json -Depth 10 | Set-Content -Path $outputFile -Encoding UTF8
    Write-Output "Bookmarks converted successfully to JSON and saved to $outputFile"
} catch {
    Write-Output "An error occurred: $_"
}
