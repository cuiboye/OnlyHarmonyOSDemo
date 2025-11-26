import {
  ListAttr,
  LoadMoreFooterAttr,
  LoadMoreLayoutStatusModel,
  RefreshLayout,
  RefreshLayoutStatusModel } from '@abner/refresh_v2';
import { CommonHeader } from '../common/common_header';
import { UploadEntity, UploadItemEntity } from '../entity/UploadEntity';
import axios, { AxiosResponse } from '@ohos/axios';
import { NetworkUtils } from '../common/utils/NetworkUtils';
import { BusinessError } from '@kit.BasicServicesKit';
import { CustomFooterLayoutView } from '../views/CustomFooterLayoutView';
import { CustomHeaderLayoutView } from '../views/CustomHeaderLayoutView';
import { systemDateTime } from '@kit.BasicServicesKit';
import { HMRouter } from '@hadss/hmrouter';
import { NavigationConstants } from '../common/constants/NavigationConstants';
import { ListView, RefreshController, RefreshDataSource  } from '../listview_autoload/ListView';


@HMRouter({ pageUrl: NavigationConstants.AUTO_LOADMORE_LIST_PAGE })
@Component
export struct AutoLoadMoreListPage {
  controller: RefreshController = new RefreshController() // 刷新控制器
  lazyDataSource: RefreshDataSource = new RefreshDataSource() // 懒加载数据
  @State listState: number = ListState.Loading
  @State enableRefresh: boolean = true
  @State enableLoadMore: boolean = true
  mPn: number = 1; //当前页数
  @State selectedAll: boolean = false
  @State hasSelectedNumber: number = 0
  // 是否正在拉取列表数据
  private isFetching: boolean = false;
  @State hasNoMoreDataStatus: boolean = false

  build() {
    Column() {
      CommonHeader({title:'自动加载更多数据的列表'})
      this.ListViewWidget()
    }
    .height('100%')
    .width('100%')
  }

  aboutToAppear(): void {
    if (!NetworkUtils.isNetworkAvailableSync()) {
      this.listState = ListState.Error
      this.setRefreshEnable(false)
    } else {
      this.listState = ListState.Loading
      this.setRefreshEnable(true)
      this.fetchListData(true)
      // this.controller.autoRefresh(true)//自动刷新
    }
  }

  setRefreshEnable(enable: boolean) {
    this.enableRefresh = enable
    this.enableLoadMore = enable
  }

  @Builder
  emptyView(){
    Text('我是空布局')
  }

  @Builder
  errorView(){
    Text('我是错误布局')
  }

  @Builder
  itemWidget(item: UploadItemEntity, index: number):void {
    Row(){
      Text(`${item.title ?? ''}`)
        .maxLines(1)// 单行显示
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })

    }.width('100%').height(190)
  }



  async fetchListData(isRefresh: boolean) {
    if (this.isFetching) {
      return
    }
    if (isRefresh) {
      this.mPn = 1;
    }
    this.isFetching = true;
    if(!NetworkUtils.isNetworkAvailableSync()){
      this.isFetching = false;
    }

    let url: string = "https://m1.apifoxmock.com/m1/3626399-3255008-default/demo/getlistviewdata"

    let params: Record<string, string> = {
      'page': String(this.mPn),
    }

    try {
      let response: AxiosResponse<UploadEntity> = await axios.get<UploadEntity, AxiosResponse<UploadEntity>, null>(
        url,{params:params}
      )
      if (response.status === 200) { //http的状态码
        let entity = response.data.data

        let uploadList = entity?.list as UploadEntity[]
        if (uploadList != null && uploadList.length > 0) {
          this.mPn++;
          this.listState = ListState.Normal
          this.setRefreshEnable(true)
          if (isRefresh) {
            this.lazyDataSource.deleteAll(() => {
              this.lazyDataSource.pushDataArray(uploadList)
            })
            this.controller.isNothingFixedBottom = false
            this.controller.finishRefresh()

            // if (uploadList.length < 20) {//接口中没有返回总的数据数量的时候通过使用判断是否小于每页的数量来处理逻辑
            if (this.lazyDataSource.totalCount() < (entity?.total ?? 0)) {
              this.controller.finishLoadMoreFixedBottom(true)
              this.hasNoMoreDataStatus = true
            } else {
              this.hasNoMoreDataStatus = false
              this.controller.finishLoadMore()
            }
          } else {
            this.lazyDataSource.pushDataArray(uploadList)
            // if (uploadList.length < 20) {//接口中没有返回总的数据数量的时候通过使用判断是否小于每页的数量来处理逻辑
            if (this.lazyDataSource.totalCount() < (entity?.total ?? 0)) {
              this.controller.finishLoadMoreFixedBottom(true)
              this.hasNoMoreDataStatus = true
            } else {
              this.hasNoMoreDataStatus = false
              this.controller.finishLoadMore()
            }
          }
        } else {
          if (isRefresh) {
            this.lazyDataSource.deleteAll(() => {
              this.lazyDataSource.pushDataArray([])
            })
            this.listState = ListState.Empty
            this.setRefreshEnable(false)
            this.controller.finishRefresh()
          } else {
            this.controller.finishLoadMoreFixedBottom(true)
          }
        }
        this.isFetching = false;
      }else {//错误处理，http码非200
        this.isFetching = false;
        if (isRefresh) {
          this.listState = ListState.Error
          this.setRefreshEnable(false)
        }
        this.controller.finishLoadMore()
      }
    }catch (e) {
      //没有网络的话会执行到这里
      this.isFetching = false;
      if (isRefresh) {
        this.listState = ListState.Error
        this.setRefreshEnable(false)
      }
      this.controller.finishLoadMore()

      let error = e as BusinessError;
      console.error(`Code:${error.code},message:${error.message}`);
    }
  }

  @Builder
  ListViewWidget() {
    ListView({
      //新增参数，其他业务场景可不传
      // wknSwitch_isMultiSelect: this.configModel.wknSwitch_isMultiSelect,
      // theListHeight: this.theListHeight,
      // paddingBottom: this.paddingBottom,
      hasNoMoreDataStatus: this.hasNoMoreDataStatus,
      errorActionBlock: () => {
        this.fetchListData(true)
      },
      //原ListView参数
      lazyDataSource: this.lazyDataSource,
      isLazyData: false,
      itemLayout: (item: UploadItemEntity, index: number) => this.itemWidget(item, index),
      emptyLayout: this.emptyView, //空布局
      errorLayout: this.errorView.bind(this), //错误布局
      // loadingLayout: this.loadingView, //loading布局
      showEmptyLayout: this.listState == ListState.Empty, //控制空布局展示
      showErrorLayout: this.listState == ListState.Error, //控制错误布局展示
      showLoadingLayout: this.listState == ListState.Loading, //控制loadingLayout
      controller: this.controller,
      slideDisplayLoadData: true, //设置此参数，可以让上拉完成后，不回弹，直接显示数据
      isScrollSpring: true, //设置阻尼为false
      onRefresh: () => {
        this.fetchListData(true)
      },
      onLoadMore: () => {
        this.fetchListData(false)
      },
      refreshOnScroll: (off, state) => {
        // LogUtils.d('')
      }
    })
  }
}

export const enum ListState {
  Normal = 0,
  Loading = 1,
  Empty = 2,
  Error = 3
}