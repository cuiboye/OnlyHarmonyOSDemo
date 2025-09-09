import { HMRouter } from '@hadss/hmrouter'
import { NavigationConstants } from '../common/constants/NavigationConstants'

/**
 * 各种组件
 */
@HMRouter({ pageUrl: NavigationConstants.WIDGET_PAGE })
@Component
export struct WidgetPage {
  @State message: string = 'Hello World'

  build() {
    Row() {
      Row() {
        Text('status button')
          .fontColor('#182431')
          .fontSize(12)
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
          }).layoutWeight(1)//让TextInput沾满剩余宽度
      }
    }
    .height('100%')
  }
}