$paramNameAllowUntrusted = "Allow untrusted certificate"
$previousWd = pwd

# This will create a .ps1.readme file inside the same folder as the publish-interactive.ps1
# If this file is present then the publish-interactive.ps1 file will pick up all the param values from that
function CreatePublishSettingsFile {
    param([string]$filePath,$settings)
    
    # we will write out a PS script which has all the values
    $strToWrite = "`$settingsFromUser =@() `n"
    foreach($setting in $settings) {
        $str = ("`$settingsFromUser += @{{name=""{0}"";value=""{1}""}}`n" -f $setting.name, $setting.value)
        $strToWrite += ($str)
    }
    
    $strToWrite += "`n"

    Set-Content -Path $filePath -Value $strToWrite
    
    return $strToWrite;
}


function EscapePowershellString {
    param([string]$strToEscape)
    
    $newString = $strToEscape
    $strsToEscape = @()
    $strsToEscape += @{str='"';replacement='""'}
    
    foreach($str in $strsToEscape) {
        $newString = ($newString -replace $str.str,$str.replacement)
    }
    
    return $newString
}

$allParams = @()
$allParams += @{name="Computer name";value=(EscapePowershellString -strToEscape "local""host");isInternalParameter=$true}
$allParams += @{name="Username";value="";isInternalParameter=$true}
$allParams += @{name="Password";value="";isInternalParameter=$true;isSecure=$true}
$allParams += @{name=("{0}" -f $paramNameAllowUntrusted);value="false";isInternalParameter=$true}
$allParams += @{name="whatif";value="false";isInternalParameter=$true}

$result = CreatePublishSettingsFile -filePath C:\temp\ps\content.out -settings $allParams

Write-Host ("result: " + $result)
Write-Host ("settingsFromUser: " +$settingsFromUser)

Invoke-Expression $result
Write-Host ("settingsFromUser: " +$settingsFromUser)


