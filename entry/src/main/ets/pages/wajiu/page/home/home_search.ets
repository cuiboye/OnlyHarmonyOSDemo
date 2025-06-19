@Component
@Entry
export default struct HomeSearch {
  build() {
    Row() {
      Row() {
        Image($r('app.media.app_home_tabbar_seach'))
          .width('15')
          .margin({ left: 10 })
        Text('掌阅珍藏干红——2018')
          .fontColor('#a3a2a2')
          .fontSize(15)
          .margin({ left: 10 })
      }
      .borderRadius(8)
      .height(30)
      .backgroundColor('#bdffffff')
      .layoutWeight(1)

      Image($r('app.media.home_customer_service')).width(20).margin({ left: 10 })
      Image($r('app.media.app_index_message_new')).width(20).margin({ left: 10 })
    }
    .backgroundColor($r('app.color.f56e1d'))
    .padding({ left: 18, right: 18,bottom:10})
    .width('100%')
  }
}