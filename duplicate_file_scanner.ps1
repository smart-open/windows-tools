# Duplicate File Scanner (Simplified)
# Uses MD5 hash comparison to scan for duplicate files

# Display welcome message
Write-Host "====================================" -ForegroundColor Green
Write-Host "         Duplicate File Scanner" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host "This tool helps you scan and identify duplicate files"
Write-Host "System folders and development files are automatically excluded" -ForegroundColor Gray
Write-Host "====================================" -ForegroundColor Green

# Get available drives
$drives = Get-PSDrive -PSProvider FileSystem | Where-Object {$_.Root -match "^[A-Z]:\\$"}

# Display drive selection menu
Write-Host "\nPlease select a drive to scan:" -ForegroundColor Yellow
$driveList = @()
$index = 1
foreach ($drive in $drives) {
    try {
        $driveInfo = Get-Volume -DriveLetter $drive.Root[0] -ErrorAction SilentlyContinue
        if ($driveInfo) {
            $freeSpaceGB = [math]::Round($driveInfo.SizeRemaining / 1GB, 2)
            $totalSpaceGB = [math]::Round($driveInfo.Size / 1GB, 2)
            $driveList += $drive.Root
            Write-Host "$index. $($drive.Root) (Free: ${freeSpaceGB}GB / Total: ${totalSpaceGB}GB)"
            $index++
        }
    }
    catch {
        # Skip inaccessible drives
    }
}

# Get user selection
$validInput = $false
while (-not $validInput) {
    $choice = Read-Host "Please enter drive number (1-$($driveList.Count))"
    if ($choice -match "^[1-9]\d*$" -and [int]$choice -ge 1 -and [int]$choice -le $driveList.Count) {
        $targetDrive = $driveList[[int]$choice - 1]
        $validInput = $true
    }
    else {
        Write-Host "Invalid input. Please enter a number between 1 and $($driveList.Count)" -ForegroundColor Red
    }
}

# Display scan information
Write-Host "\nScanning drive: $targetDrive" -ForegroundColor Cyan
Write-Host "Preparing to scan, please wait..." -ForegroundColor Cyan

# Define excluded system folders
$excludedFolders = @(
    "$targetDrive\Windows",
    "$targetDrive\Program Files",
    "$targetDrive\Program Files (x86)",
    "$targetDrive\AppData",
    "$targetDrive\Recovery",
    "$targetDrive\System Volume Information",
    "*\\.idea",
    "*\\.vscode",
    "*\\node_modules",
    "*\\.git"
)

# Initialize variables
$fileHashes = @{}
$duplicateFiles = @()
$scannedFiles = 0
$startTime = Get-Date

# Start scanning
Write-Host "Starting file scan, this may take some time..." -ForegroundColor Cyan

# Try using NTFS USN Journal for fast file enumeration (optimization)
Write-Host "Trying to use NTFS USN Journal for fast file enumeration..." -ForegroundColor Cyan

$filteredFiles = @()
$useUSNJournal = $true
$allFiles = @()

# Check if the drive is NTFS
try {
    $volumeInfo = Get-Volume -DriveLetter $targetDrive[0] -ErrorAction SilentlyContinue
    if (-not $volumeInfo -or $volumeInfo.FileSystem -ne "NTFS") {
        Write-Host "Drive is not NTFS, falling back to standard file enumeration..." -ForegroundColor Yellow
        $useUSNJournal = $false
    }
} catch {
    Write-Host "Error checking file system type: $($_.Exception.Message)" -ForegroundColor Yellow
    $useUSNJournal = $false
}

# Initialize timer for performance measurement
$enumerationStart = Get-Date

