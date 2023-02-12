Function PGNToDec1939 ( $hex) {
    $CanbusIdBinary = [Convert]::ToString($hex, 2).PadLeft(29, "0")
    $Mid18 = $CanbusIdBinary.SubString(3,18)
    [int]("0b" + $Mid18)
}

PGNToDec1939 -hex "0xCFFAF27"