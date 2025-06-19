/**
 * 多态样式 stateStyles
 */
import matrix4 from '@ohos.matrix4'
import prompt from '@ohos.prompt';
@Entry
@Component
struct MutilStylePage {
  @State message: string = 'Hello World'
  @State isEnable: boolean = true

  //按下状态
  @Styles pressedStyles(){
    .backgroundColor("#ED6F21")
    .borderRadius(10)
    .borderStyle(BorderStyle.Dashed)
    .borderWidth(2)
    .borderColor("#33000000")
    .width(120)
    .height(30)
    .opacity(1)
  }

  //正常状态
  @Styles normalStyles() {
    .backgroundColor("#0A59F7")
    .borderRadius(10)
    .borderStyle(BorderStyle.Solid)
    .borderWidth(2)
    .borderColor("#33000000")
    .width(100)
    .height(25)
    .opacity(1)
  }

  //禁用状态
  @Styles disabledStyles() {
    .backgroundColor("#E5E5E5")
    .borderRadius(10)
    .borderStyle(BorderStyle.Solid)
    .borderWidth(2)
    .borderColor("#2a4c1919")
    .width(90)
    .height(25)
    .opacity(1)
  }

  //可用状态
  @Styles enabledStyles(){
    .backgroundColor("#0A59F7")
    .borderRadius(20)
    .borderStyle(BorderStyle.Solid)
    .borderWidth(2)
    .borderColor(Color.Gray)
    .width(100)
    .height(25)
    .opacity(1)
  }

  build() {
    Column() {
      Button('click')
        .stateStyles({
          normal: this.normalStyles,
          pressed: this.pressedStyles
        })

      Text(this.isEnable == true ? "effective" : "disabled")
        .fontSize(14)
        .fontColor(Color.White)
        .enabled(this.isEnable)
        .stateStyles({
          //disabled需要搭配enabled一起使用，否则不会生效
          disabled: this.disabledStyles,//禁用状态
          normal: this.enabledStyles,//正常状态
        })

        .onClick(()=>{
          console.log('can click')
        })
        .textAlign(TextAlign.Center)
      Text("control disabled")
        .onClick(() => {
          this.isEnable = !this.isEnable
          console.log(`${this.isEnable}`)
        })
    }
    .backgroundColor($r('app.color.eeeeee'))
    .height('100%')
  }
}