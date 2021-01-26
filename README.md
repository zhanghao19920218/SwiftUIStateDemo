# 为什么@State只能在结构体使用

SwiftUI的State属性包装器被设计用于存储当前视图的本地数据，不过一旦你需要视图之间共享数据，它就不管了

```swift
struct User {
  var firstName = "Bilbo"
  var lastName = "Baggins"
}
```

```swift
struct ContentView: View {
    @State private var user = User()

    var body: some View {
        VStack {
            Text("Your name is \(user.firstName) \(user.lastName).")

            TextField("First name", text: $user.firstName)
            TextField("Last name", text: $user.lastName)
        }
    }
}
```

后台发生的事情: __每当我们的结构体中的某个值改变时，整个结构体随之改变 —— 就如同我们重新输入姓和名构建了一个新的 User 那样。听起来好像很浪费，但实际上这个过程非常快。__

### 类和结构体

* 结构体总是只有唯一的所有者，而对于类，可以有很多个对象指向同一份数据
* 类不需要在方法名前写`mutating` 关键字以便修改它们的属性，因为即使是常量类，属性也可以直接修改

**实践**

* 如果我们有两个 SwiftUI 的视图，如果其中一个改变，另外一个并不会随着改变。另一方面，如果我们创建一个类实例，赋给两个视图，它们会共享改变
* 如果我们创建一个类实例，赋给两个视图，它们会共享改变。



### Questions

***

***如果我们想在多个视图之间共享数据，或者说让两个或者更多视图引用相同的数据，以便一个改变，全部跟随改变 —— 这种情况下我们需要用类而不是结构体。***

***

```swift
class User {
}
```

```swift
struct User {
  
}
```



__当 `User` 还是一个结构体的时候，每当我们修改它的属性时，Swift 实际上创建了一个新的结构体实例。`@State` 能够看穿这种变化，并自动重新载入视图。现在我们把它改成类，这种行为不再发生：因为 Swift 能够直接修改目标对象的值 —— 没有新实例产生__

## 用 @ObservedObject 共享 SwiftUI 状态

`User` 类有两个属性：`firstName` 和 `lastName`。无论什么时候，这两个属性中的任何一个变化，我们都希望通知监视这个类的视图有变化发生以便它们重新加载。 所以我们可以对这两个属性使用 `@Published` 属性观察者，就像这样：

```swift
class User: ObservableObject {
    @Published var firstName = "Bilbo"
    @Published var lastName = "Baggins"
}

@ObservedObject var user = User()
```



如你所见，相比用 `@State`声明本地状态，要实现共享状态我们需要三个步骤：

- 创建一个遵循 `ObservableObject` 协议的类
- 标记类里的某些属性为 `@Published` 以便使用这个类的视图能够根据这些属性的变化来更新
- 用 `@ObservedObject` 属性包装器来创建类的实例