
import { HomeButtonAppNewIndexCategoriesEntity } from '../../TaskEntity'
/**
 * 棋盘格
 */
@Component
export default struct HomeButton{
  @Consume('homeButtonList') homeButtonList:HomeButtonAppNewIndexCategoriesEntity[]
  build(){
    if(this.homeButtonList && this.homeButtonList.length>0){
      Tabs(){
        TabContent(){
          Grid() {
            ForEach(this.homeButtonList.slice(0,8), (item: HomeButtonAppNewIndexCategoriesEntity) => {
              GridItem() {
                Column(){
                  //Grid中加载图片遇到的一个坑，某个图片的路径多个一个/，导致图片加载不出来
                  //这个图片在浏览器中是可以加载出来的，鸿蒙中的Image加载不出来
                  //加载不出来的图片
                  //https://image.59cdn.com//static/upload/image/app/20230112/o_1673513393408.png
                  //正常的图片
                  //https://image.59cdn.com/static/upload/image/app/20230112/o_1673513393408.png
                  Image(item.picture)
                    .width(53)
                    .height(53)
                  Text(item.indexName)
                    .fontColor('#989898')
                    .fontSize(14)
                    .margin({top:8})
                }
              }
            }, (item: HomeButtonAppNewIndexCategoriesEntity) => '' + item.indexName)
          }
          .rowsTemplate('1fr 1fr') //设置Grid为2行
          .columnsTemplate('1fr 1fr 1fr 1fr') //设置Grid为4列
          .height(200)
        }
        TabContent(){
          Grid() {
            ForEach(this.homeButtonList.slice(8,this.homeButtonList.length), (item: HomeButtonAppNewIndexCategoriesEntity) => {
              GridItem() {
                Column(){
                  //Grid中加载图片遇到的一个坑，某个图片的路径多个一个/，导致图片加载不出来
                  //这个图片在浏览器中是可以加载出来的，鸿蒙中的Image加载不出来
                  //加载不出来的图片
                  //https://image.59cdn.com//static/upload/image/app/20230112/o_1673513393408.png
                  //正常的图片
                  //https://image.59cdn.com/static/upload/image/app/20230112/o_1673513393408.png
                  Image(item.picture)
                    .width(53)
                    .height(53)
                  Text(item.indexName)
                    .fontColor('#989898')
                    .fontSize(14)
                    .margin({top:8})
                }
              }
            }, (item: HomeButtonAppNewIndexCategoriesEntity) => '' + item.indexName)
          }
          .rowsTemplate('1fr 1fr') //设置Grid为2行
          .columnsTemplate('1fr 1fr 1fr 1fr') //设置Grid为4列
          // .height(200)
        }
      }
      .height(200)
      .barHeight(0)
    }

    //
    //
    // //Swiper嵌套Grid时，切换页面会导致数据重新加载，页面会先空白然后数据再出来，暂时没有解决办法，也适用Tabs+Grid代替
    // Swiper() {
    //   Grid() {
    //     ForEach(this.homeButtonList.slice(0,8), (item: HomeButtonAppNewIndexCategoriesEntity) => {
    //       GridItem() {
    //         Column(){
    //           Image(item.picture)
    //             .width(53)
    //             .height(53)
    //           Text(item.indexName)
    //             .fontColor('#989898')
    //             .fontSize(14)
    //             .margin({top:8})
    //         }
    //       }
    //     })
    //   }
    //   .rowsTemplate('1fr 1fr') //设置Grid为2行
    //   .columnsTemplate('1fr 1fr 1fr 1fr') //设置Grid为4列
    //   .height(200)
    //
    //   Grid() {
    //     ForEach(this.homeButtonList.slice(8,this.homeButtonList.length), (item: HomeButtonAppNewIndexCategoriesEntity) => {
    //       GridItem() {
    //         Column(){
    //           Image(item.picture)
    //             .width(53)
    //             .height(53)
    //           Text(item.indexName)
    //             .fontColor('#989898')
    //             .fontSize(14)
    //             .margin({top:8})
    //         }
    //       }
    //     })
    //   }
    //   .rowsTemplate('1fr 1fr') //设置Grid为2行
    //   .columnsTemplate('1fr 1fr 1fr 1fr') //设置Grid为4列
    //   .height(180)
    // }
    //隐藏指示器，Indicator这个api在4.0才能使用
    // .indicator(Indicator.dot()
    //   .itemWidth(15)
    //   .itemHeight(15)
    //   .selectedItemWidth(15)
    //   .selectedItemHeight(15)
    //   .color('#00000000')
    //   .selectedColor('#00000000'))
  }
}