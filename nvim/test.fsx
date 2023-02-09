let square x =
    let something = "nothing"
    float (x * x), something

14 |> square

module Hello =
    let inline private world (x: float) = x * x

    let run () = 
        world 222

Hello.run ()
