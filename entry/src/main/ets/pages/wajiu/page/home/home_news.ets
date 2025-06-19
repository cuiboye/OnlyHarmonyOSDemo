/**
 * 新闻
 */
import { AnnouncementAppNewIndexCategoriesEntity } from '../../TaskEntity'
@Component
export default struct HomeNews {
  @Consume('newsList') newsList:AnnouncementAppNewIndexCategoriesEntity[]
  build() {
    Column() {
      Row(){
        Image($r('app.media.app_home_xiaowakuaibao'))
          .margin({ left: 18 })
          .height(15)
          .backgroundColor(Color.White)
        Divider()
          .margin({ left: 10, right: 7 })
          .vertical(true)
          .color($r('app.color.dfdfdf'))
          .strokeWidth(1)
          .height(12)

        if (this.newsList && this.newsList.length > 0) {
          Swiper() {
            ForEach(this.newsList, (item: AnnouncementAppNewIndexCategoriesEntity, index?: number) => {
              Text(item.indexName)
                .fontSize(13)
                .fontColor($r('app.color.343434'))
                .margin({ right: 10 })
                .height(25)
                .maxLines(1)
                .textOverflow({overflow:TextOverflow.Ellipsis})
            })
          }
          .onChange((index: number) => {
            console.log('index is $in')
          })
          .height(25)
          .loop(true)
          .autoPlay(true)
          .layoutWeight(1)
          .vertical(true)
          .interval(4000)
          .indicator(Indicator.dot()//indicator隐藏指示器
            .itemWidth(15)
            .itemHeight(15)
            .selectedItemWidth(15)
            .selectedItemHeight(15)
            .color('#00000000')
            .selectedColor('#00000000'))
        }
      }
      .margin({ top: 8, left: 13, right: 13 })
      .height(43)
      .borderRadius(8)
      .backgroundColor(Color.White)
      Row() {
        Image('https://image.59cdn.com/app/release/index/HotNewProduct/TopSellerList.png')
          .layoutWeight(1)
        Column() {
          Image('https://image.59cdn.com/static/upload/image/app/20230313/o_1678679039491.png')
            .objectFit(ImageFit.Auto)
          Image('https://image.59cdn.com/app/release/index/HotNewProduct/HotNewProduct.png')
            .margin({ top: 8 })
            .objectFit(ImageFit.Fill)
        }
        .justifyContent(FlexAlign.SpaceEvenly)
        .margin({ left: 8 })
        .layoutWeight(1)
      }
      .margin({ left: 13, right: 13, top: 8 })
    }

  }
}
