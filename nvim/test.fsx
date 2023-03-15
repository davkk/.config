let square x =
    let something = "nothing"
    let hello = "hello"
    float (x * x), something

14 |> square

module Hello =
    let inline private world (x: float) = x * x

    let run () =
        let result = square 2 |> fst |> world
        if result = 222 then () else ()

Hello.run ()
