<#
.SYNOPSIS
    This script clears all print queues on the system.

.DESCRIPTION
    The script defines a function to clear all print queues and creates a simple Windows form with a button to trigger the function.

.FUNCTION Clear-PrintQueues
    Retrieves all printers on the system and clears their print queues.

.EXAMPLE
    .\Clear-PrintQueues.ps1
    This command displays a form with a button. When the button is clicked, all print queues on the system are cleared.

#>

# Function to clear all print queues
function Clear-PrintQueues {
    $printers = Get-Printer
    foreach ($printer in $printers) {
        $printerName = $printer.Name
        Get-PrintJob -PrinterName $printerName | Remove-PrintJob
    }
    [System.Windows.Forms.MessageBox]::Show("All print queues have been cleared!")
}

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Clear Print Queues"
$form.Size = New-Object System.Drawing.Size(300,150)
$form.StartPosition = "CenterScreen"

# Create a button
$button = New-Object System.Windows.Forms.Button
$button.Text = "Clear Print Queues"
$button.Size = New-Object System.Drawing.Size(150,30)
$button.Location = New-Object System.Drawing.Point(75,50)
$button.Add_Click({ Clear-PrintQueues })
$form.Controls.Add($button)

# Show the form
$form.Add_Shown({$form.Activate()})
[void]$form.ShowDialog()
