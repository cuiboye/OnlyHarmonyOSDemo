import { ImageKnifeComponent, ImageKnifeOption } from '@ohos/imageknife';

/**
 * 图片组件，基于ImageKnifeComponent封装
 * 使用说明&源码：https://gitee.com/openharmony-tpc/ImageKnife
 */
@Component
export struct ImageKnifeView {
  @Prop config: ImageKnifeOption

  aboutToAppear(): void {
  }

  build() {
    ImageKnifeComponent({ imageKnifeOption: this.config })
  }
}