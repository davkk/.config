#load "./test1.fsx"

open Test1

let square x =
    let mutable something = "nothing"
    let hello = "hello"
    float (x * x), something

module Hello =
    let inline private world (x: float) = x * x

    let mutable private lol = "lol"

    let run () =
        let result = square 2 |> fst |> world
        if result = 222 then () else ()
        "run"

Hello.run ()
