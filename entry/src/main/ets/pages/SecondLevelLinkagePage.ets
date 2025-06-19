/**
 * 二级联动+MVVM模式
 */
import hilog from '@ohos.hilog';
import { CommonHeader } from '../common/common_header';
import ClassifyItem from './wajiu/adapter/ClassifyItem';
import { ClassifyBean, RankingProduct, RankList } from './wajiu/entity/ClassifyBean';
import classifyViewModel, { classifyData } from './wajiu/viewmodel/ClassifyViewModel'
@Entry
@Component
struct SecondLevelLinkagePage {
  @State  rankList?: Array<RankList> = []
  private classifyScroll:Scroller = new Scroller()
  private productScroll:Scroller = new Scroller()
  @State currentClassifyIndex:number = 0
  @State currentProductIndex:number = 0
  aboutToAppear(){
    //请求接口
    // classifyViewModel.getData().then(classifyData=>{
    //   const states:number = classifyData.states
    //   if(states && states===200){
    //     if(classifyData.result){
    //       this.rankList = classifyData.result.rankList;
    //     }
    //   }
    // })
   this.rankList = classifyData?.result?.rankList
  }
  build() {
    Column() {
      CommonHeader({title:'二级联动+MVVM模式'})
      if(this.rankList && this.rankList.length>0){
        List({space:30,scroller:this.classifyScroll}){
          ForEach(this.rankList,(item:RankList,index:number)=>{
            ListItem() {
              ClassifyItem({
                classifyName: item.navTitle,
                //currentClassifyIndex被@State修饰，值改变会执行build方法
                //当父组件中的数据源更改时，与之相关的@Prop装饰的变量都会自动更新。所以currentClassifyIndex被修改后，子组件中使用@Prop修饰的变量的值会更新
                isSelected:this.currentClassifyIndex ===index,
                onClickItem: () => {
                  console.log(`click index is ${index}`)
                  this.clickClassifyItem(index)
                }
              })
            }
          })
        }
        .alignListItem(ListItemAlign.Center)//设置List的item在纵轴方向的对齐方式
        .height(40)
        .listDirection(Axis.Horizontal)
      }
      List({scroller:this.productScroll}){
        ForEach(this.rankList,(item:RankList,index:number)=>{
          ListItemGroup({header:this.productListHeaderItem(item.rankingTitle)}){
            if(this.rankList && this.rankList[index] && this.rankList[index].rankingProduct){
              ForEach(this.rankList[index].rankingProduct,(childItem:RankingProduct,childIndex:number)=>{
                if(childItem.cname){
                  ListItem(){
                    Text(childItem.cname)
                      .height(80)
                  }
                }
              })
            }
          }
        })
      }
      .sticky(StickyStyle.Header)//一级吸顶
      //滚动到哪个index了，不加end第一个参数就是start
      .onScrollIndex( (start: number)=>this.productListChange(start))
    }
    .height('100%')
  }

  @Builder productListHeaderItem(headerTitle:string){
    if(headerTitle){
      Text(headerTitle)
        .fontColor(Color.Red)
    }
  }
  //顶部横向的List滚动变化
  private clickClassifyItem(index:number){
    if(this.currentClassifyIndex !== index){
      this.currentClassifyIndex = index
      this.classifyScroll.scrollToIndex(index)
      this.productScroll.scrollToIndex(index)
    }
  }

  //列表滚动变化
  private productListChange(index:number){
    if(this.currentClassifyIndex!==index){
      this.currentClassifyIndex = index;
      this.classifyScroll.scrollToIndex(index)
    }
  }
}