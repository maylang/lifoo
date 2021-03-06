# lifoo
#### a fresh take on Forth in the spirit of Lisp

### welcome
Welcome to Lifoo, a Forthy, Lispy language fused with Common Lisp. Lifoo is still very much under construction; besides [tests](https://github.com/codr4life/lifoo/blob/master/tests.lisp), inline documentation in the [implementation](https://github.com/codr4life/lifoo/blob/master/lifoo.lisp), and [built-in words](https://github.com/codr4life/lifoo/blob/master/init.lisp); the language is documented in a series of [blog](https://github.com/codr4life/vicsydev/blob/master/lispy_forth.md) [posts](https://github.com/codr4life/vicsydev/blob/master/consing_forth.md) [here](https://github.com/codr4life/vicsydev).

### repl
A basic REPL is provided for playing around with code in real time.

```
CL-USER> (lifoo:lifoo-repl)
Welcome to Lifoo,
press enter on empty line to evaluate,
exit ends session

Lifoo> "hello Lifoo!" print ln

hello Lifoo!
NIL

Lifoo> 1 2 +

3

Lifoo> (1 2 +)

(1 2 +)

Lifoo> (1 2 +) eval

3

Lifoo> "1 2 +" read

(1 2 +)

Lifoo> (1 2 +) write

"1 2 +"

Lifoo> (1 2 +) write read eval

3

Lifoo> (1 2 +) compile

(PROGN (LIFOO-PUSH 1) (LIFOO-PUSH 2) (LIFOO-CALL '+))

Lifoo> (1 2 +) compile link

#<FUNCTION {1005F27E5B}>

Lifoo> (1 2 +) compile link eval

3

Lifoo> (+ (lifoo:lifoo-pop) (lifoo:lifoo-pop)) lisp

#<FUNCTION {100649999B}>

Lifoo> 1 2 
       (lifoo:lifoo-push (+ (lifoo:lifoo-pop) (lifoo:lifoo-pop)))
       lisp eval

3

Lifoo> exit

NIL
CL-USER> 
```

### structs
Lifoo provides a simple but effective interface to defstruct. Outside of Lifoo the struct is anonymous to not clash with existing Lisp definitions. Words are automatically generated for ```make-foo```, ```foo-p``` and fields with setters when the ```struct``` word is evaluated.

```
Lifoo> ((bar -1) baz) :foo struct
       nil make-foo foo?

T

Lifoo> (:bar 42) make-foo
       foo-bar

42

Lifoo> (:bar 42) make-foo
       foo-bar 43 set
       foo-bar

43
```

### flow

#### deferred actions
Actions registered with ```defer``` runs on scope exit.

```
Lifoo> begin 
         ("deferred" print ln) defer 
         "hello" print ln
       end

hello
deferred
NIL

Lifoo> 41
       begin 
         (inc) defer 
         41 asseq
       end
       
42
```

#### always
Code passed to ```always``` runs even if values are thrown from preceding expressions in the same scope. 

```
Lifoo> :frisbee throw
       "skipped" print ln
       (:always) always
       (drop) catch

:ALWAYS
```

#### throw & catch
Code passed to ```catch``` runs when values are thrown from preceding expressions in the same scope. Thrown values are pushed on the stack before calling handlers.

```
Lifoo> :up throw
       "skipped" print ln
       (:caught cons) catch

(:CAUGHT . :UP)
```

### encryption
The ```crypt``` package is based on AES in CTR mode with SHA256-hashed keys, and requires identical seed and message sequence for ```encrypt``` and ```decrypt```.

```
Lifoo> :seed var crypt-seed set
       :key var "secret key" set
       :seed var :key var crypt "secret message" encrypt
       :seed var :key var crypt swap decrypt

"secret message"

Lifoo> 
```

### multi-threading
All Lifoo code runs in a ```lifoo-exec``` object, the result of accessing a ```lifoo-exec``` from multiple threads at the same time is undefined. The ```thread``` package allows spawning new threads as clones of the current exec. [Channels](http://vicsydev.blogspot.de/2017/01/channels-in-common-lisp.html) are used for communicating between threads.

```
Lifoo> 0 chan 
       (1 2 + send :done) 1 spawn swap 
       recv swap drop swap 
       wait cons

(:DONE . 3)
```



### tests
Lifoo comes with a suite of tests in ```tests.lisp```, evaluating ```(cl4l-test:run-suite '(:lifoo) :reps 3)``` repeats all tests 3 x 30 times.

```
(cl4l-test:run-suite '(:lifoo) :reps 3)
(lifoo abc)                   0.072
(lifoo array)                 0.032
(lifoo compare)               0.012
(lifoo env)                   0.012
(lifoo error)                 0.036
(lifoo flow)                  0.272
(lifoo io)                      0.0
(lifoo list)                  0.044
(lifoo log)                     0.0
(lifoo meta)                   0.08
(lifoo stack)                 0.008
(lifoo string)                0.024
(lifoo struct)                1.072
(lifoo thread)                0.084
(lifoo word)                  0.048
TOTAL                         1.796
NIL
```

### support
This project is running on a shoestring budget. I am completely fed up with the creative and collective compromises that come with playing the profit game. And despite hard times, I remain convinced that doing the right thing is the only way forward from here; information wants to be free and knowledge belongs everyone. Please consider [helping out](https://www.paypal.me/c4life) if you can, every contribution counts.

### ps
You are perfect, immortal spirit; whole and innocent.<br/>
All is forgiven and released.

peace, out<br/>
