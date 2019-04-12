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
    { m6 : List Float
    , m8 : List Float
    , m10 : List Float
    , m12 : List Float
    , m16 : List Float
    , m20 : List Float
    , m25 : List Float
    , m32 : List Float
    , m40 : List Float
    , m50 : List Float
    }


listOfBarSection : BarSectionsList
listOfBarSection =
    { m6 = [ 28.274, 56.548, 84.822, 113.096, 141.37, 169.644, 197.918, 226.192, 254.466, 282.74 ]
    , m8 = [ 50.265, 100.53, 150.795, 201.06, 251.325, 301.59, 351.855, 402.12, 452.385, 502.65 ]
    , m10 = [ 78.54, 157.08, 235.62, 314.16, 392.7, 471.24, 549.78, 628.32, 706.86, 785.4 ]
    , m12 = [ 113.097, 226.194, 339.291, 452.388, 565.485, 678.582, 791.679, 904.776, 1017.873, 1130.97 ]
    , m16 = [ 201.062, 402.124, 603.186, 804.248, 1005.31, 1206.372, 1407.434, 1608.496, 1809.558, 2010.62 ]
    , m20 = [ 314.159, 628.318, 942.477, 1256.636, 1570.795, 1884.954, 2199.113, 2513.272, 2827.431, 3141.59 ]
    , m25 = [ 490.874, 981.748, 1472.622, 1963.496, 2454.37, 2945.244, 3436.118, 3926.992, 4417.866, 4908.74 ]
    , m32 = [ 804.248, 1608.496, 2412.744, 3216.992, 4021.24, 4825.488, 5629.736, 6433.984, 7238.232, 8042.48 ]
    , m40 = [ 1256.637, 2513.274, 3769.911, 5026.548, 6283.185, 7539.822, 8796.459, 10053.096, 11309.733, 12566.37 ]
    , m50 = [ 1963.495, 3926.99, 5890.485, 7853.98, 9817.475, 11780.97, 13744.465, 15707.96, 17671.455, 19634.95 ]
    }
