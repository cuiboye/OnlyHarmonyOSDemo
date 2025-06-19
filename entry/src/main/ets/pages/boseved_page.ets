@Observed class ClassAAA {
  public numA: number
  public classB: ClassBBB

  constructor(cValue: ClassBBB, aValue: number = 0) {
    this.classB = cValue;
    this.numA = aValue;
  }
}

@Observed
class ClassBBB {
  public numB: number

  constructor(aValue: number = 0) {
    this.numB = aValue;
  }
}

@Entry
@Component
struct ObserverPage {
  @State classA: ClassAAA = new ClassAAA(new ClassBBB());

  build() {
    Column() {
      Text(' 注意：@State无法监听到类嵌套类的属性，@ObjectLink可以监听到类嵌套@Observed修饰的类的属性。')
        .fontColor('#FF0000')
        .fontSize(24)
        .margin({ top: 20 })
      Text('父组件').fontSize(24).margin({ top: 20 })
      Text(`ClassAAA的numA值：${this.classA.numA}`)
        .fontSize(20)
        .padding(20)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          this.classA.numA += 1
        })

      Text('父组件不会刷新').fontSize(16).margin({ top: 20 })  .fontColor('#FF0000')
      Text(`ClassBBB的numB值：${this.classA.classB.numB}`)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .padding(20)
        .onClick(() => {
          // 修改值，只会导致 @ObjectLink 装饰的变量所在的组件被刷新，当前组件不会刷新(因为当前组件classA是用@State修饰的)
          this.classA.classB.numB += 1
        })

      Text('子组件').fontSize(24).margin({ top: 20 })

      ObserverPage2({ classB: this.classA.classB })
    }
    .width('100%')
    .height('100%')
  }
}

@Component
struct ObserverPage2 {
  @ObjectLink  classB: ClassBBB

  build() {
    Column() {
      Text('子组件被刷新').fontSize(16).margin({ top: 20 })  .fontColor('#FF0000')

      Text(`ClassBBB的numB值：${this.classB.numB}`)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          // 修改值，只会导致 @ObjectLink 装饰的变量所在的组件被刷新
          this.classB.numB += 1
        })

    }.width('100%')
    .height('100%')
  }
}