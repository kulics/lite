# Grammar Overview #

# Name Space #
"Xs/Demo" {
    "System"
    "System/Linq"
    "System/Text"
    "System/Threading/Tasks"
    "System/ComponentModel/DataAnnotations/Schema"
    "System/ComponentModel/DataAnnotations"
    "IO" File. # 可以隐藏元素使用内容 #
}

Main() ~> () {
    # Define, 一般情况下编译器会自动判断类型 #
    String := "10"   # Str #
    Number := 1.2     # Num #
    Integer := 123   # Int #
    Boolean := True  # Bool #
    Small Float := (1.2).to F32() # basic type convert #

    # Const #
    PI :: 3.141592653

    # Mark String #
    Format := "the value is "Integer","Number","Boolean""

    # List #
    List := []Int{ 1,2,3,4,5 }
    List2 := { 1,2,3,4,5 }
    Prt( List[0] ) # 使用下标获取 #

    # Set #
    Set := [Int]{ [1],[2],[3],[4],[5] }
    Set2 := { [1],[2],[3],[4],[5] }

    # Dictionary, 前面为key，后面为value #
    Dictionary := {["1"]False, ["2"]True}
    Dictionary := [Str]Bool{ ["1"]False, ["2"]True}
    Prt( Dictionary["1"] ) # 使用key获取 #

    Array: [:]Int = Array of(1,2,3)
    # Anonymous Package #
    New := {
        title = "nnn",
        number = 8
    }

    # Function #
    Fn(in: Int) -> (out: Int) {} # (Int)->(Int)  #

    # Function with no params no return #
    DoSomeThingVoid() -> () {
        DoSomeThingA()
        DoSomeThingB()
    }

    # Full Function with in params and out params #
    DoSomeThingWithParams(x: Int, y: Str) -> (a: Int, b: Str) {
        <- (x, y)
    }

    B2C()
    # 使用 _ 舍弃返回值 #
    _ = A2B(3, "test")

    # Judge，当表达式的结果只有Bool时，相当于if，只当True时才执行 #
    ? 1+1 >< 2 {
        DoSomeThingA()
    } _ { # else #
        DoSomeThingB()
    }

    # pattern match #
    x ? [0<6] {
        DoSomeThingA()
    } 14 {
        DoSomeThingB()
    } _ { # default #
        DoSomeThingC()
    }

    # type match #
    object ? :Str { 
        Prt("string") 
    } :Int { 
        Prt("integer") 
    } :Num { 
        Prt("float") 
    } :Bool { 
        Prt("boolean") 
    } :{} {
        Prt("object")
    } () { 
        Prt("null") 
    }

    # Loop, use identify to take out single item, default is it #
    array @ item {
        Prt(item)
    }
    # take index and value, both worked at Dictionary #
    array @ [index]value {
        Prt(index, value)
    }

    # Iterator, Increment [from < to, step], Decrement [from > to, step], step can omit # 
    [0 < 100, 2] @ it {
        Prt(it)
    }
    [10>=1] @ it {}

    # Infinite #
    @ {
        ? a > b {
            <- @ # jump out loop #
        } _ {
            -> @ # continue #
        }
    }
    # Conditional #
    a := 0
    @ a < 10 {
        a += 1
    }
    
    # Package，支持 variable 类型，通常用来包装数据 #
    View -> {
        width: Int
        height: Int
        background: Str
    }

    # 也支持包装方法 #
    Button -> {
        width: Int
        height: Int
        background: Str
        title: Str
    }
    (me:Button) click() -> () {
        # 可以通过 me 来访问包自身属性或方法 #
        Prt( me.title )
        doSomeThingA()
        doSomeThingB()
    }

    Image -> {
        # 私有属性，不能被外部访问，也不能被重包装 #
        _width := 0
        _height := 0
        _source := "" 
    }
    # 初始化方法 #
    (me:Image) init(w: Int, h: Int, s: Str) -> (v:Image) {  
        (me._width, me._height, me._source) = (w,h,s)
        <- (me)
    }

    # Protocol, implemented by package #
    Animation <- {
        speed(): Int        # 需求变量，导入的包必须实现定义 #
        move(s: Int) -> ()  # 需求方法，导入的包必须实现定义 #
    }

    # Combine Package，通过引入来复用属性和方法 #
    Image Button -> {
        # 通过包含其它包，来组合新的包使用  #
        Image
        Animation
        Button

        title: Str
        speed := 2
    }   
    # Implement protocol #  
    (me:Image Button) move(s: Int) -> () {
        t := 5000/s
        play( s + t )
    }
    (me:Image Button) <>(w: Int, h: Int)(w, h , "img") {
        title = "img btn"
    }

    # Create an package object #
    IB := Image Button{}
    # Calling property #
    IB.title = "OK"
    # Calling method #
    IB.button.show()
    # Calling protocol #
    IB.move(6)

    # Create an object with simple assign #
    IB2 := Image Button{
        title="Cancel"，background="red"
    }
    List := []Int{1,2,3,4,5}
    Map := [Str]Int{["1"]1,["2"]2,["3"]3}

    # Create an object with params #
    Img := Image{}.init(30, 20, "./icon.png")
    ImgBtn := <Image Button>(1, 1)

    # judge type #
    ? IB == :Image Button {
        # convert type #
        IB:View.show()
    }

    # get type #
    Prt( ?(IB) )
    Prt( ?(:Image Button) )

    # Check, listen the Excption Function #
    Fi := File("./test.xs")
    Read File("demo.xs") ! F
    ! {
        do some thing()
    } ex {
        !(ex) # Use !() to declare an Excption #
    } _ {
        Fi.Dispose()
    }

    # Use ~> to declare Async Function #
    Task(in: Int) ~> (out: Int) {
        # make a function to await #
        <~ do some thing A()
        do some thing B()
        <~ do some thing C()
        <- (in)
    }

    X := Task(6)

    # Annotation  #
    [assemby-> Table("user"), D(False,Name="d",Hide=True)]
    User -> {
        [Column("id"), Required, Key]
        id(): Str
        [Column("nick_name"), Required]
        nick name(): Str
        [Column("time_update"), Required]
        time update(): Int
    }

    # Pointer Type #
    A: ?Int = ()
    # Get Pointer #
    C := A?
    # Safe Call #
    E := A?.to Str()
    # OrElseValue #
    F := A.or else(128)

    # Reference #
    Swap(x:!Int, y:!Int) -> () {
        (x, y) = (y, x)
    }
    Swap(A!, B!)
    
    # Generic package #
    Table<T> -> {
        data: T

        set data(d: T) -> () {
            data = d
        }
    }
    # Generic function #
    Add<T>(x1: T, x2: T) -> (y: T) {
        <- (x1 + x2)
    }

    # Lambda Function #
    arr.select( {it -> it > 2} )
    arr.select{it -> it > 2}

    # Func params #
    Func(in: (Int) -> (Int)) -> () {
        in(1)
    }
    Func( (x: Int) -> (y: Int) {
        <- (y)
    })

    # linq #
    arr := from id -> in expr -> where expr -> order expr -> select expr

    # event #
    EventHandle -> {
        property changed: Event<PropertyChangedEventHandler>
    }

    # control #
    Data -> {
        b() := 0
        c(): Int -> get,set

        d(): Int
        e(): PropertyChangedEventHandler -> add,remove
    }

    Color -> I8[
        Red 
        Green
        Blue
    ]
}

# The Future #

"Namespace" <- {
    "System"
    "System/IO"
}
Num: Int
Txt: Str
Class -> {
    num: Int
    txt: Str
}
(me:Class)func in class() -> () {
    Func()
}
Func() -> () {
    Class In Func -> {
        num: Int
        txt: Str
    }
    (me:Class In Func)func() -> () {
    }
    Use protocol(Class{})
}
Protocol <- {
    func in class() -> () {
    }
}
Use protocol(it: Protocol) -> () {
    it.func in class()
}
