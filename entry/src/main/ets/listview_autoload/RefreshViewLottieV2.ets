import lottie, { AnimationItem } from "@ohos/lottie";

@ComponentV2
export struct RefreshViewLottieV2 {
  private lottieRenderingSettings: RenderingContextSettings = new RenderingContextSettings(true)
  private lottieCanvasRenderingContext: CanvasRenderingContext2D =
    new CanvasRenderingContext2D(this.lottieRenderingSettings)
  private lottieAnimateItem: AnimationItem | null = null
  // @State path: string = 'common/lottie/refresh_pull_lottie.json';
  private lottieAnimateName: string = "common_page_loading_full"; // 动画名称
  marginTop: number = 0
  // 指定大小
  widthAndHeight?: number
  // 隐藏文字
  @Param @Require showText: boolean = true
  // 用于触发动画重新加载的状态变量
  @Local needReload: boolean = false
  // @Prop @Watch('onRefreshStateChange') refreshState: RefreshStatus
  @Param @Require refreshState: RefreshStatus
  @Param @Require refreshOffset: number

  @Monitor("refreshOffset")
  showEmptyLayoutListener(): void {

    if (this.refreshState == RefreshStatus.Refresh) {
      //下拉超过触发阈值（松开即可触发刷新） 固定展示某帧
      // this.fileAnimateItem?.goToAndPlay(120 * 25 * (this.refreshOffset > 65 ? 65 : this.refreshOffset) / 43)
      // this.fileAnimateItem?.play()

    } else {
      //随手动
      let dis = this.refreshOffset / 80.0
      if (dis > 0.9) {
        dis = 0.9
      }
      let time = this.lottieAnimateItem?.getDuration() as number
      //控制动画画面停止在某一帧或某个时刻
      this.lottieAnimateItem?.goToAndStop(Number(dis * time) * 1000, false)
    }
  }

  // 页面显示时（包括返回）触发动画重新加载
  onPageShow(): void {
    console.info('onPageShow')
    this.needReload = !this.needReload; // 改变状态触发重建

  }

  build() {
    Column() {
      // 使用状态变量触发Canvas重建
      Canvas(this.lottieCanvasRenderingContext)
        .width(this.widthAndHeight ?? 86)
        .height(this.widthAndHeight ?? 43)
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
    .height('100%')
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
      path: this.refreshState == RefreshStatus.Refresh ? "common/lottie/refresh_loading_lottie.json" :
        "common/lottie/refresh_pull_lottie.json",
    })
  }
}
