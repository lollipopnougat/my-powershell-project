function EncodeB64() {
    $ImgName = Read-Host "����ͼƬ�ļ���"
    #$Bin = gc $ImgName -Encoding Byte # "gc" -> Get-Content
    $Bin = [System.IO.File]::ReadAllBytes($pwd.path + '/' + $ImgName)
    $LStr = [Convert]::ToBase64String($Bin)
    Write-Output "
    1 ������������
    2 ��ӡ��PS����̨
    3 д��txt�ļ�
    4 ֱ���˳�
    "
    $Inp = Read-Host "��ѡ��"
    switch ($Inp) {
        "1" { scb $LStr } # "scb" -> Set-Clipboard
        "2" { Write-Output $LStr }
        "3" { 
            $TName = Read-Host "��������ļ���(xxx.txt)"
            #$LStr > $TName # ">" -> "Set-Content"
            sc $TName $LStr -Encoding UTF8
            Write-Output "д����ɣ����ͬĿ¼�µ� $TName �鿴."
        }
        "4" { exit }
        Default { Write-Output "����Ƿ�!" }
    }
}
    
function DecodeB64() {
    Write-Output "
    1 ���ı��ļ�
    2 ���Լ�ճ��/���뵽����̨
    3 �Ӽ��а�
    4 ֱ���˳�"
    $Inp = Read-Host "��ѡ��"
    switch ($Inp) {
        "1" { 
            $FileName = Read-Host "�������ļ���(xxx.txt)"
            $OriStr = gc $FileName 
        }
        "2" { $OriStr = Read-Host "������Base64����" }
        "3" { $OriStr = gcb } # "gcb" -> "Get-Clipboard"
        "4" { exit }
        Default { Write-Output "����Ƿ�!"; return }
    }
    $ImgFileName = Read-Host "��������ͼƬ�ļ���(xxx.jpg/png/bmp)"
    $Img = [Convert]::FromBase64String($OriStr)
    [System.IO.File]::WriteAllBytes(($pwd.path + '/' + $ImgFileName), $Img)
    #foreach ($n in $Img) { ac $ImgFileName $n -Encoding Byte }
    Write-Output "�����ɣ����ͬĿ¼�� $ImgFileName  ͼƬ�ļ��鿴." 
}

function main() {
    Write-Output "Base64��ͼƬ�໥ת���ű�"
    Write-Output "
    ��ʾ��
    ֻ�����ļ����������ͬĿ¼���ļ�
    ��Ҫʹ������λ�õ��ļ���
    ��������Ի����·���������ļ���.
    "
    while ($true) {
        Write-Output "
    1 ����
    2 ����
    3 ����
    4 �˳�
    "
        $In = Read-Host "��ѡ��"
        switch ($In) {
            "1" { EncodeB64 }
            "2" { DecodeB64 }
            "3" { cls } # "cls" -> Clear-Host
            "4" { exit }
            Default { Write-Output "����Ƿ�!" }
        }
    }
}
   
main
Pause


