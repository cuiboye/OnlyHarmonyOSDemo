/**
 * LocalStorage的使用
 */
// let storage = new LocalStorage({ 'PropA': 47 });
//
// @Entry(storage)
// @Component
// struct LocalStoragePage {
//   //双向同步，单向同步的话使用 @LocalStorageProp
//   @LocalStorageLink('PropA') storLink1: number = 1;
//   build() {
//     Column() {
//       Column({ space: 15 }) {
//         Button(`Parent from LocalStorage ${this.storLink1}`)
//           .onClick(() => this.storLink1 += 1)
//         // @Component子组件自动获得对CompA LocalStorage实例的访问权限。
//         Child()
//       }
//     }
//     .height('100%')
//   }
// }
//
// @Component
// struct Child {
//   //双向同步，单向同步的话使用 @LocalStorageProp
//   // @LocalStorageLink变量装饰器与LocalStorage中的'PropA'属性建立双向绑定
//   @LocalStorageLink('PropA') storLink2: number = 1;
//
//   build() {
//     Button(`Child from LocalStorage ${this.storLink2}`)
//       // 更改将同步至LocalStorage中的'PropA'以及Parent.storLink1
//       .onClick(() => this.storLink2 += 1)
//   }
// }

/**
 * 下面这种写法不推荐，不建议在组件内使用全局变量linkToPropA.get()，因为可能会有生命周期不同引起的错误。
 */
// // 构造LocalStorage实例
// let storage = new LocalStorage({ 'PropA': 47 });
// // 调用link（api9以上）接口构造'PropA'的双向同步数据，linkToPropA 是全局变量
// // let linkToPropA = storage.link('PropA');
//
//
// @Entry(storage)
// @Component
// struct LocalStoragePage {
//
//   // @LocalStorageLink('PropA')在CompA自定义组件中创建'PropA'的双向同步数据，初始值为47，因为在构造LocalStorage已经给“PropA”设置47
//   @LocalStorageLink('PropA') storLink: number = 1;
//
//   build() {
//     Column() {
//       Text(`incr @LocalStorageLink variable`)
//         // 点击“incr @LocalStorageLink variable”，this.storLink加1，改变同步回storage，全局变量linkToPropA也会同步改变
//
//         .onClick(() => this.storLink += 1)
//
//       // 并不建议在组件内使用全局变量linkToPropA.get()，因为可能会有生命周期不同引起的错误。
//       Text(`@LocalStorageLink: ${this.storLink} - linkToPropA: ${linkToPropA.get()}`)
//     }
//   }
// }

/**
 * 兄弟节点之间的同步更新
 */
let ls: Record<string, number> = { 'countStorage': 1 }
let storage:LocalStorage = new LocalStorage(ls);

@Component
struct Child {
  // 子组件实例的名字
  label: string = 'no name';
  // 和LocalStorage中“countStorage”的双向绑定数据
  @LocalStorageLink('countStorage') playCountLink: number = 0;

  build() {
    Row() {
      Text(this.label)
        .width(50).height(60).fontSize(12)
      Text(`playCountLink ${this.playCountLink}: inc by 1`)
        .onClick(() => {
          this.playCountLink += 1;
        })
        .width(200).height(60).fontSize(12)
    }.width(300).height(60)
  }
}

@Entry(storage)
@Component
struct Parent {
  @LocalStorageLink('countStorage') playCount: number = 0;

  build() {
    Column() {
      Row() {
        Text('Parent')
          .width(50).height(60).fontSize(12)
        Text(`playCount ${this.playCount} dec by 1`)
          .onClick(() => {
            this.playCount -= 1;
          })
          .width(250).height(60).fontSize(12)
      }.width(300).height(60)

      Row() {
        Text('LocalStorage')
          .width(50).height(60).fontSize(12)
        Text(`countStorage ${this.playCount} incr by 1`)
          .onClick(() => {
            storage.set<number>('countStorage', 1 + Number(storage.get<number>('countStorage')));
          })
          .width(250).height(60).fontSize(12)
      }.width(300).height(60)

      Child({ label: 'ChildA' })
      Child({ label: 'ChildB' })
      //Text组件“playCount in LocalStorage for debug ${storage.get<number>('countStorage')}”没有同步刷新，因
      //为storage.get<number>('countStorage')返回的是常规变量，常规变量的更新并不会引起Text组件的重新渲染。
      // Text(`playCount in LocalStorage for debug ${storage.get<number>('countStorage')}`)
      Text(`playCount in LocalStorage for debug ${this.playCount}`)//改成这样接可以刷新了
        .width(300).height(60).fontSize(12)
    }
  }
}