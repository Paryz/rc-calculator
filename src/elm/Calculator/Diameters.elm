module Calculator.Diameters exposing (BarSectionsList, barDiameters, listOfBarSection)


barDiameters : List Int
barDiameters =
    [ 6
    , 8
    , 10
    , 12
    , 16
    , 20
    , 25
    , 32
    , 40
    , 50
    ]


type alias BarSectionsList =
    { m6 : List Int
    , m8 : List Int
    , m10 : List Int
    , m12 : List Int
    , m16 : List Int
    , m20 : List Int
    , m25 : List Int
    , m32 : List Int
    , m40 : List Int
    , m50 : List Int
    }


listOfBarSection : BarSectionsList
listOfBarSection =
    { m6 = [ 28, 56, 84, 113, 141, 169, 197, 226, 254, 282 ]
    , m8 = [ 50, 100, 150, 201, 251, 301, 351, 402, 452, 502 ]
    , m10 = [ 78, 157, 235, 314, 392, 471, 549, 628, 706, 785 ]
    , m12 = [ 113, 226, 339, 452, 565, 678, 791, 904, 1017, 1130 ]
    , m16 = [ 201, 402, 603, 804, 1005, 1206, 1407, 1608, 1809, 2010 ]
    , m20 = [ 314, 628, 942, 1256, 1570, 1884, 2199, 2513, 2827, 3141 ]
    , m25 = [ 490, 981, 1472, 1963, 2454, 2945, 3436, 3926, 4417, 4908 ]
    , m32 = [ 804, 1608, 2412, 3216, 4021, 4825, 5629, 6433, 7238, 8042 ]
    , m40 = [ 1256, 2513, 3769, 5026, 6283, 7539, 8796, 10053, 11309, 12566 ]
    , m50 = [ 1963, 3926, 5890, 7853, 9817, 11780, 13744, 15707, 17671, 19634 ]
    }
