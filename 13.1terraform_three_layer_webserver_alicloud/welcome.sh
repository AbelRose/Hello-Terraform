#!/bin/sh
WEB_PATH="/root"
echo '<html><body><h1><p  style="line-height: 500px;text-align: center;"><font size="500">Welcome To Alibaba Cloud</font></p></h1></body></html>' > $WEB_PATH/welcome.html
cd $WEB_PATH
python -m SimpleHTTPServer