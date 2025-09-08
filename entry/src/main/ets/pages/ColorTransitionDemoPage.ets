import { HMRouter } from "@hadss/hmrouter"
import { NavigationConstants } from "../common/constants/NavigationConstants"

@HMRouter({ pageUrl: NavigationConstants.COLORTRANSITIONDEMO_PAGE })
@Component
export struct ColorTransitionDemoPage {
  @State colorValue: string = '#00a0e9' // 初始颜色
  @State offsetX: number = 0 // 滑动距离

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Text('滑动改变颜色')
        .fontSize(20)
        .fontColor(this.colorValue)
        .gesture(
          PanGesture()
            .onActionUpdate((event: GestureEvent) => {
              this.offsetX = event.offsetX // 获取水平滑动距离
              this.updateColor()
            })
        )
    }
    .padding({top:90})
    .width('100%')
    .height('100%')
  }

  // 根据滑动距离更新颜色
  private updateColor() {
    const startColor = 0x00a0e9
    const endColor = 0x00ffff
    const progress = Math.min(1, Math.max(0, this.offsetX / 200)) // 假设滑动范围200vp

    // RGB分量插值计算
    const r = (startColor >> 16) * (1 - progress) + (endColor >> 16) * progress
    const g = ((startColor >> 8) & 0xff) * (1 - progress) + ((endColor >> 8) & 0xff) * progress
    const b = (startColor & 0xff) * (1 - progress) + (endColor & 0xff) * progress

    this.colorValue = `#${Math.round(r).toString(16)}${Math.round(g).toString(16)}${Math.round(b).toString(16)}`
  }
}
