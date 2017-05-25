module View.Spectrum
    exposing
        ( Spectrum
        , Thirds(..)
        , getSpectrum
        , findThird
        )


type Thirds
    = Top
    | Middle
    | Bottom


type alias Spectrum =
    { min : Int
    , third : Int
    , twoThird : Int
    , max : Int
    }


getSpectrum : List Int -> Spectrum
getSpectrum vals =
    getSpectrumHelper vals 0 0


getSpectrumHelper : List Int -> Int -> Int -> Spectrum
getSpectrumHelper vals min max =
    case vals of
        [] ->
            spectrumFromMinMax min max

        x :: xs ->
            getSpectrumHelper xs
                (if x < min then
                    x
                 else
                    min
                )
                (if x > max then
                    x
                 else
                    max
                )


spectrumFromMinMax : Int -> Int -> Spectrum
spectrumFromMinMax min max =
    let
        diff =
            max - min

        thirdStep =
            diff // 3
    in
        Spectrum min (min + thirdStep) (max - thirdStep) max


findThird : Spectrum -> Int -> Thirds
findThird s val =
    if val < s.third then
        Bottom
    else if val < s.twoThird then
        Middle
    else
        Top
