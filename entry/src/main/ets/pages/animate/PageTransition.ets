/**
 * 页面间的转场动画
 */
import { CommonHeader } from '../../common/common_header'
@Entry
@Component
struct PageTransition {
  @State message: string = 'Hello World'

  build() {
    Column() {
      CommonHeader({title:'页面之间的转场动画'})
      Image($r('app.media.bottom_transition'))
        .objectFit(ImageFit.Contain)
        .width('100%')
    }
    .height('100%')
  }

  //页面转场通过全局transition方法进行配置转场参数
  pageTransition(){
    // 页面入场组件：SlideEffect.Bottom 设置到入场时表示从下边滑入，出场时表示滑出到下边。
    PageTransitionEnter({duration:600,curve:Curve.Smooth})
      // .slide(SlideEffect.Bottom)
      .slide(SlideEffect.Right)
    // 页面退场组件：SlideEffect.Bottom 设置到入场时表示从下边滑入，出场时表示滑出到下边。
    PageTransitionExit({duration:600,curve:Curve.Smooth})
      // .slide(SlideEffect.Bottom)
      .slide(SlideEffect.Right)
  }
}