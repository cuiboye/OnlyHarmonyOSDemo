@Entry
@Component
struct SwiperDeemoPage {
  //loop:是否循环播放
  //autoPlay:是否自动轮播(注意：如果设置了loop为false，那么播放到最后一个的时候会暂停)
  //interval:自动播放的间隔
  //indicatorStyle:设置指示器的样式
  //SwiperController：通过控制器来切换页面
  //indicator:指示器单个的样式，SDK10版本才支持
  //vertical：滚动方向，默认为水平滚动，true表示垂直滚动
  private swiperController: SwiperController = new SwiperController()

  build() {
    Column(){
      Row() {
        Swiper(this.swiperController){
          Text('页面1').textAlign(TextAlign.Center).backgroundColor(Color.Red)
          Text('页面2').textAlign(TextAlign.Center).backgroundColor(Color.Orange)
          Text('页面3').textAlign(TextAlign.Center).backgroundColor(Color.Blue)
        }
        .indicatorStyle({
          size: 30,
          color: Color.Red,//默认颜色
          selectedColor:Color.Orange,//选中颜色
          left: 0
        })
        .loop(false)
        .autoPlay(false)
        .interval(1000)
        .width('100%')
        .height(300)
      }
      Row({space:20}){
        Button('showPrevious').onClick(()=>{
          //显示上一个
          this.swiperController.showPrevious()
        })
        Button('showNext').onClick(()=>{
          //显示下一个
          this.swiperController.showNext()
        })
      }
    }.height('100%')
  }
}