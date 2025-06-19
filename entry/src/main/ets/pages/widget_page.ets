/**
 * 各种组件
 */
@Entry
@Component
struct WidgetPage {
  @State message: string = 'Hello World'

  build() {
    Row() {
      Toggle({type: ToggleType.Button, isOn: true }) {
        Text('status button')
          .fontColor('#182431')
          .fontSize(12)
      }.width(100).selectedColor(Color.Pink)

      Row() {
        Text('姓名:')
          .fontSize(15)
          .fontColor('#000')
          .fontWeight(FontWeight.Bold)
        //TextInput这里有一个坑，它的宽度默认是充满宽度的
        TextInput({placeholder: '请输入用户名：', text: 'sdf'})
          .type(InputType.Normal)
          .backgroundColor(Color.Red)
            // .width('90%')
          .onChange((value) => {
            // this.userName = value;
          }).layoutWeight(1)
      }
    }
    .height('100%')
  }
}