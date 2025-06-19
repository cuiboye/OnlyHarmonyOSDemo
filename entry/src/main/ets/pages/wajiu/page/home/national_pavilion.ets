/**
 * 国家馆
 */
import { BannerInternationalEntity } from '../../TaskEntity'
@Component
export default struct NationalPavilion {
  @Consume('bannerInternationalList') bannerInternationalList : BannerInternationalEntity[]

  build() {
    Column() {
      Stack() {
        Image($r('app.media.app_home_guojiaguan_title_background')).height(30)
        Text('- 国家馆 -')
          .fontColor('#ffffff')
          .fontWeight('bold')
      }
      .width('100%')
      //不要在外层设置borderRadius，因为外层的宽度是100%，没有背景色，是看不出来的
      .borderRadius({ topLeft: 8, topRight: 8 })
      .linearGradient({
        repeating: true,
        direction: GradientDirection.Bottom,
        colors: [[0xffe4d2, 0], [0xffffff, 1]]
      })

      if (this.bannerInternationalList && this.bannerInternationalList.length > 0) {
        List({ space: 15 }) { //设置List的item之间的间隔
          ForEach(this.bannerInternationalList, (item: BannerInternationalEntity) => {
            ListItem() {
              Image(item?.picture)
                .height(60)
                .backgroundColor(Color.Blue)
                .objectFit(ImageFit.Fill)
                .clip(new Circle({ width: 60, height: 60 })) //设置图片为圆角
            }
          })
        }
        .padding({ top: 15, left: 13, right: 13, bottom: 15 })
        .width('100%')
        .backgroundColor(Color.White)
        .borderRadius({ bottomLeft: 8, bottomRight: 8 })
        .listDirection(Axis.Horizontal)
        .scrollBar(BarState.Off)//隐藏进度条
      }
    }
    .margin({ top: 8 })
    .width('100%')
    .padding({ left: 13, right: 13 }) //设置外层的宽度为屏幕的宽度
    //   // 设置组件自身的宽度，缺省时使用元素自身内容需要的宽度。若子组件的宽大于父组件的宽，则会画出父组件的范围。
  }
}