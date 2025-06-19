/**
 * 动画-显示动画
 * 1）显示动画是通过animateTo的闭包代码导致的状态变化插入过渡动效。
 * 2）闭包内的变化均会触发动画，包括由数据变化引起的组件的增删、组件属性的变化等，可以做较为复杂的动画。
 * 3）显示动画除直接改变布局方式外，也可直接修改组件的宽、高、位置。
 * 4）transition函数的入参为组件内转场的效果，可以定义平移、透明度、旋转、缩放这几种转场样式的单个或者组合的转场效果，必须和animateTo一起使用才
 *   能产生组件转场效果。
 */
@Entry
@Component
struct DisPlayAAnimatePage {
  @State mWidget:number = 70
  @State mHeight:number = 40
  @State flag:boolean = false

  @State flagShow: boolean = true;
  @State show: string = 'show';

  build() {
    Column() {
      Button('改变宽高的动画')
        .onClick(() => {
          //animateTo除了可以改变组件属性如大小，也可以改变组件的颜色等等
          animateTo({ duration: 2000, curve: Curve.Ease }, () => {
            //1）显示动画：
            if (this.flag) {
              this.mWidget = 70
              this.mHeight = 40
              this.flag = false
            } else {
              this.mWidget = 140
              this.mHeight = 80
              this.flag = true
            }
          })
        })
        .fontSize(12)
        .width(this.mWidget)
        .height(this.mHeight)
        .margin({ top: 80 })

      // 组件的插入、删除过程即为组件本身的转场过程，组件的插入、删除动画称为组件内转场动画。通过组件
      // 内转场动画，可定义组件出现、消失的效果。
      // 组件内转场动画的接口为：
      // transition(value: TransitionOptions)
      // transition函数的入参为组件内转场的效果，可以定义平移、透明度、旋转、缩放这几种转场样式的单个或者组合的转
      // 场效果，必须和animateTo一起使用才能产生组件转场效果。
      Column() {
        Button(this.show)
          .height(30)
          .width(80)
          .margin({ top: 30 })
          .onClick(() => {
            if (this.flagShow) {
              this.show = 'hide'
            } else {
              this.show = 'show'
            }
            animateTo({ duration: 3000 }, () => {
              //动画闭包内控制Image组件的出现和消失
              this.flagShow = !this.flagShow
            })
          })
        //为Image的出现和消失配置不同的过渡效果
        if(this.flagShow){
          Image($r('app.media.app_icon'))
            .width(200)
            .height(200)
            .transition({
              type: TransitionType.Insert,
              translate: { x: 200, y: -200 }
            })
            .transition({
              type: TransitionType.Delete,
              opacity: 0,
              scale: {
                x: 0,
                y: 0
              }
            })
        }
      }
    }
    .height('100%')
  }
}