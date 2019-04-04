# -*- coding=UTF8 -*-

#加载.NET System.Windows.Forms 类
[Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
#创建Windows Script Shell对象
$ws = New-Object -ComObject WScript.Shell
function Show-OFDialog
{
    #函数参数
    param($Title = '选择文件', $Filter = '所有文件|*.*')
    #构造 OpenFileDialog (文件选择窗口)对象
    $ofd = New-Object System.Windows.Forms.OpenFileDialog
    #默认打开目录
    $ofd.InitialDirectory="D:/"
    #文件选择器标题
    $ofd.Title = $Title
    #文件筛选
    $ofd.Filter = $Filter
    #如果有上次打开的目录记录则使用它
    $ofd.RestoreDirectory = $true;
    #是否正确选择了文件 System.Windows.Forms.DialogResult 是一个枚举(Enum)类型
    if($ofd.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        #返回文件绝对地址 
        return $ofd.FileName.ToString()
    }
    else {
        #类似于MessageBox 第一个0表示显示时间无限长，第二个0表示显示OK按钮+16表示一个警告图标
        $ws.popup("您未选择文件", 0, "问题来了", 0 + 16) | Out-Null
        Exit
    }
}
function Show-SFDialog
{
    param($Title = '保存文件', $Filter = '所有文件|*.*')
    #构造 SaveFileDialog (文件保存窗口)对象
    $sfd = New-Object System.Windows.Forms.SaveFileDialog
    $sfd.InitialDirectory="D:/"
    $sfd.Title = $Title
    $sfd.Filter = $Filter
    $sfd.RestoreDirectory = $true;
    #是否正确输入了文件名
    if($sfd.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK -and $sfd.FileName.Length -gt 0) { 
        return $sfd.FileName.ToString()
    }
    else {
        $ws.popup("您未确认或文件名长度为0", 0, "问题来了", 0 + 16) | Out-Null
        Exit
    }
}
#向控制台输出
Write-Host "请打开一个Word文档"
#调用Show-OFDialog函数，并传递参数
$docpath = Show-OFDialog "打开文档" "Word 文档|*.docx|Word 97 - 2003 文档|*.doc|所有文件|*.*"

Write-Host "请选择PDF保存位置"
$pdfPath = Show-SFDialog "选择保存位置" "PDF 文档|*.pdf"

#构造 Word  COM 对象
$wordApp = New-Object -ComObject Word.Application
#打开刚刚选择的文件
$document = $wordApp.Documents.Open($docPath)
#上一条命令是否成功执行
$docext = $?
#保存文件类型 17表示PDF
$document.SaveAs([ref] $pdfPath, [ref] 17)
$pdfsuc = $?

if($docext -and $pdfsuc) {
    #64表示提示图标
    $ws.popup("转换成功", 0, "成功!", 0 + 64) | Out-Null
}
else {
    $ws.popup("转换失败", 0, "啊哟...", 0 + 16) | Out-Null
}
#关闭文件
$document.Close()
#退出Word
$wordApp.Quit()
#结束未停止的 Word 进程
Stop-Process -Name "WINWORD"