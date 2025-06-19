/**
 * 状态管理 @State
 */
class Person{
  name?:string
  age:number = 0
  girl?:GirlPerson

  constructor(name:string,age:number,girl?:GirlPerson) {
    this.name = name
    this.age = age
    this.girl = girl
  }
}

@Observed
class GirlPerson{
  name:string
  age:number

  constructor(name:string,age:number) {
    this.name = name
    this.age = age
  }
}

@Component
export struct StatePage {
  @State p:Person = new Person('Jack',21,new GirlPerson('Rose',20))

  build() {
    Column() {
      Text(`${this.p?.name} : ${this.p?.age}`)
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          //todo 暂时注释
          // this.p?.age++
        })
      Text(`${this.p?.girl?.name??''} : ${this.p?.girl?.age}`)
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          //todo 暂时注释
          // this.p?.girl?.age++
        })
    }
    //@State也不能触发数组中对象属性的修改，只能触发数组的更新
  }
}