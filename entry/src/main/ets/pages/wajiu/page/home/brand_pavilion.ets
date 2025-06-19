import { BrandHallEntity } from '../../TaskEntity'
/**
 * 品牌馆
 */
@Component
export default struct BrandPavilion {
  @Consume('brandHallList') brandHallList: BrandHallEntity[]

  build() {
    Column() {
      Stack() {
        Image($r('app.media.app_home_guojiaguan_title_background')).height(30)
        Text('- 品牌馆 -')
          .fontColor('#ffffff')
          .fontWeight('bold')
      }
      .width('100%')
      //不要在外层设置borderRadius，因为外层的宽度是100%，没有背景色，是看不出来的
      .borderRadius({topLeft:8,topRight:8})
      .linearGradient({
        repeating: true,
        direction: GradientDirection.Bottom,
        colors: [[0xffe4d2, 0], [0xffffff, 1]]
      })

      if(this.brandHallList && this.brandHallList.length>0){
        List({space:15}){//设置List的item之间的间隔
          ForEach(this.brandHallList,(item:BrandHallEntity)=>{
            ListItem(){
              Image(item.appPictrueAddress)
                .height(60)
                .border({color:'#eeeeee',width:1}).borderRadius(1000)
                .clip(new Circle({ width: 60, height: 60 }))//设置图片为圆角
            }
          })
        }
        .padding({top:15,left:13,right:13,bottom:15})
        .width('100%')
        .backgroundColor(Color.White)
        .borderRadius({bottomLeft:8,bottomRight:8})
        .listDirection(Axis.Horizontal)
        .scrollBar(BarState.Off)//隐藏进度条
      }
    }
    .margin({top:8})
    .width('100%')
    .padding({left:13,right:13})

  }
}