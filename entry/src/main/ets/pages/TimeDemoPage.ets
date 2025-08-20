import { CommonHeader } from '../common/common_header';
import { TimeUtils } from '../common/utils/TimeUtils';
import { promptAction } from '@kit.ArkUI';

/**
 * 时间相关操作
 */
@Entry
@Component
struct TimeDemoPage {
  @State message: string = 'Hello World';

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