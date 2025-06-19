
/**
 * List的简单使用
 */
@Entry
@Component
struct ListPage {
  //初始化Scroller，Scroller目前只支持绑定到Scroll和List 。
  private scroller:Scroller = new Scroller()

  private arr: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  build() {
    Column() {
      Row().height(60)
      Button('滚动到顶部').height(50).onClick(()=>{
        this.scroller.scrollEdge(Edge.Top)
      })
      Button('滚动到底部').height(50).onClick(()=>{
        this.scroller.scrollEdge(Edge.Bottom)
      })
      Button('滚动到第3个元素').height(50).onClick(()=>{
        this.scroller.scrollToIndex(2)
      })
      List({space:10,scroller:this.scroller}){//space：设置每个item之间的间隔
        ForEach(this.arr, (item:number) => {
          ListItem(){
            Column(){
              Text(item.toString())
                // .width('90%')
                // .height(150)
                .backgroundColor(Color.Gray)
                .borderRadius(15)
                .fontSize(16)
                .textAlign(TextAlign.Center)
                .margin({ top: 10 })
              Text('底部')
            }
          }.swipeAction({ end: this.deleteTask() }) //swipeAction:ListView的侧滑效果
        }, (item:number) => JSON.stringify(item))
      }
      .lanes(2)//设置List为两列
      .alignListItem(ListItemAlign.Center)//设置List在交叉轴上的对齐方式
      .divider({strokeWidth:1,color:Color.Blue,startMargin:20,endMargin:20})
      .onScrollIndex((start: number, end: number) => {
        console.log(`Scroll start index is${start},end index is${end},`)
      })
      .onScroll((scrollOffset: number, scrollState: ScrollState)=>{
        console.log(`Scroll 滚动距离为：${scrollOffset}`)
      })
      .onScrollStart(()=>{
        //开始滚动
        console.log('Scroll 开始滚动')
      })
      .onScrollStop(()=>{
        //停止滚动
        console.log('Scroll 停止滚动')
      })
      .onReachStart(()=>{
        console.log('Scroll 列表到达起始位置时触发')
      })
      .onReachEnd(()=>{
        console.log('Scroll 列表到底末尾位置时触发')
      })
      .layoutWeight(1)//如果除了List之外顶部还有其它的组件，需要设置下List的layoutWeight属性
    }
    .height('100%')
  }

  //删除任务
  @Builder deleteTask() {
    Button('删除')
  }
}