import { ComponentContent } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * openCustomDialog-进入退出动画,直接使用系统提供的dialog和背景的动画
 * api19之上才能生效，19之下测试了没有生效
 */
@Entry
@Component
struct OpenCustomDialogWithAnimatorPage2 {
  private customDialogComponentId: number = 0
  @Builder
  customDialogComponent() {
    Row({ space: 50 }) {
      Button("这是一个弹窗")
    }.height(200).padding(5)
  }

  build() {
    Row() {
      Row({ space: 20 }) {
        Text('打开弹窗')
          .fontSize(30)
          .onClick(() => {
            this.getUIContext().getPromptAction().openCustomDialog({
              builder: () => {
                this.customDialogComponent()
              },
              isModal:true,
              showInSubWindow:false,
              maskColor: Color.Pink,
              maskRect:{ x: 20, y: 20, width: '90%', height: '90%' },

              dialogTransition: // 设置弹窗内容显示的过渡效果
              TransitionEffect.translate({ x: 0, y: 290, z: 0 })
                .animation({ duration: 4000, curve: Curve.Smooth }),// 四秒钟的偏移渐变动画

              maskTransition: // 设置蒙层显示的过渡效果
              TransitionEffect.opacity(0)
                .animation({ duration: 4000, curve: Curve.Smooth }) // 四秒钟的透明渐变动画

            }).then((dialogId: number) => {
              this.customDialogComponentId = dialogId
            })
              .catch((error: BusinessError) => {
                console.error(`openCustomDialog error code is ${error.code}, message is ${error.message}`)
              })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}