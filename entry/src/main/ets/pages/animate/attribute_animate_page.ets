/**
 * 动画-属性动画
 * 1）显式动画把要执行动画的属性的修改放在闭包函数中触发动画，而属性动画则无需使用闭包，把animation属性加在要做属性动画的组件的属性后即可。
 * 2）其入参为动画参数。想要组件随某个属性值的变化而产生动画，此属性需要加在animation属性之前。有的属性变化不希望通过animation产生属性动
 * 画，可以放在animation之后。
 */
@Entry
@Component
struct AttributeAnimatePage {
  @State mWidget:number = 100
  @State mHeight:number = 50
  @State mColor:Color = Color.Blue
  @State flag:boolean = false

  build() {
    Column() {
      Button('text')
        .width(this.mWidget)
        .height(this.mHeight)
        // animation只对其上面的width、height属性生效，时长为1000ms，曲线为Ease
        .animation({duration:2000,curve:Curve.Ease})
        // animation对下面的backgroundColor属性不生效
        // backgroundColor会直接跳变，不会产生动画
        .backgroundColor(this.mColor)
        .margin({top:50})
      Button('click me')
        .fontSize(12)
        .onClick(()=>{
          if(this.flag){
            this.mWidget = 100
            this.mHeight = 50
            this.mColor = Color.Blue
          }else {
            this.mWidget = 200
            this.mHeight = 100
            this.mColor = Color.Pink
          }
          this.flag = !this.flag
        })
    }
    .height('100%')
  }
}