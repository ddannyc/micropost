module QiniuHelper
  QINIU_DOMAIN = 'http://ofar2pxva.bkt.clouddn.com/'
  QINIU_IMG_STYLE = {
    thumb: 'imageView2/2/w/100/h/100/interlace/0/q/85',
    cover: 'imageView2/2/w/200/h/200/interlace/0/q/80',
    big:   'imageView2/2/w/1280/interlace/0/q/85'
  }
  QINIU_BUCKET = 'photo'

  def qiniu_uptoken
    put_policy = Qiniu::Auth::PutPolicy.new(QINIU_BUCKET)
    uptoken = Qiniu::Auth.generate_uptoken(put_policy)
  end

  def qiniu_img_url(key, style)
    if QINIU_IMG_STYLE.include?(style) 
      QINIU_DOMAIN + key + '?' + QINIU_IMG_STYLE[style]
    else
      QINIU_DOMAIN + key
    end
  end

  def qiniu_delete(key)
    Qiniu::Storage.delete(QINIU_BUCKET, key) if key
  end

end
