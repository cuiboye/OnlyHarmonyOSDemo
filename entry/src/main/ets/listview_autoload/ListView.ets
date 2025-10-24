import { display } from "@kit.ArkUI";
import { AutoListViewBean } from "../entity/AutoListViewBean";
import { UploadItemEntity } from "../entity/UploadEntity";
import { LoadingViewLottie } from "./LoadingViewLottie";
import { RefreshViewLottieV2 } from "./RefreshViewLottieV2";


@Entry
@ComponentV2
export struct ListView {
  @BuilderParam
  headerRefreshLayout?: (status: RefreshLayoutStatusModel) => void;
  @BuilderParam
  footerLoadLayout?: (status: LoadMoreLayoutStatusModel) => void;
  @Param
  readonly enableRefresh?: boolean = false;
  @BuilderParam
  itemHeaderLayout?: () => void;
  @Param
  readonly enableLoadMore?: boolean = false;
  @Param @Once wknSwitch_isMultiSelect: boolean = false
  @Param errorActionBlock?: () => void = () => {
  }
  @Param @Once isLazyData: boolean = false;
  @Param @Once lazyDataSource?: RefreshDataSource = new RefreshDataSource();
  @Param controller: RefreshController = new RefreshController()
  @BuilderParam
  itemLayout?: (item: Object, index: number) => void;
  @BuilderParam
  emptyLayout?: () => void;
  @BuilderParam
  errorLayout?: () => void;
  @BuilderParam
  loadingLayout?: () => void;
  @Param readonly refreshOnScroll?: (scrollOffset: number, scrollState: ScrollState) => void = () => {};
  @Param readonly slideDisplayLoadData: boolean = true;
  @Param readonly isScrollSpring: boolean = true;
  @Param @Require readonly onRefresh?: () => void;
  @Param @Require readonly onLoadMore?: () => void;
  @Param readonly showEmptyLayout?: boolean = false;
  @Local localShowEmptyLayout ?: boolean

  @Monitor("showEmptyLayout")
  showEmptyLayoutListener(): void {
    this.localShowEmptyLayout = this.showEmptyLayout
  }

  @Param readonly showErrorLayout?: boolean = false;
  @Param readonly showLoadingLayout?: boolean = false;
  //适配topTip和bottomBar
  @Param paddingBottom: number = 0
  @Param theListHeight: number = px2vp(display.getDefaultDisplaySync().height) - 82
  //下拉刷新
  @Local refreshOffset: number = 0;
  @Local refreshStatus: RefreshStatus = RefreshStatus.Inactive;
  //上拉加载 滚动到列表底部时触发加载
  @Param hasNoMoreDataStatus: boolean = false
  @Local placerHeight: number = 0

  @Monitor("hasNoMoreDataStatus")
  hasNoMoreDataStatusListener(): void {
    if (this.hasNoMoreDataStatus && this.lazyDataSource) {
      this.placerHeight = this.theListHeight - this.lazyDataSource?.totalCount() * 71 - 64 - this.paddingBottom + 1
    } else {
      this.placerHeight = 0
    }
  }

  //禁用Refresh组件的下拉刷新
  @Param downRatio: number = 1;

  @Builder
  refreshBuilder() {
    RefreshViewLottieV2({ showText: false, refreshOffset: this.refreshOffset, refreshState: this.refreshStatus })
      .width(86)
      .height(43)
  }

