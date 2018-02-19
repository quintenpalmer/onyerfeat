module CustomSort exposing (armorSort, weaponSort)


armorSort : List { a | armorBonus : Int, armorClass : String } -> List { a | armorBonus : Int, armorClass : String }
armorSort armorPieces =
    (List.sortBy .armorBonus (List.sortWith armorSortFn armorPieces))


armorSortFn : { a | armorClass : String } -> { b | armorClass : String } -> Order
armorSortFn a1 b1 =
    case ( a1.armorClass, b1.armorClass ) of
        ( "light", _ ) ->
            LT

        ( _, "heavy" ) ->
            LT

        ( _, _ ) ->
            (compare a1.armorClass b1.armorClass)


weaponSort :
    List
        { a
            | name : comparable
            , sizeStyle : comparable1
            , trainingType : comparable2
        }
    ->
        List
            { a
                | name : comparable
                , sizeStyle : comparable1
                , trainingType : comparable2
            }
weaponSort weapons =
    (List.sortBy .trainingType (List.sortBy .sizeStyle (List.sortBy .name weapons)))
