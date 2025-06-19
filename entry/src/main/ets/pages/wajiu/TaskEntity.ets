//注意：实体类文件的后缀名不能为ts，只能是ets，否则不能使用 @Observed
export default class ShopInfo {
  states?:number
  msg?:string
  result?:Data
}
export class Data{
  indexList?:IndexListEntity
  banner_international?:BannerInternationalEntity[]
  brandHall?:BrandHallEntity[]
  famousProducts?:FamousProductsEntity
  kindSet?:KindSetEntity[]
}
export class IndexListEntity{
  focus_picture?:FocusPictureEntity
  home_button?:HomeButtonEntity
  announcement?:AnnouncementEntity
}
export class FocusPictureEntity{
  appNewIndexCategories?:AppNewIndexCategoriesEntity[]
}

// @Observed
export class AppNewIndexCategoriesEntity{
  indexName?:string
  picture?:string
  parameter?:string
  urlType?:number
  appIndex?:AppIndex
}


export class HomeButtonEntity{
  appNewIndexCategories?:HomeButtonAppNewIndexCategoriesEntity[]
}

export class HomeButtonAppNewIndexCategoriesEntity{
  indexName?:string
  picture?:string
  parameter?:string
  urlType?:number
  appIndex?:AppIndex
}

export class BannerInternationalEntity{
  picture?:string
  indexName?:string
  parameter?:string
  urlType?:number
  appIndex?:AppIndex
  originPlace?:string
}

export class AppIndex{
  cName?:string
}
export class BrandHallEntity{
  appPictrueAddress?:string
  parameter?:string
  productCategoryId?:number
  pcPictrueAddress?:string
  name?:string
  id?:number
}

export class FamousProductsEntity{
  famousProductList?:FamousProductListEntity[]
}

export class FamousProductListEntity{
  cname?:string
  picture?:string
}

export class AnnouncementEntity{
  appNewIndexCategories?:AnnouncementAppNewIndexCategoriesEntity[]
}

export class AnnouncementAppNewIndexCategoriesEntity{
  indexName?:string
  picture?:string
  parameter?:string
  urlType?:number
  appIndex?:AppIndex
}

export class KindSetEntity{
  kindName?:string
  reqName?:string
  reqValue?:string
  productInfoList?:ProductInfoListEntity[]
}

export class ProductInfoListEntity{
  productId?:number
  jnPrice?:string
  parameter?:string
  cname?:string
  picture?:string
}




