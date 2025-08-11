import { ComponentContent } from '@kit.ArkUI';

/**
 * openCustomDialog-进入退出动画
 */
@Entry
@Component
struct OpenCustomDialogPage {
  @State message: string = 'Hello World';
  @State delayNumber: number = 3000

  build() {
    RelativeContainer() {
      Button('打开dialog').onClick(() => {
        let uiContext = this.getUIContext()
        const promptAction = uiContext.getPromptAction()

        let contentNode = new ComponentContent<boolean>(uiContext, wrapBuilder(ActionBuilder), false)
        promptAction.openCustomDialog(contentNode, {
          autoCancel: true,//点击外部弹框消失
          // isModal:false,//false为不显示背景阴影
          alignment: DialogAlignment.Bottom,
          transition: TransitionEffect.opacity(0.99).animation({ duration: 200 }),
          onWillDismiss: (action) => {
            animateTo({
              duration: 200,
              onFinish: () => {
                action.dismiss()
              }
            }, () => {
              contentNode.update(true)
            })
          }
        })
      }).margin({top:100})
    }
    .height('100%')
    .width('100%')
  }
}

@Builder
export function ActionBuilder(isEnd: boolean) {
  Column() {
    Row() {
      Text('2173781637163')
    }.width('100%')
    .height(40)

    Row() {
      Text('2173781637163')
    }.width('100%')
    .height(59)

    Row() {
      Text('2173781637163')
    }.width('100%')
    .height(90)
  }
  .translate({
    y: isEnd ? '100%' : 0
  })
  .backgroundColor(Color.White)
  .transition(TransitionEffect.translate({ y: '100%' }).animation({ duration: 200 }))
}