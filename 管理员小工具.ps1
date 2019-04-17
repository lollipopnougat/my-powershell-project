#param( $a, $b )
#region 关键代码：强迫以管理员权限运行
$currentWi = [Security.Principal.WindowsIdentity]::GetCurrent()
$currentWp = [Security.Principal.WindowsPrincipal]$currentWi
 
if( -not $currentWp.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    <#
    $boundPara = ($MyInvocation.BoundParameters.Keys | foreach {
        '-{0} {1}' -f  $_ ,$MyInvocation.BoundParameters[$_]} ) -join ' '
    $currentFile = (Resolve-Path  $MyInvocation.InvocationName).Path
    $fullPara = $boundPara + ' ' + $args -join ' '#>
    $path = $MyInvocation.MyCommand.Source
    Start-Process "$psHome\powershell.exe"   -ArgumentList "$path"  -verb runas
    Sleep 3
    return
}
$ws = New-Object -ComObject WScript.Shell
function Edit-Hosts {
    Start-Process notepad "C:\Windows\System32\drivers\etc\hosts" -Verb runas
}
function Del-Service {
    param([string]$name)
    $service = Get-WmiObject -Class Win32_Service -Filter "Name='$name'"
    if($service -eq $null) {
        $ws.popup("找不到名为`" $name `"的服务！！",5,"错误", 0 + 48)
        $tim = get-date
        $time = $tim.GetDateTimeFormats('T')[0]
        Write-Host "$time  输入了未知服务名(服务`" $name `"不存在)"
    }
    else {
        $wsr = $ws.popup("将会删除 $name 服务，确定吗？",0,"请确认...", 4 + 64)
        if($wsr -eq 6) {
            $service.delete()
            $ws.popup("已删除服务 $name ",2,"成功")
            $tim = get-date
            $time = $tim.GetDateTimeFormats('T')[0]
            Write-Host "$time  删除了 $name 服务"
        }
        else {
            $tim = get-date
            $time = $tim.GetDateTimeFormats('T')[0]
            $ws.popup("已取消操作",2,"请确认...")
            Write-Host "$time  取消删除 $name 服务操作"
        } 
    }
    
}

$version = "1.0"
[console]::Title = "PowerShell 管理员小工具 V $version"
$ws.popup("欢迎使用PowerShell 管理员小工具!",2,"欢迎！")

Add-Type -AssemblyName System.Windows.Forms
$WForm = New-Object System.Windows.Forms.Form
$WForm.Text = "PowerShell 管理员小工具 V $version"
$app=[System.Windows.Forms.Application]
$button1 = new-object System.Windows.Forms.Button
$button1.Size = new-object System.Drawing.Size  -argumentlist 75, 23
$button1.Text = "修改Hosts文件"


$button2 = new-object System.Windows.Forms.Button
$button2.Size = new-object System.Drawing.Size  -argumentlist 75, 23
$button2.Text = "删除服务"

$button3 = new-object System.Windows.Forms.Button
$button3.Size = new-object System.Drawing.Size  -argumentlist 75, 23
$button3.Text = "查看源码"

$textbox1=new-object System.Windows.Forms.TextBox
$textBox1.Multiline = $true;
$textBox1.Text = "请输入要删除的服务名"
$textBox1.Size = new-object System.Drawing.Size  -argumentlist 150, 100

$flowLayoutPanel1 = new-object System.Windows.Forms.FlowLayoutPanel
$WForm.Controls.Add($flowLayoutPanel1)

$flowLayoutPanel1.Controls.Add($button1)
$flowLayoutPanel1.Controls.Add($button2)
$flowLayoutPanel1.Controls.Add($textBox1)
$flowLayoutPanel1.Controls.Add($button3)
$flowLayoutPanel1.Dock = "Fill"
$flowLayoutPanel1.FlowDirection = "TopDown"

$button2ClickEventHandler = [System.EventHandler] {
    #$name = Read-Host "请输入服务名"
    $tim = get-date
    $time = $tim.GetDateTimeFormats('T')[0]
    Write-Host "$time 点击了删除服务按钮"
    Del-Service $textbox1.Text
}
$button2.Add_Click($button2ClickEventHandler)

$button1ClickEventHandler = [System.EventHandler] {
    $tim = get-date
    $time = $tim.GetDateTimeFormats('T')[0]
    Write-Host "$time 点击了修改Hosts按钮"
    Edit-Hosts
}
$button1.Add_Click($button1ClickEventHandler)

$button3ClickEventHandler = [System.EventHandler] {
    $tim = get-date
    $time = $tim.GetDateTimeFormats('T')[0]
    Write-Host "$time 点击了查看源码按钮"
    Write-Host "顺便欢迎访问作者的其他项目"
    Start-Process "https://github.com/lollipopnougat/my-powershell-project/blob/master/管理员小工具.ps1"
}
$button3.Add_Click($button3ClickEventHandler)

$app::EnableVisualStyles()
$app::Run($WForm)
Write-Host "等待3s后自动退出"