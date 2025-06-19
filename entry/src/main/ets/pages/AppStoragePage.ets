/**
 * AppStorage Demo
 */
@Entry
@Component
struct AppStoragePage {
  @State message: string = 'Hello World'

  build() {
    Column() {
     Button('AppStorage-Link')
       .onClick(()=>{
         AppStorage.SetOrCreate('AppStorageDemo1',47)
         //Link 返回双向绑定的数据，如果AppStorage不存在对应的propName，则返回undefined。
         //双向绑定数据的修改会同步回AppStorage中，AppStorage会将变化同步到所有绑定该propName的数据和自定义组件中。
         let linkToPropA1:AbstractProperty<number> = AppStorage.Link('AppStorageDemo1')
         let linkToPropA2:AbstractProperty<number>  = AppStorage.Link('AppStorageDemo1')
         linkToPropA1.set(48)
         console.info(`linkToPropA1 is ${linkToPropA1.get()},linkToPropA2 is  ${linkToPropA2.get()}`)
        //输出结果：linkToPropA1 is 48,linkToPropA2 is  48
       })
      Button('AppStorage-SetAndLink')
        .onClick(()=>{
          AppStorage.SetOrCreate('AppStorageDemo2',47)
          // 与Link接口类似，如果给定的propName在AppStorage中存在，则返回该propName对应的属性的双向绑定数
          // 据。如果不存在，则使用defaultValue在AppStorage创建和初始化propName，返回其双向绑定数据。
          let linkToPropA1:SubscribedAbstractProperty<number> = AppStorage.SetAndLink('AppStorageDemo2',48)
          let linkToPropA2:SubscribedAbstractProperty<number>  = AppStorage.SetAndLink('AppStorageDemo3',50)
          linkToPropA1.set(48)
          console.info(`linkToPropA1 is ${linkToPropA1.get()},linkToPropA2 is  ${linkToPropA2.get()}`)
          //输出结果：linkToPropA1 is 48,linkToPropA2 is  50
        })

      Button('AppStorage-Prop')
        .onClick(()=>{
          AppStorage.SetOrCreate('PropA', 47);
          let prop1:AbstractProperty<number> = AppStorage.Prop('PropA');
          let prop2:AbstractProperty<number> = AppStorage.Prop('PropA');
          prop1.set(1);
          //prop1.get()=1; but prop2.get() == 47
        })

      Button('AppStorage-SetAndProp')
        .onClick(()=>{
          AppStorage.SetOrCreate('PropA', 47);
          // 与Prop接口类似。如果给定的propName在AppStorage存在，则返回该propName对应的属性的单向绑定数据。如果
          // 不存在，则使用defaultValue在AppStorage创建和初始化propName对应的属性，返回其单向绑定数据。
          let prop: SubscribedAbstractProperty<number> = AppStorage.SetAndProp('PropB', 49);
          //PropA -> 47, PropB -> 49
        })

      Button('AppStorage-Has')
        .onClick(()=>{
          //判断propName对应的属性是否在AppStorage中存在。
          let has = AppStorage.Has('AppStorageDemo2');
          console.info(`AppStorage.Has ${has}`)
        })

      Button('AppStorage-Get')
        .onClick(()=>{
          //获取propName在AppStorage中对应的属性。如果不存在返回undefined。
          let value:number = AppStorage.Get('AppStorageDemo2') as number;
          console.info(`value is ${value}`)
        })
      Button('AppStorage-Set')
        .onClick(()=>{
          AppStorage.SetOrCreate('PropA', 48);
          //如果newValue的值和propName对应属性的值相同，即不需要做赋值操作，状态变量不会通知UI刷新propName对应属性的值。
          //如果AppStorage不存在propName对应的属性，或者设置的newValue是undefined或者null，返回false。设置成功则返回true。
          let res: boolean = AppStorage.Set('PropA', 47) // true
          let res1: boolean = AppStorage.Set('PropB', 47) // false
          console.info(`res is ${res},res1 is ${res1}`)
        })
      Button('AppStorage-SetOrCreate')
        .onClick(()=>{
          // 如果propName已经在AppStorage中存在，并且newValue和propName对应属性的值不同，则设置propName对应属性的值为newValue，否则状态变量不会通知UI刷新propName对应属性的值。
          // 如果propName不存在，则创建propName属性，值为newValue。setOrCreate只可以创建单个AppStorage的键值对，如果想创建多个AppStorage键值对，可以多次调用此方法。
          AppStorage.SetOrCreate('simpleProp', 121);
        })
      Button('AppStorage-Keys')
        .onClick(()=>{
          AppStorage.SetOrCreate('PropB', 48);
          AppStorage.SetOrCreate('PropA', 47);
          //迭代器
          let keys: IterableIterator<string> = AppStorage.Keys()
          //从迭代器中取出数据
          let result = keys.next();
          while (!result.done) {
            console.info(`key is ${result.value}`); // 打印当前值
            result = keys.next(); // 获取下一个值
          }
        })
    }
    .height('100%')
  }
}


