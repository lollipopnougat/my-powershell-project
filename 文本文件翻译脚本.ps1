# Google翻译API调用

$ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"
$ur = "http://translate.google.cn/translate_a/single?client=gtx&dt=t&dj=1&ie=UTF-8&sl=auto&tl=zh_CN&q="
$reg = "trans"":"".*"",""orig" # 正则
function Trans2Zh-CN {
    if ($args.Count -eq 0) {
        "参数不能为空!"
        return
    }
    else {
        $args | foreach {
            $url = $ur + $_
            $resu = Invoke-WebRequest -Uri $url -UserAgent $ua
            if ($resu.content -match $reg) {
                $result = ConvertFrom-Json -InputObject $resu.content
                $result.sentences.trans
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

function main() {
    "提示: 输出文件如果不存在则新建，存在就在文件后追加内容"
    $File = Read-Host "请输入要翻译的文本文件名，（绝对/相对路径+文件名，按鼠标右键粘贴）"
    $str = gc $File
    $Out = Read-Host "请键入入输出文本文件名，（绝对/相对路径+文件名，按鼠标右键粘贴）"
    "文件内容: `n"
    $str
    "翻译结果: `n"
    foreach ($line in $str) {
        $tmp = Trans2Zh-CN $line
        ac $Out $tmp
        $tmp
    }

    "`n翻译结果已存入 $Out 文件，请打开文件查看.`n翻译由Google提供." 
}

main
Pause




