import router from '@ohos.router'
@Entry
@Component
struct SharedAnimateSecondPage {
  @State message: string = 'Hello World'

  build() {
    Column() {
      Text('SharedTransition dest page')
        .fontSize(16)
        .sharedTransition('shanredText',{
          duration:500,
          curve:Curve.Linear,
          type:SharedTransitionEffectType.Static
        })
        .margin({top:10})
      Image($r('app.media.app_icon'))
        .width(150)
        .height(150)
        .sharedTransition('sharedImage1',{
          duration:500,
          curve:Curve.Linear
        })
        .onClick(()=>{
          router.back()
        })
    }
    .height('100%')
  }
}