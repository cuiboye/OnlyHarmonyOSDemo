/**
 * 动画-共享元素转场动画
 */
import router from '@ohos.router';
@Entry
@Component
struct SharedAnimatePage {
  @State mWidget:number = 70
  @State mHeight:number = 40
  @State flag:boolean = false

  @State flagShow: boolean = true;
  @State show: string = 'show';

  build() {
    Column() {
        //共享元素转场动画，分为两种：
        //1）Exchange类型的共享元素转场
        //2）Static类型的共享元素转场
        Column(){
          Image($r('app.media.app_icon'))
            .width(50)
            .height(50)
            .sharedTransition('sharedImage1',{duration:2000,curve:Curve.Linear})
            .onClick(()=>{
              router.pushUrl({
                url:'pages/animate/shared_animate_secnod_page'
              })
            })
        }
    }
    .height('100%')
  }
}