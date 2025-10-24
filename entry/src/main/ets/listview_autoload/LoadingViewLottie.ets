import lottie, { AnimationItem } from "@ohos/lottie";

@Component
export struct LoadingViewLottie {
  private lottieRenderingSettings: RenderingContextSettings = new RenderingContextSettings(true)
  private lottieCanvasRenderingContext: CanvasRenderingContext2D =
    new CanvasRenderingContext2D(this.lottieRenderingSettings)
  private lottieAnimateItem: AnimationItem | null = null;
  private lottieAnimateName: string = "common_page_loading_full"; // 动画名称
  marginTop: number = 0
  // 指定大小
  widthAndHeight?: number
  // 隐藏文字
  showText: boolean = true
  // 用于触发动画重新加载的状态变量
  @State needReload: boolean = false

  // 页面显示时（包括返回）触发动画重新加载
  onPageShow(): void {
    this.needReload = !this.needReload; // 改变状态触发重建

  }

  build() {
    Column() {
      // 使用状态变量触发Canvas重建
      Canvas(this.lottieCanvasRenderingContext)
        .width(this.widthAndHeight ?? 64)
        .height(this.widthAndHeight ?? 66)
        .key(this.needReload.toString()) // 关键：状态变化时重建Canvas
        .onReady(() => {
          this.lottieAnimation(true);
        })
        .onDisAppear(() => {
          if (this.lottieAnimateItem) {
            this.lottieAnimateItem.pause();
          }
        })
        .margin({ top: this.marginTop })

      if (this.showText) {
        Text('加载中...')
          .fontSize(14)
          .fontColor('#999999')
      }
    }
    .width('100%')
    .height('60%')
  }

  lottieAnimation(autoplay: boolean) {
    // 先清除可能存在的旧实例
    if (this.lottieAnimateItem) {
      this.lottieAnimateItem.destroy();
    }

    // 重新加载动画
    this.lottieAnimateItem = lottie.loadAnimation({
      container: this.lottieCanvasRenderingContext,
      renderer: 'canvas',
      loop: true,
      autoplay: autoplay,
      name: this.lottieAnimateName,
      contentMode: 'Contain',
      path: "common/lottie/common_page_loading_full.json",
    })
  }
}
