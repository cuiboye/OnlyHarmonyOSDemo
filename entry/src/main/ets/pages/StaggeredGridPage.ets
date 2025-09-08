import { RefreshController, RefreshDataSource, StaggeredGridView, } from '@abner/refresh_v2';
import { CollectionCommunityItemEntity, StaggeredGridEntity } from '../entity/StaggeredGridEntity';
import { StaggeredGridItemView } from '../views/StaggeredGridItemView';
import { common } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';
import { CommonHeader } from '../common/common_header';
import { NavigationConstants } from '../common/constants/NavigationConstants';
import { HMRouter } from '@hadss/hmrouter';

/**
 * 瀑布流
 */
@HMRouter({ pageUrl: NavigationConstants.STAGGEREDGRID_PAGE })
@Component
export struct StaggeredGridPage {
  controller: RefreshController = new RefreshController() // 刷新控制器
  lazyDataSource: RefreshDataSource = new RefreshDataSource() // 懒加载数据

  build() {
    Column() {
      CommonHeader()
      this.StaggeredGridListView()
    }
  }

  aboutToAppear(): void {
    this.fetchListData()
  }

  @Builder
  StaggeredGridListView() {
    StaggeredGridView({
      lazyDataSource: this.lazyDataSource,
      itemLayout: (item: CollectionCommunityItemEntity, index: number) => this.itemLayout(item, index),
      controller: this.controller,
    })
      .layoutWeight(1)
      .margin({ left: 4, right: 6 })
  }

  @Builder
  itemLayout(item: CollectionCommunityItemEntity, index: number): void {
    StaggeredGridItemView({
      item: item,
      verticalType: '',
      tagName: ''
    }).margin({ left: 3, right: 3 })
  }

  async fetchListData() {
    let list: CollectionCommunityItemEntity[] = await this.getData()

    this.lazyDataSource.deleteAll(() => {
      this.lazyDataSource.pushDataArray(list)
    })
  }

  async getData(): Promise<CollectionCommunityItemEntity[]> {
    let context = getContext(this) as common.UIAbilityContext;
    //这里有个坑，resourceManager在预览模式不支持
    const rm = context.resourceManager;
    let response = await rm.getRawFileContent("staggeredlist.json")
    let rawFile = response;
    let textdecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true })
    let retStr = textdecoder.decodeWithStream(rawFile, { stream: false });
    let result = JSON.parse(retStr) as StaggeredGridEntity

    return result.data?.list ?? []
  }
}
