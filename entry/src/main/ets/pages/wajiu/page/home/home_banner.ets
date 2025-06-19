/**
 * home-搜索栏+轮播图
 */
import BreakpointSystem from '../../../../common/MediaData'
import { AppNewIndexCategoriesEntity } from '../../TaskEntity'
@Component
export default struct HomeBanner {
  //暂时先使用 @Provider+@Consume 的方式从父组件传递数组对象给子组件，使用 @Observed+@ObjectLink暂时无法实现，以后再研究
  @Consume('bannerList') bannerList:AppNewIndexCategoriesEntity[]

  //多屏幕适配
  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'sm'
  private breakpointSystem: BreakpointSystem = new BreakpointSystem()

  aboutToDisappear() {
    //取消屏幕监听
    this.breakpointSystem.unregister()
  }

  aboutToAppear(){
    //注册屏幕监听
    this.breakpointSystem.register()
  }

  build() {
    Column() {
      //轮播图，判断数组是不是为空，不能使用 if(this.bannerList){}判断，因为bannerList的初始值是[]
      if (this.bannerList && this.bannerList.length > 0) {
        if(this.currentBreakpoint === 'sm'){//比较使用 ===
          Swiper() {
            ForEach(this.bannerList, (bannerItem: AppNewIndexCategoriesEntity, index?: number) => {
              if (bannerItem) {
                Image(bannerItem.picture).width('100%') //给图片设置一个宽度，高度会自适应
              }
            })
          }
          .autoPlay(true)
          .margin({ top: 15, left: 13, right: 13 })
          // .padding({left:15,right:15})//设置宽度为100%后，左右的margin不生效了，只能设置padding
          // .width('100%') //不要设置Swiper的宽度为100%，否则左右的margin没有用
          .borderRadius(8) //设置Swiper的圆角
        }else {
          List({ space: 15 }) { //设置List的item之间的间隔
            ForEach(this.bannerList, (bannerItem: AppNewIndexCategoriesEntity) => {
              ListItem() {
                Image(bannerItem.picture).height(250) //给图片设置一个宽度，高度会自适应
                  .borderRadius(8)
              }
            })
          }
          .padding({ top: 15, left: 13, right: 13, bottom: 15 })
          .width('100%')
          .borderRadius(8)
          .listDirection(Axis.Horizontal)
        }
      }
    }.linearGradient({
      repeating: true, // 渐变颜色是否重复
      // direction: GradientDirection.Top, // 渐变方向
      colors: [[0xef7134, 0], [0xf4f4f4, 1]] //0和1可能代表的是顺序
    })
    .justifyContent(FlexAlign.Start)
  }
}