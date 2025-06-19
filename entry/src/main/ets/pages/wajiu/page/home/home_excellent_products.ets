/**
 * 名庄优品
 */
import { FamousProductListEntity } from '../../TaskEntity'
@Component
export default struct HomeExcellentProducts {
  @Consume('famousProductList') famousProductList:FamousProductListEntity[]
  build() {
    if (this.famousProductList && this.famousProductList.length > 0) {
      Column() {
        Row() {
          Text('名庄优品')
            .layoutWeight(1)
            .fontColor('#e8eb1100')
            .fontWeight(FontWeight.Bold) //设置字体为粗体
            .fontStyle(FontStyle.Italic) //设置字体为斜体
            .fontSize(17)
            .margin({ left: 17 })
          Row() {
            Text('更多')
              .fontColor('#7b7b7b')
              .fontSize(14)
            Image($r('app.media.home_main_right_arrow'))
              .height(12)
              .margin({ left: 7 })
          }
          .margin({ right: 17 })
        }
        .linearGradient({
          repeating: true,
          direction: GradientDirection.Bottom,
          colors: [[0xffe4d2, 0], [0xffffff, 1]]
        })
        .borderRadius({
          topLeft: 8,
          topRight: 8
        })
        .padding({ top: 20 })


        List({ space: 12 }) {
          ForEach(this.famousProductList, (item: FamousProductListEntity) => {
            ListItem() {
              Column() {
                //这里加一个Row的作用是要在图片外层加一个边框，但是图片如果宽度太窄的话边框只会包裹图片不能充满左右
                Row() {
                  Image('https://image.59cdn.com/static/upload/image/product/20240312/o_17102246991345.png')
                    .height(179)
                    .backgroundColor(Color.White)
                    .alignSelf(ItemAlign.Center)
                }
                .padding({ top: 10, bottom: 10 }) //设置图片上下的内边距
                .width('100%') //设置图片的外层宽度为100%
                .border({ color: '#c5c5c5', width: 1 })
                .justifyContent(FlexAlign.Center)

                Text(item.cname)
                  .fontColor('#343434')
                  .fontSize(14)
                  .margin({ top: 6 })
                  .maxLines(1) //最大一行
                  .align(Alignment.BottomEnd)
                  .textOverflow({ overflow: TextOverflow.Ellipsis }) //末尾省略

                //富文本
                Text('我是Text') {
                  Span('¥')
                    .fontColor('#ec6e20')
                    .fontSize(14)
                  Span('16')
                    .fontColor('#ec6e20')
                    .fontSize(16)
                  Span('.')
                    .fontColor('#ec6e20')
                    .fontSize(14)
                  Span('00')
                    .fontColor('#ec6e20')
                    .fontSize(14)
                  Span('/瓶')
                    .fontColor('#ec6e20')
                    .fontSize(14)
                }
                .margin({ top: 5 })
                .maxLines(1) //最大一行
                .textOverflow({ overflow: TextOverflow.Ellipsis }) //末尾省略
              }
              .width('100%') //设置每个item宽度充满
              .alignItems(HorizontalAlign.Start)
              .backgroundColor(Color.White)
            }
            .margin({ right: 8 })
          })
        }
        .width('100%')
        .borderRadius({
          bottomLeft: 8,
          bottomRight: 8
        })
        .padding({ left: 11, right: 11, top: 20,bottom:10 })
        .lanes(2)
        .backgroundColor(Color.White)
      }
      .margin({ left: 13, right: 13,top:8 })
    }
  }
}