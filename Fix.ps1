<#
PGNlist.csv like
PGN,Label,InDBC
100,Transmission Control 1,J1939 DBC
200,Electronic Brake System #1/1,No
300,Electronic Brake System #2/1,No
400,External Brake Request,J1939 DBC

x184.trc from canhacker, like:
Time   ID     DLC Data                    Comment
00.000 18EA0003 8 BE FE 00 00 FF FF FF FF 
00.000 301      8 A6 07 BA 01 00 15 18 11 
00.000 08FF8300 8 E8 03 01 FF FF FF FF FF 
#>

$CANIDs = import-csv .\PGNList.csv
$CANhash = @{}
ForEach ($can in $CANIDS) {
    $CANhash[$can.PGN] = $can.label
}
$traces = Get-Content x184.trc

Function PGNToDec1939 ( $hex) {
    $CanbusIdBinary = [Convert]::ToString("0x" + $hex, 2).PadLeft(29, "0")
    $Mid18 = $CanbusIdBinary.SubString(3,18)
    [int]("0b" + $Mid18)
}

$CanUnique = @{}
# PGNToDec1939 -hex "0xCFFAF27"

Remove-Item can.csv -ErrorAction SilentlyContinue
$CAN = ForEach ($l in $traces) {
    $sp = $l.split(" ")
    if ($sp[1].Trim().Length -gt 7) {
        $PGN = PGNToDec1939 -hex $sp[1]
        $CanUnique[$PGN]=1
        [PSCustomObject]@{
            CANID = $sp[1]
            PGN = $PGN
            Label = $CANhash[[system.convert]::tostring($pgn,16)]
            D1 = $sp[3]
            D2 = $sp[4]
            D3 = $sp[5]
            D4 = $sp[6]
            D5 = $sp[7]
            D6 = $sp[8]
            D7 = $sp[9]
            D8 = $sp[10]
        }
        #$($sp[1]),$PGN,$($CANhash[$PGN]),$($sp[3]) $($sp[4]) $($sp[5]) $($sp[6]) $($sp[7]) $($sp[8]) $($sp[9]) $($sp[10])"| tee can.csv -Append
    }
}
$CAN | export-csv can.csv

$CanUnique.Keys