# Get all files, using optimized methods for NTFS drives or standard enumeration as fallback
try {
    if ($useUSNJournal) {
        try {
            # For NTFS drives, use optimized directory scanning approach
            Write-Host "Using NTFS optimized scanning..." -ForegroundColor Green
            
            # First pass: Get all directories and filter out excluded ones
            Write-Host "Scanning directories..." -ForegroundColor Cyan
            $directories = Get-ChildItem -Path $targetDrive -Directory -ErrorAction SilentlyContinue -Force | 
                          Where-Object { 
                              $dirPath = $_.FullName
                              $shouldInclude = $true
                              foreach ($excludedFolder in $excludedFolders) {
                                  if ($dirPath -like "$excludedFolder*") {
                                      $shouldInclude = $false
                                      break
                                  }
                              }
                              return $shouldInclude
                          }
            
            Write-Host "Found $(($directories | Measure-Object).Count) directories to process" -ForegroundColor Yellow
            
            # Process directories with progress
            $allFiles = @()
            $dirCount = ($directories | Measure-Object).Count
            $dirIndex = 0
            
            foreach ($dir in $directories) {
                $dirIndex++
                Write-Host ('Scanning directory {0}/{1}: {2}' -f $dirIndex, $dirCount, $dir.FullName) -ForegroundColor Gray
                
                try {
                    # Get files from this directory with error handling
                    $dirFiles = Get-ChildItem -Path $dir.FullName -File -Recurse -ErrorAction SilentlyContinue -Force
                    $allFiles += $dirFiles
                    
                    # Report progress every 10 directories
                    if ($dirIndex % 10 -eq 0) {
                        Write-Host "Processed $dirIndex/$dirCount directories, collected $(($allFiles | Measure-Object).Count) files so far..." -ForegroundColor Cyan
                    }
                } catch {
                    Write-Host "Error scanning directory $($dir.FullName): $($_.Exception.Message)" -ForegroundColor Red
                }
            }
            
            # Also get files in the root directory
            Write-Host "Scanning root directory..." -ForegroundColor Cyan
            $rootFiles = Get-ChildItem -Path $targetDrive -File -ErrorAction SilentlyContinue -Force
            $allFiles += $rootFiles
            
            Write-Host "NTFS optimized enumeration completed." -ForegroundColor Green
        } catch {
            Write-Host "Error using NTFS optimization: $($_.Exception.Message), falling back to standard enumeration..." -ForegroundColor Yellow
            $useUSNJournal = $false
        }
    }
    
    # If optimized method fails, use standard enumeration as fallback
    if (-not $useUSNJournal -or ($allFiles | Measure-Object).Count -eq 0) {
        Write-Host "Using standard file enumeration as fallback..." -ForegroundColor Yellow
        
        # Use standard Get-ChildItem with error handling
        $allFiles = Get-ChildItem -Path $targetDrive -Recurse -File -ErrorAction SilentlyContinue -Force
    }
    
    # Filter out system folders and excluded directories
    $filteredFiles = @()
    $fileCount = ($allFiles | Measure-Object).Count
    Write-Host "Filtering $fileCount files..." -ForegroundColor Cyan
    
    $currentFile = 0
    foreach ($file in $allFiles) {
        $currentFile++
        
        # Show filtering progress every 1000 files
        if ($currentFile % 1000 -eq 0) {
            Write-Host "Filtering: Processed $currentFile/$fileCount files..." -ForegroundColor Gray
        }
        
        if ($file -and $file.FullName) {
            $shouldExclude = $false
            foreach ($excludedFolder in $excludedFolders) {
                if ($file.FullName -like "$excludedFolder*") {
                    $shouldExclude = $true
                    break
                }
            }
            if (-not $shouldExclude) {
                $filteredFiles += $file
            }
        }
    }
    
    # Calculate enumeration time
    $enumerationEnd = Get-Date
    $enumerationTime = ($enumerationEnd - $enumerationStart).TotalSeconds
    
    $totalFiles = ($filteredFiles | Measure-Object).Count
    Write-Host "Found $totalFiles non-system files to scan" -ForegroundColor Yellow
    Write-Host "File enumeration completed in $([math]::Round($enumerationTime, 2)) seconds" -ForegroundColor Green
    
    # Calculate hashes and check for duplicates
    Write-Host "\nStarting hash calculation and duplicate detection..." -ForegroundColor Cyan
    $currentFile = 0
    foreach ($file in $filteredFiles) {
        $currentFile++
        
        # Display progress every 10 files
        if ($currentFile % 10 -eq 0) {
            $progressPercentage = [math]::Round(($currentFile / $totalFiles) * 100, 1)
            Write-Host "Processing: $currentFile/$totalFiles files ($progressPercentage%)" -ForegroundColor Yellow
        }
        
        # Calculate MD5 hash
        try {
            $hash = Get-FileHash -Path $file.FullName -Algorithm MD5 -ErrorAction SilentlyContinue
            if ($hash) {
                $scannedFiles++
                
                # Check if hash already exists
                if ($fileHashes.ContainsKey($hash.Hash)) {
                    # Found duplicate file
                    $duplicateFiles += @{
                        "Hash" = $hash.Hash
                        "OriginalFile" = $fileHashes[$hash.Hash]
                        "DuplicateFile" = $file.FullName
                        "Size" = $file.Length
                    }
                }
                else {
                    # New hash, store file path
                    $fileHashes[$hash.Hash] = $file.FullName
                }
            }
        }
        catch {
            # Skip files that can't be processed
        }
    }
}
catch {
    Write-Host "Error during scanning: $($_.Exception.Message)" -ForegroundColor Red
}

