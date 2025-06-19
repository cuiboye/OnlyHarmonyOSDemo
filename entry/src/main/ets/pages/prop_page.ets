
/**
 * 状态管理 @Prop
 */

@Component
export struct PropPage{
  // @Prop totalNumber:number
  @Link totalNumber:number
  build(){
    Row(){
      Text(`总的数量为：${this.totalNumber}`)
      Button('将totalNumber+1').onClick(()=>{
        this.totalNumber++
      })
    }
  }
}