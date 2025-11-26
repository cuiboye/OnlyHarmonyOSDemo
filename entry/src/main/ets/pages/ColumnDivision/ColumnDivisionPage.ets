import { HMNavigation, HMRouter } from '@hadss/hmrouter';
import { NavigationConstants } from '../../common/constants/NavigationConstants';
import { AttributeUpdater } from '@kit.ArkUI';
import { NavBarContent } from './NavBarContent';

/**
 * 分栏测试
 */
@HMRouter({ pageUrl: NavigationConstants.COLUMN_DIVISION_PAGE })
@Component
export struct ColumnDivisionPage {
  navigationId = 'NavigationLayoutNavigationId'; // todo: NavigationId为定义常量
  modifier: LayoutModifier = new LayoutModifier();

  build() {
    HMNavigation({
      navigationId: this.navigationId,
      // homePageUrl: NavigationConstants.LIST_PAGE,//这里如果传入homePageUrl的话，homePageUrl为默认的右分栏的内容
      options: {
        modifier: this.modifier
      }
    })
    {
      NavBarContent();
    };
  }
}

class LayoutModifier extends AttributeUpdater<NavigationAttribute> {
  initializeModifier(instance: NavigationAttribute): void {
    instance.backgroundColor('#EFEFEF');
    instance.mode(NavigationMode.Auto);
    instance.navBarWidth('50%');//这个是左侧的页面所占的比重
  }
}
