<#
From:
Standard ID: 0x682       DLC: 1  Data: 0x00
Standard ID: 0x35D       DLC: 8  Data: 0x00 0x03 0x00 0x00 0x00 0x00 0x00 0x00

To:
Time Stamp,ID,Extended,Bus,LEN,D1,D2,D3,D4,D5,D6,D7,D8
166064000,0000021A,false,0,8,FE,36,12,FE,69,05,07,AD,
#>

$regex = "Standard ID: (\w+)       DLC: (\w+)  Data:\s?(\w+)?\s?(\w+)?\s?(\w+)?\s?(\w+)?\s?(\w+)?\s?(\w+)?\s?(\w+)?\s?(\w+)?"
$TimeSTamp = 166064000
$Lines = Select-String "DLC" .\fullstart.txt
Write-Output "Time Stamp,ID,Extended,Bus,LEN,D1,D2,D3,D4,D5,D6,D7,D8"
ForEach ($line in $Lines) {
    $matched = $Line -match $regex
    if ($matched) {
        $TimeStamp += 100
        Write-Output ("{0},{1},false,0,{2},{3},{4},{5},{6},{7},{8}" -f $TimeSTamp, $matches[1], $matches[2], $matches[3], $matches[4], $matches[5], $matches[6], $matches[7], $matches[8])
    }
}