import { AnimationUtil } from '../common/utils/AnimationUtil';

let anmDuration: number = 800;
/**
 * @CustomDialog弹框由底部进入和消失的动画
 */
@CustomDialog
struct CustomDialogExample {
  @State showFlag: Visibility = Visibility.Visible;
  @State isAutoCancel: boolean = false;
  controller: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({}),
    autoCancel: false
  })

  build() {
    Column() {
      Text('我是内容')
        .fontSize(20)
        .margin({ top: 10, bottom: 10 })
        .backgroundColor('#FFFFFF')
        .textAlign(TextAlign.Center)
        .height(200)
        .width('100%')
        .onClick(() => {
          this.cancel();
        })
    }
    .justifyContent(FlexAlign.End)
    .width('100%')
    .height('100%')//这里必须设置为高度为100%，否则this.cancel();将不会执行

    .onClick(() => {
      if (this.isAutoCancel) {
        this.cancel();
      }
    })
    .visibility(this.showFlag)
    // 定义进场出场转场动画效果
    // .transition(AnimationUtil.transitionFromDown(1000))//如果需要设置dialog动画的时间的话那就设置这个
    .transition(AnimationUtil.transitionFromDown(500))
  }

  // 延迟关闭弹窗，让自定义的出场动画显示
  cancel() {
    this.showFlag = Visibility.None //这里需要是Visibility.Hidden，不能是Visibility.None,否则弹框会直接消失
    setTimeout(() => {
      this.controller.close()
    }, 200) //这个时间是背景色的展示和消失的时间
  }
}

@Entry
@Component
struct CustomDialogAnimation {
  // 是否允许点击遮障层退出
  @State isAutoCancel: boolean = true;
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({ isAutoCancel: this.isAutoCancel }),
    autoCancel: this.isAutoCancel,
    // 弹窗容器样式是否自定义
    customStyle: true,
    alignment: DialogAlignment.Bottom
  })

  build() {
    Column() {
      Button('点我')
        .onClick(() => {
          this.dialogController.open()
        }).margin({ top: 80 })

    }
    .width('100%')
    .height('100%')
    .margin({ top: 5 })
  }
}