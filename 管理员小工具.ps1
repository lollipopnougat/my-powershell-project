# ��дWinForm,�о�����ѧ���˲���
#param( $a, $b )
#region �ؼ����룺ǿ���Թ���ԱȨ������
$currentWi = [Security.Principal.WindowsIdentity]::GetCurrent()
$currentWp = [Security.Principal.WindowsPrincipal]$currentWi
 
if ( -not $currentWp.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
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
  if ($null -eq $service) {
    $ws.popup("�Ҳ�����Ϊ`" $name `"�ķ��񣡣�", 5, "����", 0 + 16)
    $tim = get-date
    $time = $tim.GetDateTimeFormats('T')[0]
    Write-Host "$time  δ֪������(����`" $name `"������)"
  }
  else {
    $wsr = $ws.popup("����ɾ�� $name ����ȷ����", 0, "��ȷ��...", 4 + 64)
    if ($wsr -eq 6) {
      $service.delete()
      if($?) {
        $ws.popup("��ɾ������ $name ", 2, "�ɹ�", 0 + 64)
        $tim = get-date
        $time = $tim.GetDateTimeFormats('T')[0]
        Write-Host "$time  ɾ���� $name ����"
      }
      else {
        $ws.popup("ɾ������ $name ", 2, "ʧ��", 0 + 16)
        $tim = get-date
        $time = $tim.GetDateTimeFormats('T')[0]
        Write-Host "$time  ɾ���� $name ����"
      }
    }
    else {
      $tim = get-date
      $time = $tim.GetDateTimeFormats('T')[0]
      $ws.popup("��ȡ������", 2, "��ʾ...")
      Write-Host "$time  ȡ��ɾ�� $name �������"
    } 
  }
    
}

$version = "1.2"
[console]::Title = "PowerShell ����ԱС���� V $version"
$ws.popup("��ӭʹ��PowerShell ����ԱС����!", 2, "��ӭ��")

Add-Type -AssemblyName System.Windows.Forms
$WForm = New-Object System.Windows.Forms.Form
$WForm.Text = "PowerShell ����ԱС���� V $version"
$WForm.Size = New-Object System.Drawing.Size -argumentList 320, 300
$app = [System.Windows.Forms.Application]
$button1 = new-object System.Windows.Forms.Button
$button1.Size = new-object System.Drawing.Size  -argumentlist 200, 30
$button1.Text = "ֱ���޸�Hosts�ļ�"
$button1.Font = New-Object System.Drawing.Font -ArgumentList "΢���ź�", ([single]10.8), "Regular", "Point", ([byte](134))


$button2 = new-object System.Windows.Forms.Button
$button2.Size = new-object System.Drawing.Size  -argumentlist 200, 30
$button2.Text = "ɾ������ѡ�е�ϵͳ����"
$button2.Font = New-Object System.Drawing.Font -ArgumentList "΢���ź�", ([single]10.8), "Regular", "Point", ([byte](134))

$button3 = new-object System.Windows.Forms.Button
$button3.Size = new-object System.Drawing.Size  -argumentlist 200, 30
$button3.Text = "�鿴Դ��"
$button3.Font = New-Object System.Drawing.Font -ArgumentList "΢���ź�", ([single]10.8), "Regular", "Point", ([byte](134))

$listBox1 = new-object System.Windows.Forms.ListBox
$listBox1.ItemHeight = 24;
$listBox1.Font = New-Object System.Drawing.Font -ArgumentList "΢���ź�", ([single]10.8), "Regular", "Point", ([byte](134))
#$listBox.Multiline = $true;
#$textBox1.Text = "������Ҫɾ���ķ�����"
$allservices = Get-CimInstance -class Win32_Service
$allservices | foreach { 
  $listBox1.Items.Add($_.name) | Out-Null
}
$listBox1.Size = new-object System.Drawing.Size  -argumentlist 300, 120

$flowLayoutPanel1 = new-object System.Windows.Forms.FlowLayoutPanel
$WForm.Controls.Add($flowLayoutPanel1)

$flowLayoutPanel1.Controls.Add($button1)
$flowLayoutPanel1.Controls.Add($button2)
$flowLayoutPanel1.Controls.Add($listBox1)
$flowLayoutPanel1.Controls.Add($button3)
$flowLayoutPanel1.Dock = "Fill";
$flowLayoutPanel1.FlowDirection = "TopDown"

$button2ClickEventHandler = [System.EventHandler] {
  #$name = Read-Host "�����������"
  $tim = get-date
  $time = $tim.GetDateTimeFormats('T')[0]
  Write-Host "$time �����ɾ������ť"
  if ($listBox1.SelectedItems.Count -gt 0) {
    Del-Service $listBox1.SelectedItem.ToString() 
  }
  else {
    $tim = get-date
    $time = $tim.GetDateTimeFormats('T')[0]
    $ws.popup("����ѡ��һ��������ɾ��", 5, "����", 0 + 48)
    Write-Host "$time ɾ��ʧ��: δѡ���κη���"
  }
}
$button2.Add_Click($button2ClickEventHandler)

$button1ClickEventHandler = [System.EventHandler] {
  $tim = get-date
  $time = $tim.GetDateTimeFormats('T')[0]
  Write-Host "$time ������޸�Hosts��ť"
  $ws.popup("�ڼ��±��޸���ֱ�ӱ��漴��", 2, "��ʾ", 0 + 64)
  Edit-Hosts
}
$button1.Add_Click($button1ClickEventHandler)

$button3ClickEventHandler = [System.EventHandler] {
  $tim = get-date
  $time = $tim.GetDateTimeFormats('T')[0]
  Write-Host "$time ����˲鿴Դ�밴ť"
  Write-Host "˳�㻶ӭ�������ߵ�������Ŀ"
  Start-Process "https://github.com/lollipopnougat/my-powershell-project/blob/master/����ԱС����.ps1"
}
$button3.Add_Click($button3ClickEventHandler)

$app::EnableVisualStyles()
$app::Run($WForm)
