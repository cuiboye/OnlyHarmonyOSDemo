export class ClassifyBean {
  states?: number
  msg?: string
  result?: ResultBean
}

export class ResultBean {
  isLogin?: number
  mainImg?: string
  rankList?: RankList[]
}

export class RankList {
  rankingId?: number
  navTitle?: string
  rankingTitle?: string
  detailsImg?: string
  rankingProduct?: RankingProduct[]
}

export class RankingProduct {
  loginFlag?: number
  cname?: string
  picture?: string
  productId?: number
  sort?: number
  priceStr?: string
  priceDecription?: string
  isShouqing?: number
  isQyBx?: number
  productCountryPic?: string
}
