
# SwiftEvent

Example of event without arguments:

```swift
var event = Event()
event.on() {
  print("regular listener")
}
event.once() {
  print("one time listener")
}
event.emit()
event.emit()
```

With one argument:

```swift
var counter = 0
var event   = EventWith<Int>()
event.on() {
  counter += $0
}
event.once() {
  counter += $0
}
event.emitWith(1)
```

With two arguments:

```swift
var counter = 0
var string  = ''
var event   = EventDue<Int, String>()
event.on() { (value, word) in
  counter += value
  string  += word
}
event.emitWith(1, and: 'Hello ')
event.emitWith(1, and: 'World')
```

Variable arguments:

```swift
var text  = ''
var event = EventWith<[String]>()
event.on() { (words) in
  text += " ".join(words)
}
event.emitWith(['Hello', 'World', '!!!'])
```
