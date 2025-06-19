
/**
 * 订单和充值
 */
@Component
export default struct HomeOrder{
  build(){
    Row() {
      Row() {
        Image($r('app.media.app_home_dingdan_blue')).width(20)
        Text('订单查询')
          .fontSize(16)
          .fontColor($r('app.color.343434'))
          .margin({ left: 8 })
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)

      Divider().strokeWidth(1).color($r('app.color.dfdfdf')).vertical(true)
      Row() {
        Image($r('app.media.app_index_chongzhi_new')).width(20)
        Text('充值')
          .fontSize(16)
          .fontColor($r('app.color.343434'))
          .margin({ left: 8 })
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
    }
    .margin({ left: 13, right: 13 })
    .backgroundColor(Color.White)
    .borderRadius(8)
    .height(43)
    .justifyContent(FlexAlign.SpaceBetween)
  }
}
