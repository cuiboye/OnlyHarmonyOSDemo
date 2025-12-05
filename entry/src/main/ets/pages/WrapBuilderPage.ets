import { CommonHeader } from '../common/common_header'
import { HMRouter } from '@hadss/hmrouter';
import { NavigationConstants } from '../common/constants/NavigationConstants';

@Builder
function MyBuilder(value: string, size: number) {
  Text(value).fontSize(size)
}

let globalBuilder: WrappedBuilder<[string, number]> = wrapBuilder(MyBuilder)

/**
 * wrapBuilder的使用
 */
@HMRouter({ pageUrl: NavigationConstants.WRAPBUILDER_PAGE })
@Component
export struct WrapBuilderPage {
  build() {
    Column() {
      CommonHeader({ title: 'wrapBuilder的使用' })
      globalBuilder.builder('Hello', 20)
    }
    .height('100%')
    .width('100%')
  }
}