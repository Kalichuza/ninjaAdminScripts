[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

$p1 = [System.Windows.Forms.Cursor]::Position
Start-Sleep -Seconds 15  # or use a shorter intervall with the -milliseconds parameter
$p2 = [System.Windows.Forms.Cursor]::Position
if($p1.X -eq $p2.X -and $p1.Y -eq $p2.Y) {
    "The mouse did not move"
} else {
    "The mouse moved"
}
