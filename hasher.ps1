#options to include:
#--baseline

$baseline = 0
$whitelist = type .\whitelist.conf

$counter = 0

#recursively check all directories in System32 for exe and dll files
<#
$exeFiles = Get-ChildItem "C:\Windows\System32" -Filter *.exe -Recurse
$dllFiles = Get-ChildItem "C:\Windows\System32" -Filter *.dll -Recurse
#>

$exeFiles = Get-ChildItem "C:\" -Filter *.exe -Recurse
$dllFiles = Get-ChildItem "C:\" -Filter *.dll -Recurse


#check whitelist for existing hash, return true if hash is whitelisted, false if it is not
function verifyHash($hash){
    $bool = 0
    if($whitelist -contains $hash){
        $bool = 1
    }
    return $bool
}


#function to return hash of file input
$sha1 = New-Object System.Security.Cryptography.SHA1CryptoServiceProvider
function getHash($completePath) {
    $hash = [System.BitConverter]::ToString( $sha1.ComputeHash([System.IO.File]::ReadAllBytes($completePath)))
    return $hash
}


if($baseline){
    echo "" > .\whitelist.conf
}

#iterate through the $exeFiles to check all hashes
foreach ($exeFile in $exeFiles){
    $counter = $counter+1
    $hash = getHash($exeFile.FullName)
    if ($baseline){
        echo $hash >> .\whitelist.conf
    }
    if ($baseline -eq 0){
        if(verifyHash($hash)){
            #echo "Hash is whitelisted."
        }
        else{
            echo $exeFile.fullName
            echo $hash
            echo "Hash is not in whitelist!"
            echo "-------------------------------------------------------------------"
        }
    }
    echo $counter
    
}


#iterate through the $dllFiles to check all hashes
foreach ($dllFile in $dllFiles){
    $counter = $counter+1
    $hash = getHash($dllFile.FullName)
    if ($baseline){
        echo $hash >> .\whitelist.conf
    }
    if ($baseline -eq 0){
        if(verifyHash($hash)){
            #echo "Hash is whitelisted."
        }
        else{
            echo $dllFile.fullName
            echo $hash
            echo "Hash is not in whitelist!"
            echo "-------------------------------------------------------------------"
        }
    }
    echo $counter
}