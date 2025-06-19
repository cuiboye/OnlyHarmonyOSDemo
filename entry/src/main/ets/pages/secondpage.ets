import router from '@ohos.router'
@Entry
@Component
struct Secondpage {
  @State message: string = 'Hello World'

  build() {
    Column() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('返回第一个页面').onClick(()=>{
          router.back();
        })
      }
      .width('100%')
      //列表使用List，List一般和ListItem搭配使用，ForEach循环遍历子Widget
      //space:10 设置Item之间的间距

      // onScroll：列表滑动时触发，返回值 scrollOffset 为滑动偏移量，scrollState 为当前滑动状态。
      // onScrollIndex：列表滑动时触发，返回值分别为滑动起始位置索引值与滑动结束位置索引值。
      // onReachStart：列表到达起始位置时触发。
      // onReachEnd：列表到底末尾位置时触发。
      // onScrollStop：列表滑动停止时触发。
      List({space:5}){
        ForEach([1,2,3,4,8],(item:number)=>{
          ListItem(){
            Column(){
              Text('Hello'+item).backgroundColor('#00a0e9').height(500)
              Text('hi')
            }
          }
        })
      }.layoutWeight(1)
      // .listDirection(Axis.Horizontal)//横向滚动

      //这个底部有问题：显示不全，List也有同样的问题
      //解决：https://www.jianshu.com/p/9aabe339404d?v=1705983751809
      // Grid() {
      //   ForEach([1,2,3,4,8,11,22,3], (item: number) => {
      //     GridItem() {
      //       Column(){
      //         Text(item+'')
      //           .backgroundColor('#00a0e9').fontSize(40).height(500)
      //         Text('1111')
      //       }
      //     }
      //   })
      // }
      // .columnsTemplate('1fr 1fr')
      // .columnsGap(10)
      // .rowsGap(10).layoutWeight(1)
    }
    .height('100%')
  }
}