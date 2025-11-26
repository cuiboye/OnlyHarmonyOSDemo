import { CommonHeader } from '../common/common_header';
import { HMRouter } from '@hadss/hmrouter';
import { NavigationConstants } from '../common/constants/NavigationConstants';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { ColorUtils } from '../common/utils/ColorUtils';


@HMRouter({ pageUrl: NavigationConstants.DARK_MODE_ADAPTATE_PAGE })
@Component
export struct DarkModelAdapterPage {
  @StorageProp('currentColorMode') currentColorMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT

  build() {
    Column() {
      CommonHeader({title:'深色模式适配'})
      //text_color这个颜色值需要在base/element/color.json和dark/element/color.json都存在
      //base/element/color.json中的颜色值是非深色模式下的
      //dark/element/color.json中的颜色值是深色模式下的
      Text('文字的深色模式适配')
        .fontColor($r('app.color.text_color'))

      Text('你好')
        .fontColor(this.getTextColor())

      Image("https://edu-wenku.bdimg.com/v1/na/app/Word%E7%94%9F%E6%88%90PPT%403x-1703228707089.png")
        .width(30)
        .height(30)
        .objectFit(ImageFit.Contain)
        .colorFilter(
          this.currentColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
          ColorUtils.getInvertColorMatrix() : ColorUtils.getOriginalColorMatrix()
        )
    }
    .height('100%')
    .width('100%')
  }

  getTextColor(){
    //如果是在openCustomDialog中或其他的组件中颜色值不能通过切换深色模式和非深色模式更新的话，可以使用下面的方式来更新颜色值
    if (this.currentColorMode == ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      return '#ffffff'
    } else {
      return '#333333'
    }
  }
}
