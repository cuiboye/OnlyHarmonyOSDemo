import { Expose } from 'class-transformer';

export class StatusBean {
  @Expose({ name: "code" })
  code?: number;
}

export class UploadEntity {
  status?: StatusBean;
  data?: DataBean;
}

export class DataBean {
  list?: UploadItemEntity[]
  total?: number
}

export class UploadItemEntity {
  title?: string
  pictureUrls?: string[]
  pictureUrl?: string
  type?: string
  create_time?: string
  selected?: boolean
  doc_id?: string
  fileExt?: string
  isUpload?: boolean
}
