#!/bin/bash

function getAscii()
{
    case $1 in
        0   ) printf "NUL";;
        1   ) printf "SOH";;
        2   ) printf "STX";;
        3   ) printf "ETX";;
        4   ) printf "EOT";;
        5   ) printf "ENQ";;
        6   ) printf "ACK";;
        7   ) printf "BEL";;
        8   ) printf "BS";;
        9   ) printf "HT";;
        10  ) printf "LF";;
        11  ) printf "VT";;
        12  ) printf "FF";;
        13  ) printf "CR";;
        14  ) printf "SO";;
        15  ) printf "SI";;
        16  ) printf "DLE";;
        17  ) printf "DC1";;
        18  ) printf "DC2";;
        19  ) printf "DC3";;
        20  ) printf "DC4";;
        21  ) printf "NAK";;
        22  ) printf "SYN";;
        23  ) printf "ETB";;
        24  ) printf "CAN";;
        25  ) printf "EM";;
        26  ) printf "SUB";;
        27  ) printf "ESC";;
        28  ) printf "FS";;
        29  ) printf "GS";;
        30  ) printf "RS";;
        31  ) printf "US";;
        127 ) printf "DEL";;
        *) echo -n "$(printf "\x$(printf %x $1)")";;
    esac
}

# Binary Conversion
D2B=({0..1}{0..1}{0..1}{0..1}{0..1})

# print header
printf "  Bin Dec Hex  (00) |  Dec Hex  (01) |  Dec Hex  (10) |  Dec Hex  (11)\n"
printf "──────────────────────────────────────────────────────────────────────\n"

for i in $(seq 0 31); do
    printf "%s " ${D2B[$i]}
    for o in $(seq 0 32 127); do
        n=$(($i+$o))
        printf "%3d %3X  %-3s" $n $n "$(getAscii $n)"
        [[ $o -lt 96 ]] && printf "  |  "
    done
    printf "\n"
done
