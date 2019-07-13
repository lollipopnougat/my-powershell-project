$VideoFiles = "*.3gp", "*.asf", "*.ass", "*.avi", "*.flv", "*.f4v", "*.m4a", "*.mkv", "*.mov", "*.mp4", "*.mpg", "*.mpeg", "*.rm", "*.rmvb", "*.smi", "*.srt", "*.ssa", "*.swf", "*.ts", "*.vob", "*.webm", "*.wmv"
$MusicFiles = "*.aac", "*.ac3", "*.amr", "*.ape", "*.au", "*.flac", "*.lrc", "*.m4r", "*.m4v", "*.mid", "*.midi", "*.mp3", "*.ogg", "*.ra", "*.wav", "*.wma", "*.wv"
$TextFiles = "*.txt", "*."
$DocumentFiles = "*.doc", "*.docx", "*.odt", "*.docm", "*.pdf"
$ExcelFiles = "*.xls", "*.xlsx", "*.ods", "*.xlsm"
$PowerPointFiles = "*.ppt", "*pptx", "*.odp", "*.pps", "*.ppsx", "*.pptm", "*.rtf"
$ImageFiles = "*.bmp", "*.dib", "*.emf", "*.jpg", "*.jpe", "*.jpeg", "*.gif", "*.pcx", "*.png", "*.svg", "*.tga", "*.tif", "*.tiff", "*.webp", "*.wmf"
$CompressFiles = "*.zip", "*.7z", "*.rar", "*.tar", "*.gz", "*.xz", "*.bz2"
$AdobeImageFiles = "*.psd", "*.pdd", "*.psdt", "*.psb", "*.ai", "*.eps"
function Archive-ByCreateTime {
    $lst = ls -file | where name -ne ArchiveFiles.ps1
    if ($lst.count -eq 0) {
        Write-Host "啊呀,这个目录下没有别的文件哟!"
        return
    }
    Write-Host "是否需要具体到天?"
    $cmd = Read-Host "输入Y表示开启归档具体到天,其他输入均认为不开启"
    $TimeType
    if ($cmd -eq "Y" -or $cmd -eq "y") {
        $TimeType = 'D'
    }
    else {
        $TimeType = 'y'
    }
    $statistics = @()
    $lst | foreach {
        $folder = $_.CreationTime.GetDateTimeFormats($TimeType)[0]
        if (!(Test-Path $folder)) {
            mkdir $folder | Out-Null
        }
        mv $_.name $folder
        if (!($statistics -contains $folder)) {
            $statistics += $folder
        }
    }
    Write-Host "将所有文件按创建时间归档为: "
    $statistics | foreach {
        Write-Host $_ 
    }
}

function Archive-ByLastWriteTime {
    $lst = ls -file | where name -ne ArchiveFiles.ps1
    if ($lst.count -eq 0) {
        Write-Host "啊呀,这个目录下没有别的文件哟!"
        return
    }
    Write-Host "是否需要具体到天?"
    $cmd = Read-Host "输入Y表示开启归档具体到天,其他输入均认为不开启"
    $TimeType
    if ($cmd -eq "Y" -or $cmd -eq "y") {
        $TimeType = 'D'
    }
    else {
        $TimeType = 'y'
    }
    $statistics = @()
    $lst | foreach {
        $folder = $_.LastWriteTime.GetDateTimeFormats($TimeType)[0]
        if (!(Test-Path $folder)) {
            mkdir $folder | Out-Null
        }
        mv $_.name $folder
        if (!($statistics -contains $folder)) {
            $statistics += $folder
        }
    }
    Write-Host "将所有文件按最后修改时间归档为: "
    $statistics | foreach {
        Write-Host $_ 
    }
}

function Archive-ByLastAccessTime {
    $lst = ls -file | where name -ne ArchiveFiles.ps1
    if ($lst.count -eq 0) {
        Write-Host "啊呀,这个目录下没有别的文件哟!"
        return
    }
    Write-Host "是否需要具体到天?"
    $cmd = Read-Host "输入Y表示开启归档具体到天,其他输入均认为不开启"
    $TimeType
    if ($cmd -eq "Y" -or $cmd -eq "y") {
        $TimeType = 'D'
    }
    else {
        $TimeType = 'y'
    }
    $statistics = @()
    $lst | foreach {
        $folder = $_.LastAccessTime.GetDateTimeFormats($TimeType)[0]
        if (!(Test-Path $folder)) {
            mkdir $folder | Out-Null
        }
        mv $_.name $folder
        if (!($statistics -contains $folder)) {
            $statistics += $folder
        }
    }
    Write-Host "将所有文件按最后访问时间归档为: "
    $statistics | foreach {
        Write-Host $_ 
    }
}

