
/**
 * 滚动列表
 */
@Entry
@Component
struct ScrollPage {
  //初始化Scroller，Scroller目前只支持绑定到Scroll和List 。
  private scroller:Scroller = new Scroller()

  build() {
    Row() {
      Row().height(60)
      Scroll(this.scroller){
        Column(){
          Button('Hello1').height(300)
          Button('Hello2').height(300)
          Button('Hello3').height(300)
          Button('Hello4').height(300)
          Button('Hello5').height(300)
        }
      }
      .scrollable(ScrollDirection.Vertical)//设置滚动方向
      .onScroll((xOffset: number, yOffset: number)=>{
        //滚动事件回调, 返回滚动时水平、竖直方向的偏移量。
        console.log(`Scroll yOffset的滚动距离 ${yOffset}`)
      })
      .onScrollEdge((side: Edge) => {
        switch (side) {
          case Edge.Top: //滚动到顶部
            console.log(`Scroll 滚动到顶部`)
            break;
          case Edge.Bottom: //滚动到底部
            console.log(`Scroll 滚动到底部`)
            break;
          default:
            break;
        }
      })
      .onScrollStart(() => {
        //开始滚动
        console.log(`Scroll 开始滚动`)
      })
      .onScrollStop(() => {
        //滚动停止
        console.log(`Scroll 滚动停止`)
      })
      //设置Scroll的回弹效果
      .edgeEffect(EdgeEffect.Spring)
    }
    .height('100%')
  }
}