# bars.dart

![bar class](../../assets/class_bar.png)

## Usage 

```dart
import 'package:conny/conny.dart';
import 'dart:io';

void main(List<String> args) {
  Bar bar = Bar("loading bar", 30);
  bar.showName = true;

  int state = 0;
  for (String s in bar.start()) {
    stdout.write(s);
    bar.updateState(state += 10);
  }
}
```

## Fields

### name
```dart
String get name => _name;
```
returns the Bar name set through constructor

### length
```dart
int get length => _length;
```
returns the Bar length set through constructor

### state
```dart
int get state => _state;
```
returns the current state of the Bar object
state runs from 0 - 100, states < 0 or > 100 have undocumented behaviour

### showName
```dart
bool showName = false;
```
defaults to false, set to true to display the Bar name to the left of the bar

### showPercent
```dart
bool showPercent = false;
```
defaults to false, set to true to display the Bar percent/state to the right of the bar

### light, dark
```dart
int light = 0x2591;
int dark = 0x2593;
```
light refers to the 'unloaded' segment of the bar and dark refers to the 'loaded' part of the bar, they are public field and can be changed freely. they are rendered through String.fromCharCode

## Methods

### updateState(int state)
```dart
void updateState(int state);

// should be called in the for in loop
int state = 0;
for (String s in bar.start()) {
    stdout.write(s);
    bar.updateState(state += 10);
}
```
updates state at whatever interval your loop deems appropriate
state should run through 0 - 100

### start()
```dart
Iterable<String> start() => _loop();

// should be called in the for in loop
for (String s in bar.start())
```
entry point for generator, yields the updated bar.
this will continue yielding String objects until the state is >= 100