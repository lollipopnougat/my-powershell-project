function EncodeB64() {
    $ImgName = Read-Host "输入图片文件名"
    $Bin = gc $ImgName -Encoding Byte # "gc" -> Get-Content
    $LStr = [Convert]::ToBase64String($Bin)
    Write-Output "
    1 拷贝到剪贴板
    2 打印到PS控制台
    3 写入txt文件
    4 直接退出
    "
    $Inp = Read-Host "请选择"
    switch ($Inp) {
        "1" { scb $LStr } # "scb" -> Set-Clipboard
        "2" { Write-Output $LStr }
        "3" { 
                $TName = Read-Host "键入输出文件名(xxx.txt)"
                $LStr > $TName # ">" -> "Set-Content"
                Write-Output "写入完成，请打开同目录下的 $TName 查看."
        }
        "4" { exit }
        Default { Write-Output "输入非法!" }
    }
}
    
function DecodeB64() {
    Write-Output "
    1 从文本文件
    2 我自己粘贴/输入到控制台
    3 从剪切板
    4 直接退出"
    $Inp = Read-Host "请选择"
    switch ($Inp) {
        "1" { 
                $FileName = Read-Host "请输入文件名(xxx.txt)"
                $OriStr = gc $FileName 
        }
        "2" { $OriStr = Read-Host "请输入Base64编码" }
        "3" { $OriStr = gcb } # "gcb" -> "Get-Clipboard"
        "4" { exit }
        Default { Write-Output "输入非法!"; return }
    }
    $ImgFileName = Read-Host "请键入输出图片文件名(xxx.jpg/png/bmp)"
    $Img = [Convert]::FromBase64String($OriStr)
    foreach ($n in $Img) { ac $ImgFileName $n -Encoding Byte }
    Write-Output "输出完成，请打开同目录下 $ImgFileName  图片文件查看." 
}

function main() {
    Write-Output "Base64、图片相互转换脚本"
    Write-Output "
    提示：
    只输入文件名将会操作同目录下文件
    若要使用其他位置的文件，
    请输入绝对或相对路径再输入文件名.
    "
    while($true) {
        Write-Output "
    1 编码
    2 解码
    3 清屏
    4 退出
    "
        $In = Read-Host "请选择"
        switch ($In) {
            "1" { EncodeB64 }
            "2" { DecodeB64 }
            "3" { cls } # "cls" -> Clear-Host
            "4" { exit }
            Default { Write-Output "输入非法!" }
        }
    }
}
   
main
Pause