# Complete progress bar
Write-Progress -Activity "Scan completed" -Completed

# Calculate scan time
$endTime = Get-Date
$scanDuration = New-TimeSpan -Start $startTime -End $endTime

# Generate report
$reportPath = "$PSScriptRoot\duplicate_files_report_$((Get-Date).ToString('yyyyMMdd_HHmmss')).txt"

Write-Host "\n====================================" -ForegroundColor Green
Write-Host "          Scan Completed!" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host "Total files scanned: $scannedFiles" -ForegroundColor Yellow
Write-Host "Duplicate file groups found: $($duplicateFiles.Count)" -ForegroundColor Yellow

if ($duplicateFiles.Count -gt 0) {
    # Calculate space savings
    $savedSpace = ($duplicateFiles | Measure-Object -Property Size -Sum).Sum
    $savedSpaceGB = [math]::Round($savedSpace / 1GB, 2)
    
    Write-Host "Space that can be saved: ${savedSpaceGB}GB" -ForegroundColor Green
    Write-Host "Detailed report saved to: $reportPath" -ForegroundColor Green
    
    # Write report
    $reportContent = @"
===============================================
              Duplicate File Scan Report
===============================================
Scan time: $(Get-Date)
Scanned drive: $targetDrive
Total files scanned: $scannedFiles
Scan duration: $($scanDuration.Hours) hours $($scanDuration.Minutes) minutes $($scanDuration.Seconds) seconds

===============================================
                 Duplicate Files List
===============================================
"@
    
    # Add duplicate file details
    $duplicateIndex = 1
    foreach ($duplicate in $duplicateFiles) {
        $fileSizeMB = [math]::Round($duplicate.Size / 1MB, 2)
        $reportContent += "Duplicate group $duplicateIndex (Size: ${fileSizeMB}MB):
- Original file: $($duplicate.OriginalFile)
- Duplicate file: $($duplicate.DuplicateFile)
Hash: $($duplicate.Hash)
-----------------------------------------------
"
        $duplicateIndex++
    }
    
    $reportContent += "===============================================
Space that can be saved: ${savedSpaceGB}GB
===============================================
"
    
    # Save report
    try {
        $reportContent | Out-File -FilePath $reportPath -Encoding UTF8
        Write-Host "Report saved successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "Error saving report: $($_.Exception.Message)" -ForegroundColor Red
    }
}
else {
    Write-Host "No duplicate files found!" -ForegroundColor Green
    
    # Write empty report
    $reportContent = @"
===============================================
              Duplicate File Scan Report
===============================================
Scan time: $(Get-Date)
Scanned drive: $targetDrive
Total files scanned: $scannedFiles
Scan duration: $($scanDuration.Hours) hours $($scanDuration.Minutes) minutes $($scanDuration.Seconds) seconds

No duplicate files found!
===============================================
"@
    
    try {
        $reportContent | Out-File -FilePath $reportPath -Encoding UTF8
        Write-Host "Report saved successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "Error saving report: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Display exit prompt
Write-Host "\nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')