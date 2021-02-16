#!/bin/sh
# math functions

checkdeps.sh bc

bc_(){
    echo "$1" | bc
}

h2b(){
    bc_ "ibase=16; obase=2; $1"
}

h2d(){
    bc_ "ibase=16; $1"
}

h2o(){
    bc_ "ibase=16; obase=8; $1"
}

d2b(){
    bc_ "obase=2; $1"
}

d2h(){
    bc_ "obase=16; $1"
}

d2o(){
    bc_ "obase=8; $1"
}

o2b(){
    bc_ "ibase=8; obase=2; $1"
}

o2d(){
    bc_ "ibase=8; $1"
}

o2h(){
    bc_ "obase=16; ibase=8; $1"
}

b2d(){
    bc_ "ibase=2; $1"
}

b2h(){
    bc_ "ibase=2; obase=10000; $1"
}

b2o(){
    bc_ "ibase=2; obase=1000; $1"
}
