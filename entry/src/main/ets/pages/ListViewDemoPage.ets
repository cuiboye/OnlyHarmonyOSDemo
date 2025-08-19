import { ListView, LoadMoreLayoutStatusModel, RefreshController, RefreshDataSource,
  RefreshLayoutStatusModel } from '@abner/refresh_v2';
import { CommonHeader } from '../common/common_header';
import { UploadEntity, UploadItemEntity } from '../entity/UploadEntity';
import axios, { AxiosResponse } from '@ohos/axios';
import { NetworkUtils } from '../common/utils/NetworkUtils';
import { BusinessError } from '@kit.BasicServicesKit';
import { CustomFooterLayoutView } from '../views/CustomFooterLayoutView';
import { CustomHeaderLayoutView } from '../views/CustomHeaderLayoutView';
import { systemDateTime } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct ListViewDemoPage {
  controller: RefreshController = new RefreshController() // 刷新控制器
  lazyDataSource: RefreshDataSource = new RefreshDataSource() // 懒加载数据
  @State listState: number = ListState.Loading
  mPn: number = 1; //当前页数
  @State selectedAll: boolean = false
  @State hasSelectedNumber: number = 0
  // 是否正在拉取列表数据
  private isFetching: boolean = false;

  build() {
    Column() {
      CommonHeader()
      Button(this.selectedAll ? '取消全选' : '全选')
        .onClick(()=>{
          if (this.selectedAll) {
            this.selectedAll = false
            this.changeSelectAllStatus(false)
          } else {
            this.selectedAll = true
            this.changeSelectAllStatus(true)
          }
        })
      Text(`当前选中的数量为：${this.hasSelectedNumber}`)
      this.ListViewWidget()
    }
    .height('100%')
    .width('100%')
  }

  changeSelectAllStatus(isSelect: boolean){
    const allList: UploadItemEntity[] = this.lazyDataSource.getDataAll()
    allList.map(item => {
      item.selected = isSelect
    });
    this.lazyDataSource.notifyDataReload()//这句是要刷新页面上的UI
    this.hasSelectedNumber = allList.filter(item => item.selected).length
  }


  aboutToAppear(): void {
    this.fetchListData(true)
  }

  @Builder
  emptyView(){
    Text('我是空布局')
  }

  @Builder
  headerLayout() {
    if (this.listState !== ListState.Empty && this.listState !== ListState.Error) {
      Text('我是ListView的header')
    }
  }

  @Builder
  errorView(){
    Text('我是错误布局')
  }

  @Builder
  footerLoadLayout(status: LoadMoreLayoutStatusModel) {
    CustomFooterLayoutView({ status: status })
  }

  @Builder
  RefreshHeaderBuilder() {
    CustomHeaderLayoutView({ animateName: systemDateTime.getTime(true).toString() })
  }

  @Builder
  itemWidget(item: UploadItemEntity, index: number) {
    Row(){
      Text(`${item.title ?? ''}`)
        .layoutWeight(1)
        .maxLines(1)// 单行显示
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
      Stack() {
        Image(item.selected ? $r("app.media.selected_icon") : $r("app.media.unselect_icon"))
          .width(17)
          .height(17)
      }
      .padding({
        top: 20,
        bottom: 20,
        left: 20,
        right: 20
      })
      .onClick(() => {
        this.updateSelected(index, item)
      })
    }.width('100%')
  }

  updateSelected(index: number,item: UploadItemEntity) {
    item.selected = !item.selected;
    this.lazyDataSource.notifyDataChange(index);//刷新页面上某个item的UI
    let allList: UploadItemEntity[] = this.lazyDataSource.getDataAll()
    allList[index].selected = item.selected

    this.selectedAll = allList.every(item => item.selected)//every为每一个都符合条件
    this.hasSelectedNumber = allList.filter(item => item.selected).length //filter为筛选符合条件的数据
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
          // this.setRefreshEnable(true)
          if (isRefresh) {
            this.lazyDataSource.deleteAll(() => {
              this.lazyDataSource.pushDataArray(uploadList)
            })
            this.controller.isNothingFixedBottom = false
            this.controller.finishRefresh()
            if (uploadList.length < (entity?.total ?? 0)) {
              this.controller.finishLoadMore()
            } else {
              this.controller.finishLoadMoreFixedBottom(true)
            }
          } else {
            this.lazyDataSource.pushDataArray(uploadList)
            if (this.lazyDataSource.totalCount() < (entity?.total ?? 0)) {
              this.controller.finishLoadMore()
            } else {
              this.controller.finishLoadMoreFixedBottom(true)
            }
          }
        } else {
          if (isRefresh) {
            this.lazyDataSource.deleteAll(() => {
              this.lazyDataSource.pushDataArray([])
            })
            this.listState = ListState.Empty
            // this.setRefreshEnable(false)
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
          //禁止刷新
          // this.setRefreshEnable(false)
        }
        this.controller.finishLoadMore()
      }
    }catch (e) {
      //没有网络的话会执行到这里
      this.isFetching = false;
      if (isRefresh) {
        this.listState = ListState.Error
        //禁止刷新
        // this.setRefreshEnable(false)
      }
      this.controller.finishLoadMore()

      let error = e as BusinessError;
      console.error(`Code:${error.code},message:${error.message}`);
    }
  }

  @Builder
  ListViewWidget() {
    ListView({
      lazyDataSource: this.lazyDataSource,
      itemLayout: (item: UploadItemEntity, index: number) => this.itemWidget(item, index),
      emptyLayout: ()=>{
        this.emptyView()
      },
      errorLayout: ()=>{
        this.errorView()
      },
      showEmptyLayout: this.listState == ListState.Empty, //控制空布局展示
      showErrorLayout: this.listState == ListState.Error, //控制错误布局展示
      showLoadingLayout: this.listState == ListState.Loading, //控制loadingLayout
      controller: this.controller,
      // enableRefresh:this.enableRefresh,
      // enableLoadMore:this.enableLoadMore,
      itemHeaderLayout:()=>{
        this.headerLayout()
      },
      headerRefreshLayout: (status: RefreshLayoutStatusModel) => {
        this.RefreshHeaderBuilder()
      },
      footerLoadLayout:(status: LoadMoreLayoutStatusModel)=>{
        this.footerLoadLayout(status)
      },
      slideDisplayLoadData: true, //设置此参数，可以让上拉完成后，不回弹，直接显示数据
      onRefresh: () => {
        // 下拉刷新
        this.fetchListData(true)
      },
      onLoadMore: () => {
        // 上拉加载
        this.fetchListData(false)
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