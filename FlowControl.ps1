## Flow Control
## Creates a directory typically used in web development


Param(
    [string]$Path = './ThisIsATestAPP',
    [string]$DestinationPath = './',
    [switch]$PathIsWebApp
)

function PathCheck{
    param (
        [string]$PathCheck,
        [string]$DestinationPathCheck,
        [switch]$PathIsWebApp
    )
    $Path = Read-Host "Path"
    if (-Not (Test-Path $Path)){
        Write-Host "The source directory $Path does not exist, please specify an existing directory"
    }
    $DestinationPath = Read-Host "Destination Path"
    if (-Not (Test-Path $DestinationPath)){
        Write-Host "The destination directory $DestinationPath does not exist, please specify an existing directory"
    }
    If ($PathIsWebApp -eq $True){
        Try
        {
          $ContainsApplicationFiles = "$((Get-ChildItem $Path).Extension | Sort-Object -Unique)" -match  '\.js|\.html|\.css'

          If ( -Not $ContainsApplicationFiles){
            Throw "Not a web app"
          } Else{
            Write-Host "Source files look good, continuing"
          }
        } Catch{
         Throw "No backup created due to: $($_.Exception.Message)"
        }
       }
}

##
$default = Read-Host -Prompt "Back up '$Path' to '$DestinationPath'? [Y/N]"
if ($default -match 'N'){

    while (-NOT $app -match ("Y" -or "y") -or -NOT $app -match ("N" -or "n")){
        $app = Read-Host -Prompt "Is this a web app? [Y/N]"
    }
    while (-Not (Test-Path $Path) -and -Not (Test-Path $DestinationPath)){
        If ($app -match ("N" -or "n")){
            PathCheck -PathCheck $Path -DestinationPathCheck $DestinationPath
        }
        if ($app -match ("Y" -or "y")){
            PathCheck -PathCheck $Path -DestinationPathCheck $DestinationPath -PathIsWebApp
        }
    }
}
if ($Path -match "./ThisIsATestAPP" -and $DestinationPath -match "./"){
    Write-Host 'Default values. Creating a test environment....'
    Start-Sleep 2
    mkdir ThisIsATestAPP
    Set-Location ThisIsATestAPP
    New-Item index.html
    New-Item app.js
    Set-Location ..
    Write-Host 'Created ThisIsATestAPP test directory at ./ThisIsATestAPP'
    $Path = "./ThisIsATestAPP"
    $DestinationPath = "./"
}

Write-Host 'Backing up...'
$date = get-Date -format "yyyy-MM-dd"
$DestinationFile = "$($DestinationPath + 'backup-' + $date).zip"
If (-Not (Test-Path $DestinationFile)){
    Compress-Archive -Path $Path -CompressionLevel 'Fastest' -DestinationPath "$($DestinationPath + 'backup-' + $date)"
    Write-Host "Created backup at $($DestinationPath + 'backup-' + $date).zip"
} Else{
    Write-Error "#### Today's backup already exists!!"
}

##
## Clean environment of test files
[string]$clean = Read-Host -Prompt "Clean the test environment? [Y/N]"
if ($clean -match ("Y" -or "y")){
    Write-Host "Moving files to Trash"
    Write-Host "Moving the backup file.."
    Remove-Item -Path "$($DestinationPath + 'backup-' + $date).zip" -Confirm
    Write-Host "Moving the WebApp directory..."
    Remove-Item -Path "./ThisIsATestAPP"
    Write-Host "Environment Restored!!"
}
