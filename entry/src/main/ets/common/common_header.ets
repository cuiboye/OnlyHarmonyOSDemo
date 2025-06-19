/**
 * 自定义header
 */
@Component
export struct CommonHeader{
  @StorageProp('topStatusHeight') topStatusHeight: number = 0
  showTitleBar:boolean = true;
  title:string = '';

  build() {
    Column() {
      //状态栏，这里加个状态栏高度是因为系统的状态栏会覆盖掉自己的组件
      Row()
        .width('100%')
        .height(px2vp(this.topStatusHeight))
        .backgroundColor($r('app.color.f56e1d'))
      if(this.showTitleBar){
        Column() {
          Column() {
            Text(this.title)
              .fontSize(20)
              .fontColor(Color.White)
          }
          .height(50)
          .justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .backgroundColor($r('app.color.f56e1d'))
      }
    }
    // .height('100%')
  }
}