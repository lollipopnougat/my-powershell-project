# Google����API����
<# 
����ͬĿ¼�½���һ��lang.json�ļ�������������
{
    "en": "Ӣ��",
    "zh": "����",
    "zh-CN": "����(����)",
    "zh-HK": "����(���)",
    "zh-MO": "����(����)",
    "zh-SG": "����(�¼���)",
    "zh-TW": "����(����)"
}
#>
$ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"
$ur = "http://translate.google.cn/translate_a/single?client=gtx&dt=t&dj=1&ie=UTF-8&sl=auto&tl=zh_CN&q="
$reg = "trans"":"".*"",""orig" # ����
function Trans2Zh-CN {
    if ($args.Count -eq 0) {
        "����Ϊ��!"
        return
    }
    else {
        $args | foreach {
            $url = $ur + $_
            $resu = Invoke-WebRequest -Uri $url -UserAgent $ua
            if ($resu.content -match $reg) {
                $result = ConvertFrom-Json -InputObject $resu.content
                "`n����: " + $result.sentences.trans
                $src = $result.src
                if(Test-Path "lang.json") {
                    $dic = gc "lang.json"
                    $dic | foreach { $dicstr += $_}
                    $index = ConvertFrom-Json -InputObject $dicstr
                    $lang = $index.($src)
                }
                else {
                    "���鵱ǰĿ¼���Ƿ���lang.json�ļ���"
                    $lang = $src
                }
                "`n������Google�ṩ`n�Ʋ�Դ����Ϊ $lang `n"
            }
            else {
                if (!(Test-Connection -ComputerName translate.google.cn -Quiet)) {
                    "������˵�����..."
                    "������������..."
                }
                else {
                    "δ֪����������..."
                    Pause
                }
            }
        }
    }
}

while ($true) {
    $str = ""
    while ($str -eq "") { $str = Read-Host "������Ҫ������ı�����������Ҽ�ճ����" }
    Trans2Zh-CN $str
}
