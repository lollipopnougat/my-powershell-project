# Google����API����

$ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"
$ur = "http://translate.google.cn/translate_a/single?client=gtx&dt=t&dj=1&ie=UTF-8&sl=auto&tl=zh_CN&q="
$reg = "trans"":"".*"",""orig" # ����
function Trans2Zh-CN {
    if ($args.Count -eq 0) {
        "��������Ϊ��!"
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

function main() {
    "��ʾ: ����ļ�������������½������ھ����ļ���׷������"
    $File = Read-Host "������Ҫ������ı��ļ�����������/���·��+�ļ�����������Ҽ�ճ����"
    $str = gc $File
    $Out = Read-Host "�����������ı��ļ�����������/���·��+�ļ�����������Ҽ�ճ����"
    "�ļ�����: `n"
    $str
    "������: `n"
    foreach ($line in $str) {
        $tmp = Trans2Zh-CN $line
        ac $Out $tmp
        $tmp
    }

    "`n�������Ѵ��� $Out �ļ�������ļ��鿴.`n������Google�ṩ." 
}

main
Pause




