import lottie, { AnimationItem } from '@ohos/lottie';
import { common } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';

/**
 * ListView自定义Header刷新头部，使用lottie加载json动画
 */
@Component
export struct CustomHeaderLayoutView {
  private renderingSettings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.renderingSettings)
  private animateItem?: AnimationItem | null;
  private mLottieData?: object;
  animateName: string = "animation";

  aboutToAppear(): void {
    let context = getContext(this) as common.UIAbilityContext;
    const rm = context.resourceManager;
    rm.getRawFileContent("listview_refresh_header.json").then(value => {
      let rawFile = value;
      let textdecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true })
      let retStr = textdecoder.decodeWithStream(rawFile, { stream: false });
      console.log(`${JSON.stringify(retStr)}`)
      this.mLottieData = JSON.parse(retStr);
      lottie.destroy(this.animateName)
      this.animateItem = lottie.loadAnimation({
        container: this.canvasRenderingContext,
        renderer: 'canvas', // canvas 渲染模式
        loop: true,
        autoplay: true,
        name: this.animateName,
        animationData: this.mLottieData,
      })
    })
  }

  aboutToDisappear(): void {
    console.log('lottie aboutToDisappear')
    if (this.animateItem !== null) {
      this.animateItem?.destroy();
      this.animateItem = null;
    }
  }

  build() {
    Row() {
      Canvas(this.canvasRenderingContext)
        .width(70)
        .height(70)
        .onReady(() => {
          // 可在此生命回调周期中加载动画，可以保证动画尺寸正确
          lottie.destroy(this.animateName)
          this.animateItem = lottie.loadAnimation({
            container: this.canvasRenderingContext,
            renderer: 'canvas', // canvas 渲染模式
            loop: true,
            autoplay: true,
            name: this.animateName,
            animationData: this.mLottieData,
          })
        })
        .onDisAppear(() => {
          console.log('lottie onDisAppear')
          lottie.destroy(this.animateName);
        })
    }
  }
}