  @Builder
  refreshFolderWenkuView() {
    Refresh({ refreshing: $$this.controller.isRefresh, builder: this.refreshBuilder() }) {
      this.pageListView()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ffffff')
    .pullDownRatio((this.localShowEmptyLayout || this.showErrorLayout || this.showLoadingLayout) ? 0 :
      0.5) //禁用Refresh组件的下拉刷新
    .onOffsetChange((offset: number) => {
      this.refreshOffset = offset;
    })
    .onStateChange((state: RefreshStatus) => {
      this.refreshStatus = state;
    })
    .onRefreshing(() => {
      if (this.onRefresh) {
        this.onRefresh()
      }
    })
  }

  @Builder
  loadingView() {
    LoadingViewLottie({ marginTop: 200 })
  }

  @Builder
  emptyView() {
    Text('这里还没有内容')
  }

  @Builder
  errorView() {
    Text('网络异常，请检查您的网络并重试')
  }

  @Builder
  placer() {
    Row()
      .width('100%')
      .height(this.placerHeight)
  }

  @Builder
  footer() {
    //有更多数据则一直在下边显示'向上滑动加载更多'
    //没有更多数据则 则不展示
    //有 并且 正在发接口 则显示 "正在加载..."
    Row() {
      if (this.hasNoMoreDataStatus) {
        if (this.controller.isMoreLoading) {
          LoadingViewLottie({ showText: false, widthAndHeight: 25 })
            .width(25)
            .height(25)
            .margin({ right: 5 })
        }
        Text(this.controller.isMoreLoading ? "正在加载..." : '向上滑动加载更多')
          .fontSize(14)
          .fontColor('#5a5a5a')
      }
    }
    .width('100%')
    .height(this.hasNoMoreDataStatus ? 64 : (this.wknSwitch_isMultiSelect ? 0 : 40))
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  pageListView() {

    List() {
      ListItem() {
        if (this.showLoadingLayout) {
          if (this.loadingLayout) {
            this.loadingLayout()
          } else {
            this.loadingView()
          }
        } else if (this.localShowEmptyLayout) {
          if (this.emptyLayout) {
            this.emptyLayout()
          } else {
            this.emptyView()
          }
        } else if (this.showErrorLayout) {
          if (this.errorLayout) {
            this.errorLayout()
          } else {
            this.errorView()
          }
        }
      }

      LazyForEach(this.lazyDataSource, (item: UploadItemEntity, index: number) => {
        ListItem() {
          if (this.itemLayout) {
            this.itemLayout(item, index)
          }
        }
      })

      ListItem() {
        this.footer();
      }

      ListItem() {
        this.placer();
      }

    }
    .onAreaChange((oldv, newv) => {
      // LogUtils.d(oldv.height.toString() + ' onAreaChange ' + newv.height.toString())
    })
    .scrollBarColor(Color.Transparent)
    .onWillScroll(() => {
    })
    .onScrollStop(() => {
    })
    .onDidScroll((offset) => {
    })
    .onReachEnd(() => {
      this.onReachEndAction()
    })
    .nestedScroll({
      scrollForward: NestedScrollMode.PARENT_FIRST,
      scrollBackward: NestedScrollMode.SELF_FIRST
    })
  }

  onReachEndAction() {
    if (this.hasNoMoreDataStatus) {
      // 滚动到列表底部时触发加载
      setTimeout(() => {
        if (!this.controller.isMoreLoading) {
          this.controller.isMoreLoading = true;

          if (this.onLoadMore) {
            this.onLoadMore()
          }

        }
      }, 50)
    }
  }

  build() {
    Scroll() {
      this.refreshFolderWenkuView()
    }
    .width('100%')
    .align(Alignment.Center)
    .scrollBar(BarState.Off)
    .height(this.theListHeight)
    .scrollable(ScrollDirection.Vertical)
    .padding({ bottom: this.paddingBottom })
  }
}


class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  originDataArray: ESObject[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): ESObject {
    return this.originDataArray[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }
}

export declare enum LoadMoreLayoutStatus {
  Pulling = 0,
  Release = 1,
  Loading = 2,
  Finish = 3,
  FooterNothing = 4
}

export declare class LoadMoreLayoutStatusModel {
  status?: LoadMoreLayoutStatus;
}

@ObservedV2
export declare class RefreshLayoutStatusModel {
  status?: RefreshLayoutStatus;
}

export declare enum RefreshLayoutStatus {
  Pulling = 0,
  Release = 1,
  Refreshing = 2,
  Finish = 3,
  ReleaseHalfFloor = 4,
  FirstFloor = 5,
  HalfFloor = 6,
  ReleaseSecondFloor = 7,
  SecondFloor = 8,
  SecondFloorSlideUp = 9
}


@ObservedV2
export class RefreshDataSource extends BasicDataSource {
  refreshCallBack: ESObject;

  pushDataPosition(o19: number, p19: Object) {
    this.originDataArray.splice(o19, 0, p19);
    this.notifyDataAdd(o19);
  }

  getDataAll(): Object[] {
    return this.originDataArray;
  }

  public totalCount(): number {
    return this.originDataArray.length;
  }

  public getData(index: number): ESObject {
    return this.originDataArray[index];
  }

  public addData(index: number, data: ESObject): void {
    this.originDataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: ESObject): void {
    this.originDataArray.push(data);
    this.notifyDataAdd(this.originDataArray.length - 1);
  }

  public reloadData(): void {
    this.notifyDataReload();
  }

  public deleteAll(e19?: () => void): void {
    this.notifyDataDelete(this.originDataArray.length - 1);
    this.originDataArray = [];
    this.reloadData();
    if (e19 != undefined) {
      e19();
    }
    if (this.refreshCallBack != undefined) {
      this.refreshCallBack(this.originDataArray);
    }
  }

  pushDataArray(k19: ESObject): void {
    this.originDataArray = this.originDataArray.concat(k19);
    this.notifyDataAdd(this.originDataArray.length - 1);
    if (this.refreshCallBack != undefined) {
      this.refreshCallBack(this.originDataArray);
    }
  }

  refreshArrayCallback(x18: ESObject) {
    this.refreshCallBack = x18;
  }
}

@ObservedV2
export class RefreshController {
  @Trace isRefresh: boolean = false;
  @Trace isMoreLoading: boolean = false;
  isNothingFixedBottom: boolean = true;

  finishLoadMoreFixedBottom(d1?: boolean): void {

  }

  finishRefresh(): void {
    this.isRefresh = false
  }

  finishLoadMore(e1?: boolean): string {
    this.isMoreLoading = false
    return ''
  }
}