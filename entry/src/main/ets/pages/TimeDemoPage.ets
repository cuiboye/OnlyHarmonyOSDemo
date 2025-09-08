import { CommonHeader } from '../common/common_header';
import { TimeUtils } from '../common/utils/TimeUtils';
import { promptAction } from '@kit.ArkUI';
import { HMRouter } from '@hadss/hmrouter';
import { NavigationConstants } from '../common/constants/NavigationConstants';

/**
 * 时间相关操作
 */
@HMRouter({ pageUrl: NavigationConstants.TIMEDEMO_PAGE })
@Component
export struct TimeDemoPage {
  build() {
    Column(){
      CommonHeader()
      Text('1.判断是不是同一天')
      Button('测试是同一天').onClick(()=>{
        const isSameDay = TimeUtils.isSameDayOfMillis(Date.now(),'1755595112205')
        promptAction.showToast({message:`${isSameDay?'是同一天':'不是同一天'}`})
      })
      Button('测试不是同一天').onClick(()=>{
        const isSameDay = TimeUtils.isSameDayOfMillis(Date.now(),'1752824395')
        promptAction.showToast({message:`${isSameDay?'是同一天':'不是同一天'}`})
      })

    }
    .height('100%')
    .width('100%')
  }
}