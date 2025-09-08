import { HMRouter } from '@hadss/hmrouter';
import { CommonHeader } from '../common/common_header';
import { NavigationConstants } from '../common/constants/NavigationConstants';

/**
 * bindSheet的使用
 */
@HMRouter({ pageUrl: NavigationConstants.BINDSHEET_PAGE })
@Component
export struct BindSheetPage {
  @State showDialog: boolean = false

  build() {
    Column() {
      CommonHeader()
      Button('弹出弹框')
        .onClick(() => {
          this.showDialog = true
        })
    }
    .bindSheet($$this.showDialog, this.bindSheetBuilder(), {
      //bindSheet的高度不设置的话高度会充满整个屏幕的高度
      //如果想要设置bindSheet高度自适应，可以设置高度为SheetSize.FIT_CONTENT
      // height: 200,
      height: SheetSize.FIT_CONTENT,
      showClose: false,
      radius: {
        topLeft: 16,
        topRight: 16
      }
    })
    .height('100%')
    .width('100%')
  }

  @Builder
  bindSheetBuilder() {
    Text('Hello')
  }
}