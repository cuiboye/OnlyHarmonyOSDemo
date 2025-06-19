
import { ProductItem } from '../adapter/ProductItem'
import { ShopCarModel } from './model/ShopcarModel'
/**
 * 购物车
 * 1)全选和取消全选
 * 2）如果要观察的对象是个数组并且需要操作数组中的对象，那么可以将List中的item单独的抽取为一个Widget，
 * 使用@State @Prop @Link 这几个状态来管理状态
 */
@Entry
@Component
export struct ShopCarPage {
  @State productArray :ShopCarModel[] = []

  @State totalPrice:number = 0
  //当前是否是全选
  @State selectedAll:boolean = false

  aboutToAppear(){
    //添加两条商品模拟数据
    let shopCarModel1 = new ShopCarModel()
    shopCarModel1.selected  = false
    shopCarModel1.productName  = '商品1'
    shopCarModel1.productPrice = 100
    this.productArray.push(shopCarModel1)

    let shopCarModel2 = new ShopCarModel()
    shopCarModel2.selected  = false
    shopCarModel2.productName  = '商品2'
    shopCarModel2.productPrice = 200
    this.productArray.push(shopCarModel2)
  }

  build() {
    Column() {
      Scroll(){
        Column(){
          List(){
            ForEach(this.productArray,(item:ShopCarModel,index:number)=>{
              ListItem(){
                ProductItem({
                  item:this.productArray[index],
                  totalPrice:$totalPrice,
                  productArray:this.productArray,
                  selectedAll:$selectedAll
                })
              }
            })
          }
          Text('猜你喜欢')
          List(){
            ForEach([1,2,3,4,5,6],()=>{
              ListItem(){
                Column(){
                  Text('商品').height(150)
                Text('价钱').backgroundColor('#00a0e9')
                }
              }
            })
          }
        }
      }.layoutWeight(1)
      Row(){
        Row(){
          Image(this.selectedAll ? $r('app.media.selected_product') : $r('app.media.unselected_product'))
            .height(24)
            .width(24)
            .onClick(()=>{
              this.selectedAll = !this.selectedAll
              if(this.selectedAll){
                //List.forEach：对List进行遍历
                this.productArray.forEach((item:ShopCarModel)=>{
                  this.totalPrice += item.productPrice
                })
                this.productArray.map((item:ShopCarModel)=>{
                  item.selected = true
                })
              }else {
                //List.map的作用是返回一个新的数组
                this.productArray.map((item:ShopCarModel)=>{
                  item.selected = false
                })
                this.totalPrice = 0
              }
            })
          Text('全选')
        }.layoutWeight(1)
        Text(`总计：${this.totalPrice}`)
        Text('结算').margin({left:13,right:13})
      }
    }
    .height('100%')
  }
}