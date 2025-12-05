import { CommonHeader } from '../common/common_header'
import { common } from '@kit.AbilityKit';
import { HMRouter } from '@hadss/hmrouter';
import { NavigationConstants } from '../common/constants/NavigationConstants';
import { LogUtils } from '../common/utils/LogUtils';

/**
 * Visible监听
 */
@HMRouter({pageUrl:NavigationConstants.VISIBLE_MONITOR_PAGE})
@Component
export struct VisibleMonitorPage {
  context = getContext(this) as common.UIAbilityContext
  build() {
    Column() {
      CommonHeader()

      Scroll(){
        Column(){
          Row().width('100%').height(300).backgroundColor(Color.Black)
          Row().width('100%').height(300).backgroundColor(Color.Red)
          Row().width('100%').height(300).backgroundColor(Color.Green)
          Row().width('100%').height(300).backgroundColor(Color.Blue)
          Row().width('100%').height(300).backgroundColor(Color.Orange)
            .onVisibleAreaChange([0.0, 1.0], (isExpanding) => {
              if (isExpanding) {
                LogUtils.i("onVisibleAreaChange：显示")
              }else {
                LogUtils.i("onVisibleAreaChange：隐藏")
              }
            })
        }
      }

    }
    .height('100%')
    .width('100%')
  }
}