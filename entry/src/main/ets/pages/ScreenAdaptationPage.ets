import { HMRouter } from '@hadss/hmrouter';
import { NavigationConstants } from '../common/constants/NavigationConstants';
import { BreakpointConstants } from '../common/utils/breakPoint/BreakpointConstants';
import { BreakpointType } from '../common/utils/breakPoint/BreakpointType';

/**
 * 屏幕适配
 */
@HMRouter({ pageUrl: NavigationConstants.SCREENADAPTATION_PAGE })
@Component
export struct ScreenAdaptationPage {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM

  aboutToAppear(){

  }

  aboutToDisappear() {

  }

  build() {
    Row() {
      Column() {
        // 如果是GridView的话，可以如下设置列数
        // new BreakpointType<string>('1fr 1fr','1fr 1fr 1fr 1fr','1fr 1fr 1fr 1fr').getValue(this.currentBreakpoint)
        Text(new BreakpointType<string>('普通屏幕','折叠屏','三折屏或者更宽的屏幕').getValue(this.currentBreakpoint))
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}