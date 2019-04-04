$ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"
$ur = "http://translate.google.cn/translate_a/single?client=gtx&dt=t&dj=1&ie=UTF-8&sl=auto&tl=zh_CN&q="
$reg = "trans"":"".*"",""orig"
function Trans2Zh-CN {

    if ($args.Count -eq 0) {
        Write-Host "����Ϊ��!"
        return
    }
    else {
        $args | foreach {
            $url = $ur + $_
            $resu = Invoke-WebRequest -Uri $url -UserAgent $ua
            if ($resu.content -match $reg) {
                #$matches.count
                $res = $matches[0]
                $result = "����: " + $res.SubString(8, $res.length - 15)
                Write-Host " "
                Write-Host $result
                Write-Host "������Google�ṩ"
                Write-Host " "
            }
            else {
                if (!(Test-Connection -ComputerName translate.google.cn -Quiet)) {
                    Write-Host "������˵�����..."
                    Write-Host "������������..."
                }
                else {
                    Write-Host "δ֪����������..."
                    Pause
                }
            }
        }
    }
    
}

while ($true) {
    $str = Read-Host "������Ҫ������ı�����������Ҽ�ճ����"
    Trans2Zh-CN $str
}