function Archive-ByFileType {
    $lst = ls -file | where name -ne ArchiveFiles.ps1
    if ($lst.count -eq 0) {
        Write-Host "啊呀,这个目录下没有别的文件哟!"
        return
    }
    $vf = ls $VideoFiles
    $mf = ls $MusicFiles
    $tf = ls $TextFiles
    $df = ls $DocumentFiles
    $ef = ls $ExcelFiles
    $ppf = ls $PowerPointFiles
    $imf = ls $ImageFiles
    $cof = ls $CompressFiles
    $adf = ls $AdobeImageFiles
    $vfn = 0
    $mfn = 0
    $tfn = 0
    $dfn = 0
    $efn = 0
    $ppfn = 0
    $imfn = 0
    $cofn = 0
    $adfn = 0
    if ($vf.count -ne 0) {
        if (!(Test-Path Videos)) {
            mkdir Videos | Out-Null
        }
        $vf | foreach {
            mv $_.name Videos
            $vfn++
        }
    }
    if ($mf.count -ne 0) {
        if (!(Test-Path Musics)) {
            mkdir Musics | Out-Null
        }
        $mf | foreach {
            mv $_.name Musics
            $mfn++
        }
    }
    if ($tf.count -ne 0) {
        if (!(Test-Path Texts)) {
            mkdir Texts | Out-Null
        }
        $tf | foreach {
            mv $_.name Texts
            $tfn++
        }
    }
    if ($df.count -ne 0) {
        if (!(Test-Path Documents)) {
            mkdir Documents | Out-Null
        }
        $df | foreach {
            mv $_.name Documents
            $dfn++
        }
    }
    if ($ef.count -ne 0) {
        if (!(Test-Path Excels)) {
            mkdir Excels | Out-Null
        }
        $ef | foreach {
            mv $_.name Excels
            $efn++
        }
    }
    if ($ppf.count -ne 0) {
        if (!(Test-Path PowerPoints)) {
            mkdir PowerPoints | Out-Null
        }
        $ppf | foreach {
            mv $_.name PowerPoints
            $ppfn++
        }
    }
    if ($imf.count -ne 0) {
        if (!(Test-Path Images)) {
            mkdir Images | Out-Null
        }
        $imf | foreach {
            mv $_.name Images
            $imfn++
        }
    }
    if ($cof.count -ne 0) {
        if (!(Test-Path Compressed)) {
            mkdir Compressed | Out-Null
        }
        $cof | foreach {
            mv $_.name Compressed
            $cofn++
        }
    }
    if ($adf.count -ne 0) {
        if (!(Test-Path Adobes)) {
            mkdir Adobes | Out-Null
        }
        $adf | foreach {
            mv $_.name Adobes
            $adfn++
        }
    }
    Write-Host "归档了`n$vfn 个视频文件`n$mfn 个音频文件`n$tfn 个文本文件`n$dfn 个文档文件"
    Write-Host "$efn 个表格文件`n$ppfn 个幻灯片文件`n$imfn 个图片文件`n$cofn 个压缩包`n$adfn 个Adobe工程文件"
}

function make-backup {
    $lst = ls | where name -ne ArchiveFiles.ps1
    if ($lst.count -eq 0) {
        Write-Host "啊呀,这个目录下没有别的文件哟!"
        return
    }
    else {
        $filelst = @()
        $lst | foreach {
            $filelst += $_.name
        }
        $ZipName = Read-Host "输入备份输出文件名"
        Compress-Archive -Path $filelst -DestinationPath ($ZipName + ".zip") -Force
        if ($?) {
            Write-Host "备份成功, 文件放到当前目录下,名为: $ZipName.zip " 
        }
    }
    
}
#Archive-ByFileType
#Archive-ByCreateTime
$version = "Ver 1.2"
[console]::Title = "归档脚本 $version" 
while ($true) {
    echo "欢迎使用归档脚本 作者: LNP"
    echo "功能: "
    echo "1: 按文件类型归档`n2: 按创建时间归档`n3: 按最后修改时间归档`n4: 按最后访问时间归档`n5: 备份文件夹(zip)`n6: 退出"
    $input1 = Read-Host "请输入数字"
    switch ($input1) {
        "1" { Archive-ByFileType; break }
        "2" { Archive-ByCreateTime; break }
        "3" { Archive-ByLastWriteTime; break }
        "4" { Archive-ByLastAccessTime; break }
        "5" { make-backup; break }
        "6" { return }
        Default { echo "输入有误！" }
    }
    Pause
    clear
}
