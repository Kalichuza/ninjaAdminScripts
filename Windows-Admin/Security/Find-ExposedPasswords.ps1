
<#PSScriptInfo

.VERSION 1.0.2

.GUID 14b6a945-9e11-4a05-86cb-2618a87bd213

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

.RELEASENOTES


.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Find exposed passwords in your file system 

#> 

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [SecureString]$PredefinedPassword,

    [Parameter(Mandatory = $true)]
    [string]$RootPath,

    [Parameter()]
    [string[]]$FileExtensions = @('*.txt', '*.ps1', '*.cs', '*.js', '*.html', '*.css', '*.config', '*.xml', '*.json', '*.md', '*.log', '*.docx', '*.pdf'),

    [Parameter()]
    [switch]$VerboseOutput
)

# Convert the secure string password to plain text
$PlainPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PredefinedPassword))

# Function to check if ReadPDF module is installed
function Ensure-ReadPDFModule {
    if (-not (Get-Module -ListAvailable -Name ReadPDF)) {
        Write-Verbose "ReadPDF not found. Installing it now..."
        Install-Module -Name ReadPDF -Force -Scope CurrentUser
    }
}

# Install the module if necessary
Ensure-ReadPDFModule

# Import the module
Import-Module ReadPDF -ErrorAction Stop

# Function to search for passwords in text-based files
function Search-TextFilesForPassword {
    param (
        [string]$FilePath,
        [string]$Password
    )

    try {
        # Check if the file content contains the password
        $FileContent = Get-Content -Path $FilePath -ErrorAction Stop
        if ($FileContent -match [regex]::Escape($Password)) {
            Write-Host "Password found in file: $FilePath" -ForegroundColor Red
        } elseif ($VerboseOutput) {
            Write-Host "Checked: $FilePath - No password found." -ForegroundColor Green
        }
    }
    catch {
        if ($VerboseOutput) {
            Write-Warning "Could not read file: $FilePath. Error: $_"
        }
    }
}

# Function to search for passwords in PDFs
function Search-PdfForPassword {
    param (
        [string]$FilePath,
        [string]$Password
    )

    try {
        $pdfContent = Import-PDFFile -Path $FilePath
        if ($pdfContent -match [regex]::Escape($Password)) {
            Write-Host "Password found in PDF file: $FilePath" -ForegroundColor Red
        } elseif ($VerboseOutput) {
            Write-Host "Checked: $FilePath - No password found." -ForegroundColor Green
        }
    }
    catch {
        if ($VerboseOutput) {
            Write-Warning "Could not read PDF: $FilePath. Error: $_"
        }
    }
}

# Function to search the file system recursively for files
function Search-FileSystem {
    param (
        [string]$Path,
        [string[]]$Extensions,
        [string]$Password
    )

    foreach ($Extension in $Extensions) {
        Get-ChildItem -Path $Path -Recurse -Filter $Extension -ErrorAction SilentlyContinue | ForEach-Object {
            if ($_.Extension -eq ".pdf") {
                Search-PdfForPassword -FilePath $_.FullName -Password $Password
            }
            else {
                Search-TextFilesForPassword -FilePath $_.FullName -Password $Password
            }
        }
    }
}

# Execute the search
Search-FileSystem -Path $RootPath -Extensions $FileExtensions -Password $PlainPassword

# Cleanup the plain text password from memory
[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($PredefinedPassword))




