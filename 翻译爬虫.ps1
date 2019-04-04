$ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"
$ur = "http://translate.google.cn/translate_a/single?client=gtx&dt=t&dj=1&ie=UTF-8&sl=auto&tl=zh_CN&q="
$reg = "trans"":"".*"",""orig"
function Trans2Zh-CN {

    if ($args.Count -eq 0) {
        Write-Host "参数为空!"
        return
    }
    else {
        $args | foreach {
            $url = $ur + $_
            $resu = Invoke-WebRequest -Uri $url -UserAgent $ua
            if ($resu.content -match $reg) {
                #$matches.count
                $res = $matches[0]
                $result = "翻译: " + $res.SubString(8, $res.length - 15)
                Write-Host " "
                Write-Host $result
                Write-Host "翻译由Google提供"
                Write-Host " "
            }
            else {
                if (!(Test-Connection -ComputerName translate.google.cn -Quiet)) {
                    Write-Host "网络出了点问题..."
                    Write-Host "请检查您的网络..."
                }
                else {
                    Write-Host "未知错误请重试..."
                    Pause
                }
            }
        }
    }
    
}

while ($true) {
    $str = Read-Host "请输入要翻译的文本，（按鼠标右键粘贴）"
    Trans2Zh-CN $str
}




