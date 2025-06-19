
/**
 * Provider和Consume
 */
@Component
export struct FirstWidget{
  build(){
    SecondWidget()
  }
}

@Component
struct SecondWidget{
  @Consume('providerTotalNumber') bbb:number;
  build(){
    Row(){
      Text(`${this.bbb}`)
      Button('Provider和Consume-子组件同步数据给父组件').onClick(()=>{
        this.bbb++
      })
    }
  }
}