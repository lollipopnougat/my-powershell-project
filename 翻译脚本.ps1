# Google翻译API调用
<# 
请在同目录下建立一个lang.json文件，内容类似于
{
    "en": "英语",
    "zh": "中文",
    "zh-CN": "中文(简体)",
    "zh-HK": "中文(香港)",
    "zh-MO": "中文(澳门)",
    "zh-SG": "中文(新加坡)",
    "zh-TW": "中文(繁体)"
}
#>
$ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"
$ur = "http://translate.google.cn/translate_a/single?client=gtx&dt=t&dj=1&ie=UTF-8&sl=auto&tl=zh_CN&q="
$reg = "trans"":"".*"",""orig" # 正则
function Trans2Zh-CN {
    if ($args.Count -eq 0) {
        "参数为空!"
        return
    }
    else {
        $args | foreach {
            $url = $ur + $_
            $resu = Invoke-WebRequest -Uri $url -UserAgent $ua
            if ($resu.content -match $reg) {
                $result = ConvertFrom-Json -InputObject $resu.content
                "`n翻译: " + $result.sentences.trans
                $src = $result.src
                if(Test-Path "lang.json") {
                    $dic = gc "lang.json"
                    $dic | foreach { $dicstr += $_}
                    $index = ConvertFrom-Json -InputObject $dicstr
                    $lang = $index.($src)
                }
                else {
                    "请检查当前目录下是否有lang.json文件！"
                    $lang = $src
                }
                "`n翻译由Google提供`n推测源语言为 $lang `n"
            }
            else {
                if (!(Test-Connection -ComputerName translate.google.cn -Quiet)) {
                    "网络出了点问题..."
                    "请检查您的网络..."
                }
                else {
                    "未知错误请重试..."
                    Pause
                }
            }
        }
    }
}

while ($true) {
    $str = ""
    while ($str -eq "") { $str = Read-Host "请输入要翻译的文本，（按鼠标右键粘贴）" }
    Trans2Zh-CN $str
}
