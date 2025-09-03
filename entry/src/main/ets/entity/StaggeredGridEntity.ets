
export class StaggeredGridEntity {
  status?: StatusEntity
  data?: CollectionCommunityDataBean;
}

export interface StatusEntity {
  code: number
  msg: string
}

export class CollectionCommunityDataBean {
  list?: CollectionCommunityItemEntity[]
  hasMore?: boolean
}

export class CollectionCommunityItemEntity {
  id?: string
  nid?: string
  uid?: string
  createAt?: string
  publishAt?: string
  status?: string
  statusFlag?: number
  title?: string
  content?: string
  images?: Images[]
  authorInfo?: AuthorInfo
  isLike?: boolean
  threadId?: string
  likeMount?: number
  comentMount?: number
  type?: number
  tags?: object
  videos?: Videos[]
  hot_comment?: Hot_comment
  rec_status?: number
  pay_flag?: string
  category?:string[]
  region?: string
  heat?: number
  user_type?: number
  doc_id?: string
  hyperlink?: string
  IsCollect?: boolean
  pay_flag_num?: number
  same_routers?:string[]
  is_own?: boolean
  hyperInfos?: object
}

export class Hot_comment {
  content?: string
}

export class Videos {
  video_url?: string
  cover_url?: string
  height?: number
  width?: number
  isSuplanscape?: boolean
}

export class AuthorInfo {
  uid?: string
  displayName?: string
  httpsAvatar?: string
  tags?: object
  isVip?: boolean
}

export class Images {
  url?: string
  width?: string
  height?: string
}

export class Status {
  code?: number
  msg?: string
  sLogid?: string
}

export interface paramsObject {
  nid: string;
  verticalType: string
  tagName: string
}