import router from '@ohos.router'
import { CommonHeader } from '../../common/common_header'
/**
 * 列表中的共享元素转场动画
 */
interface Params extends Object{
  index?:number//index可以为空
}

@Entry
@Component
struct ShareListSecondPage {
  imageArray: Resource[] = [
  $r('app.media.share1'),
  $r('app.media.share2'),
  $r('app.media.share3'),
  $r('app.media.share4'),
  $r('app.media.share5'),
  $r('app.media.share6'),
  ]

  private index: number = 0
  aboutToAppear(){
     //将 router.getParams 中的值转为对象，更加方便的操作
   this.index = (router.getParams() as Params)?.index??0//?.取index的值
    console.log(`this index is ${this.index}`)
  }

  build() {
    Column() {
      CommonHeader({ title: '操作列表中的共享元素动画' })
      Image(this.imageArray[this.index])
        .width('100%')
        .sharedTransition(this.index.toString(),{duration:600,curve:Curve.Smooth,delay:100})
    }
    .height('100%')
  }
}