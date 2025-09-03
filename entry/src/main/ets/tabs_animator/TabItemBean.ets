export interface TabItemBean {
  tabs: Array<TabsBean>;
}

export interface TabsBean {
  tab_id: string
  tab_name: string
  web_url: string
  is_default: string
}
