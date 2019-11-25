$downloads = "$HOME\Downloads"
$filesToWatch = "**"

$WatherProperties = @{
  Path   = $downloads;
  Filter = $filesToWatch;
  NotifyFilter = [IO.NotifyFilters]"FileName, LastWrite"
  IncludeSubdirectories = $false; 
}

$FileChangeHandler = {
  $name = $Event.SourceEventArgs.Name 
  $changeType = $Event.SourceEventArgs.ChangeType 
  $timeStamp = $Event.TimeGenerated 
  Write-Host "The file '$name' was $changeType at $timeStamp" 
}

$FileChangeNotifier = New-Object IO.FileSystemWatcher -Property $WatherProperties

Register-ObjectEvent $FileChangeNotifier Created -SourceIdentifier FileCreated -Action $FileChangeHandler 
Register-ObjectEvent $FileChangeNotifier Deleted -SourceIdentifier FileDeleted -Action $FileChangeHandler
Register-ObjectEvent $FileChangeNotifier Changed -SourceIdentifier FileChanged -Action $FileChangeHandler
get-job | Wait-Job