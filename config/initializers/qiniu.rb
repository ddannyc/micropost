require 'qiniu'

Qiniu.establish_connection! :access_key => ENV['MICROPOST_QINIU_ACCESS_KEY'],
                            :secret_key => ENV['MICROPOST_QINIU_SECRET_KEY'] 
