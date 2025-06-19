/**
 * 自定义顶部状态栏，只有高度展位，用于特殊场景比如吸顶效果
 */
@Component
export struct CommonStatusBar{
  @StorageProp('topStatusHeight') topStatusHeight: number = 0
  showTitleBar:boolean = true;
  title:string = '';

  build() {
    Column() {
      //状态栏
      Row()
        .width('100%')
        .height(px2vp(this.topStatusHeight))
        .backgroundColor($r('app.color.f56e1d'))
    }
  }
}