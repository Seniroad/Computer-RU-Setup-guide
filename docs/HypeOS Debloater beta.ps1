Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$darkBgColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$darkControlColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$darkTextColor = [System.Drawing.Color]::White
$darkHighlightColor = [System.Drawing.Color]::FromArgb(70, 130, 180)
$darkGridColor = [System.Drawing.Color]::FromArgb(60, 60, 60)
$disabledBgColor = [System.Drawing.Color]::FromArgb(70, 70, 70)
$disabledTextColor = [System.Drawing.Color]::FromArgb(150, 150, 150)
$removalHistoryFile = "removed_packages.cfg"

$Form = New-Object System.Windows.Forms.Form
$Form.Text = "HypeOS Debloat"
$Form.Size = New-Object System.Drawing.Size(1000, 600)
$Form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$Form.BackColor = $darkBgColor
$Form.ForeColor = $darkTextColor
$Form.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::None

$DataGridView = New-Object System.Windows.Forms.DataGridView
$DataGridView.Location = New-Object System.Drawing.Point(10, 40)
$DataGridView.Size = New-Object System.Drawing.Size(960, 470)
$DataGridView.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$DataGridView.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::Fill
$DataGridView.ColumnHeadersHeightSizeMode = [System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode]::AutoSize
$DataGridView.SelectionMode = [System.Windows.Forms.DataGridViewSelectionMode]::FullRowSelect
$DataGridView.MultiSelect = $false
$DataGridView.BackgroundColor = $darkGridColor
$DataGridView.ForeColor = $darkTextColor
$DataGridView.DefaultCellStyle.BackColor = $darkGridColor
$DataGridView.DefaultCellStyle.ForeColor = $darkTextColor
$DataGridView.DefaultCellStyle.SelectionBackColor = $darkHighlightColor
$DataGridView.DefaultCellStyle.SelectionForeColor = [System.Drawing.Color]::White
$DataGridView.ColumnHeadersDefaultCellStyle.BackColor = $darkControlColor
$DataGridView.ColumnHeadersDefaultCellStyle.ForeColor = $darkTextColor
$DataGridView.ColumnHeadersDefaultCellStyle.SelectionBackColor = $darkControlColor
$DataGridView.RowHeadersDefaultCellStyle.BackColor = $darkControlColor
$DataGridView.RowHeadersDefaultCellStyle.ForeColor = $darkTextColor
$DataGridView.AllowUserToAddRows = $false
$DataGridView.ShowCellToolTips = $false

$UninstallColumn = New-Object System.Windows.Forms.DataGridViewCheckBoxColumn
$UninstallColumn.Name = "Uninstall"
$UninstallColumn.HeaderText = "Uninstall"
$DataGridView.Columns.Add($UninstallColumn) | Out-Null
$DataGridView.Columns.Add("Package Name", "Package Name") | Out-Null
$DataGridView.Columns.Add("Package Full Name", "Package Full Name") | Out-Null
$DataGridView.Columns.Add("Required For", "Required For") | Out-Null
$DataGridView.Columns.Add("Non Removable", "Non Removable") | Out-Null
$DataGridView.Columns.Add("Framework", "Framework") | Out-Null
$DataGridView.Columns.Add("Install Location", "Install Location") | Out-Null

$ContextMenu = New-Object System.Windows.Forms.ContextMenuStrip
$ContextMenu.BackColor = $darkControlColor
$ContextMenu.ForeColor = $darkTextColor
$ContextMenu.RenderMode = [System.Windows.Forms.ToolStripRenderMode]::System

$SearchGoogleMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem
$SearchGoogleMenuItem.Text = "Search in Google"
$SearchGoogleMenuItem.Add_Click({
    $selectedRow = $DataGridView.CurrentRow
    if ($selectedRow -ne $null) {
        $packageName = $selectedRow.Cells["Package Name"].Value
        if ($packageName -ne $null) {
            $searchQuery = [System.Uri]::EscapeDataString($packageName.ToString() + " windows package")
            $searchUrl = "https://www.google.com/search?q=$searchQuery"
            Start-Process $searchUrl
        }
    }
})
$ContextMenu.Items.Add($SearchGoogleMenuItem) | Out-Null

$CopyMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem
$CopyMenuItem.Text = "Copy"
$CopyMenuItem.Add_Click({
    $selectedRow = $DataGridView.CurrentRow
    if ($selectedRow -ne $null) {
        $cellValue = $selectedRow.Cells["Install Location"].Value
        if ($cellValue -ne $null) {
            [System.Windows.Forms.Clipboard]::SetText($cellValue.ToString())
        }
    }
})
$ContextMenu.Items.Add($CopyMenuItem) | Out-Null

$OpenPathMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem
$OpenPathMenuItem.Text = "Open Path"
$OpenPathMenuItem.Add_Click({
    $selectedRow = $DataGridView.CurrentRow
    if ($selectedRow -ne $null) {
        $path = $selectedRow.Cells["Install Location"].Value
        if ($path -ne $null -and [System.IO.Directory]::Exists($path)) {
            Start-Process explorer.exe -ArgumentList "/select,`"$path`""
        }
    }
})
$ContextMenu.Items.Add($OpenPathMenuItem) | Out-Null

$DataGridView.ContextMenuStrip = $ContextMenu

$DataGridView.Add_MouseDown({
    param($sender, $e)
    if ($e.Button -eq [System.Windows.Forms.MouseButtons]::Right) {
        $hitTest = $sender.HitTest($e.X, $e.Y)
        if ($hitTest.Type -eq [System.Windows.Forms.DataGridViewHitTestType]::Cell) {
            $rowIndex = $hitTest.RowIndex
            $columnIndex = $hitTest.ColumnIndex
            $sender.ClearSelection()
            $sender.Rows[$rowIndex].Selected = $true
            $sender.CurrentCell = $sender.Rows[$rowIndex].Cells[$columnIndex]
            $ContextMenu.Show($sender, $e.Location)
        }
    }
})

function Filter-Rows {
    param ([string]$searchText)
    $DataGridView.SuspendLayout()
    foreach ($row in $DataGridView.Rows) {
        if ($row.Cells["Package Name"].Value -ne $null) {
            $packageName = $row.Cells["Package Name"].Value.ToString().ToLower()
            $row.Visible = $packageName -like "*$($searchText.ToLower())*"
        }
    }
    $DataGridView.ResumeLayout()
}

$SearchBox = New-Object System.Windows.Forms.TextBox
$SearchBox.Location = New-Object System.Drawing.Point(10, 10)
$SearchBox.Size = New-Object System.Drawing.Size(300, 20)
$SearchBox.BackColor = $darkControlColor
$SearchBox.ForeColor = $darkTextColor
$SearchBox.Add_TextChanged({ Filter-Rows -searchText $SearchBox.Text })

$SearchButton = New-Object System.Windows.Forms.Button
$SearchButton.Location = New-Object System.Drawing.Point(320, 10)
$SearchButton.Size = New-Object System.Drawing.Size(100, 20)
$SearchButton.Text = "Search"
$SearchButton.BackColor = $darkControlColor
$SearchButton.ForeColor = $darkTextColor
$SearchButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$SearchButton.Add_Click({ Filter-Rows -searchText $SearchBox.Text })

$Form.Controls.Add($SearchBox)
$Form.Controls.Add($SearchButton)

$UninstallButton = New-Object System.Windows.Forms.Button
$UninstallButton.Location = New-Object System.Drawing.Point(10, 520)
$UninstallButton.Size = New-Object System.Drawing.Size(200, 30)
$UninstallButton.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left
$UninstallButton.Text = "Uninstall Selected Packages"
$UninstallButton.BackColor = $darkControlColor
$UninstallButton.ForeColor = $darkTextColor
$UninstallButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$UninstallButton.Add_Click({
    $selectedApps = @()
    foreach ($row in $DataGridView.Rows) {
        if ($row.Cells["Non Removable"].Value -eq $true) { continue }
        if ($row.Cells["Uninstall"].Value -eq $true) {
            $selectedApps += $row.Cells["Package Full Name"].Value
        }
    }
    if ($selectedApps.Count -gt 0) {
        Show-ConfirmationDialog $selectedApps
    }
})
$Form.Controls.Add($UninstallButton)

function Remove-PackagesSequentially {
    param([array]$packagesToRemove)
    if (-not (Test-Path $removalHistoryFile)) {
        New-Item -Path $removalHistoryFile -ItemType File -Force | Out-Null
    }
    foreach ($package in $packagesToRemove) {
        try {
            Remove-AppxPackage -Package $package -ErrorAction Stop
            Add-Content -Path $removalHistoryFile -Value "$package|$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
            Start-Sleep -Milliseconds 300
        }
        catch {
            Write-Host "Error removing package $package : $_"
        }
    }
}

function Show-ConfirmationDialog($selectedApps) {
    $ConfirmationDialog = New-Object System.Windows.Forms.Form
    $ConfirmationDialog.Text = "Confirmation"
    $ConfirmationDialog.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    $ConfirmationDialog.AutoSize = $true
    $ConfirmationDialog.MaximizeBox = $false
    $ConfirmationDialog.MinimizeBox = $false
    $ConfirmationDialog.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $ConfirmationDialog.TopMost = $true
    $ConfirmationDialog.Padding = New-Object System.Windows.Forms.Padding(10)
    $ConfirmationDialog.BackColor = $darkBgColor
    $ConfirmationDialog.ForeColor = $darkTextColor

    $tableLayoutPanel = New-Object System.Windows.Forms.TableLayoutPanel
    $tableLayoutPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
    $tableLayoutPanel.RowCount = 3
    $tableLayoutPanel.ColumnCount = 1
    $tableLayoutPanel.AutoSize = $true
    $tableLayoutPanel.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowOnly
    $tableLayoutPanel.BackColor = $darkBgColor

    $Label = New-Object System.Windows.Forms.Label
    $Label.AutoSize = $true
    $Label.Text = "Are you sure you want to uninstall the following apps:" + [Environment]::NewLine + [Environment]::NewLine + ($selectedApps -join [Environment]::NewLine)
    $Label.BackColor = $darkBgColor
    $Label.ForeColor = $darkTextColor
    $tableLayoutPanel.Controls.Add($Label, 0, 0)

    $YesButton = New-Object System.Windows.Forms.Button
    $YesButton.Text = "Yes"
    $YesButton.DialogResult = [System.Windows.Forms.DialogResult]::Yes
    $YesButton.Size = New-Object System.Drawing.Size(80, 30)
    $YesButton.Margin = New-Object System.Windows.Forms.Padding(0, 0, 5, 0)
    $YesButton.BackColor = $darkControlColor
    $YesButton.ForeColor = $darkTextColor
    $YesButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat

    $NoButton = New-Object System.Windows.Forms.Button
    $NoButton.Text = "No"
    $NoButton.DialogResult = [System.Windows.Forms.DialogResult]::No
    $NoButton.Size = New-Object System.Drawing.Size(80, 30)
    $NoButton.Margin = New-Object System.Windows.Forms.Padding(5, 0, 0, 0)
    $NoButton.BackColor = $darkControlColor
    $NoButton.ForeColor = $darkTextColor
    $NoButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat

    $buttonPanel = New-Object System.Windows.Forms.Panel
    $buttonPanel.Dock = [System.Windows.Forms.DockStyle]::Bottom
    $buttonPanel.Height = 40
    $buttonPanel.Controls.Add($YesButton)
    $buttonPanel.Controls.Add($NoButton)
    $buttonPanel.BackColor = $darkBgColor
    $YesButton.Location = New-Object System.Drawing.Point(10, 5)
    $NoButton.Location = New-Object System.Drawing.Point(100, 5)
    $tableLayoutPanel.Controls.Add($buttonPanel, 0, 2) 

    $ConfirmationDialog.Controls.Add($tableLayoutPanel)
    $result = $ConfirmationDialog.ShowDialog()
    
    if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
        Remove-PackagesSequentially -packagesToRemove $selectedApps
        Refresh-AppList
    }
}

$RefreshButton = New-Object System.Windows.Forms.Button
$RefreshButton.Location = New-Object System.Drawing.Point(220, 520)
$RefreshButton.Size = New-Object System.Drawing.Size(200, 30)
$RefreshButton.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left
$RefreshButton.Text = "Refresh List"
$RefreshButton.BackColor = $darkControlColor
$RefreshButton.ForeColor = $darkTextColor
$RefreshButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$RefreshButton.Add_Click({ Refresh-AppList })
$Form.Controls.Add($RefreshButton)

$RestoreButton = New-Object System.Windows.Forms.Button
$RestoreButton.Location = New-Object System.Drawing.Point(430, 520)
$RestoreButton.Size = New-Object System.Drawing.Size(200, 30)
$RestoreButton.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left
$RestoreButton.Text = "Restore Packages"
$RestoreButton.BackColor = $darkControlColor
$RestoreButton.ForeColor = $darkTextColor
$RestoreButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$RestoreButton.Add_Click({ Show-RestoreDialog })
$Form.Controls.Add($RestoreButton)

function Refresh-AppList {
    try {
        $DataGridView.SuspendLayout()
        $DataGridView.Rows.Clear()
        
        $apps = Get-AppxPackage | Select Name, PackageFullName, IsFramework, NonRemovable, Dependencies, InstallLocation
        
        foreach ($app in $apps) {
            $row = $DataGridView.Rows.Add()
            $DataGridView.Rows[$row].Cells["Uninstall"].Value = $false
            $DataGridView.Rows[$row].Cells["Package Name"].Value = $app.Name
            $DataGridView.Rows[$row].Cells["Package Full Name"].Value = $app.PackageFullName
            $deps = if ($app.Dependencies) { ($app.Dependencies | ForEach-Object { $_.Name }) -join ", " } else { "" }
            $DataGridView.Rows[$row].Cells["Required For"].Value = $deps
            $DataGridView.Rows[$row].Cells["Non Removable"].Value = $app.NonRemovable
            $DataGridView.Rows[$row].Cells["Framework"].Value = $app.IsFramework
            $DataGridView.Rows[$row].Cells["Install Location"].Value = $app.InstallLocation

            if ($app.NonRemovable -eq $true) {
                $DataGridView.Rows[$row].Cells["Uninstall"].ReadOnly = $true
                $DataGridView.Rows[$row].Cells["Uninstall"].Value = $false
                $DataGridView.Rows[$row].DefaultCellStyle.BackColor = $disabledBgColor
                $DataGridView.Rows[$row].DefaultCellStyle.ForeColor = $disabledTextColor
            }
        }
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("Error loading apps: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
    finally {
        $DataGridView.ResumeLayout()
    }
}

function Show-RestoreDialog {
    $RestoreForm = New-Object System.Windows.Forms.Form
    $RestoreForm.Text = "Restore Packages"
    $RestoreForm.Size = New-Object System.Drawing.Size(600, 400)
    $RestoreForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
    $RestoreForm.BackColor = $darkBgColor
    $RestoreForm.ForeColor = $darkTextColor

    if (Test-Path $removalHistoryFile) {
        $removalHistory = Get-Content $removalHistoryFile | Where-Object { $_ -ne "" }
    }
    else {
        $removalHistory = @()
    }

    $packageList = @()
    foreach ($entry in $removalHistory) {
        $parts = $entry -split '\|'
        if ($parts -and $parts[0]) {
            $packageList += $parts[0]
        }
    }

    $listBox = New-Object System.Windows.Forms.CheckedListBox
    $listBox.Location = New-Object System.Drawing.Point(10, 10)
    $listBox.Size = New-Object System.Drawing.Size(560, 300)
    $listBox.BackColor = $darkControlColor
    $listBox.ForeColor = $darkTextColor
    $listBox.CheckOnClick = $true

    foreach ($pkg in $packageList) {
        $listBox.Items.Add($pkg, $false) | Out-Null
    }

    $selectAllButton = New-Object System.Windows.Forms.Button
    $selectAllButton.Location = New-Object System.Drawing.Point(10, 320)
    $selectAllButton.Size = New-Object System.Drawing.Size(100, 30)
    $selectAllButton.Text = "Select All"
    $selectAllButton.BackColor = $darkControlColor
    $selectAllButton.ForeColor = $darkTextColor
    $selectAllButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $selectAllButton.Add_Click({
        for ($i = 0; $i -lt $listBox.Items.Count; $i++) {
            $listBox.SetItemChecked($i, $true)
        }
    })

    $restoreSelectedButton = New-Object System.Windows.Forms.Button
    $restoreSelectedButton.Location = New-Object System.Drawing.Point(120, 320)
    $restoreSelectedButton.Size = New-Object System.Drawing.Size(150, 30)
    $restoreSelectedButton.Text = "Restore Selected"
    $restoreSelectedButton.BackColor = $darkControlColor
    $restoreSelectedButton.ForeColor = $darkTextColor
    $restoreSelectedButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $restoreSelectedButton.Add_Click({
        $selectedPackages = $listBox.CheckedItems
        $RestoreForm.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
        $successCount = 0
        $failedCount = 0
        $failedPackages = @()
        
        foreach ($pkg in $selectedPackages) {
            $packageName = ($pkg -split '_')[0]
            try {
                $installed = Get-AppxPackage -Name $packageName
                if ($installed) {
                    $successCount++
                    continue
                }
                
                $storePackage = Get-AppxPackage -AllUsers | Where-Object { $_.Name -eq $packageName } | Select-Object -First 1
                if ($storePackage) {
                    Add-AppxPackage -Register "$($storePackage.InstallLocation)\AppxManifest.xml" -DisableDevelopmentMode
                    $successCount++
                }
                else {
                    Start-Process "ms-windows-store://pdp/?ProductId=$packageName"
                    $successCount++
                }
            }
            catch {
                $failedCount++
                $failedPackages += $packageName
            }
        }
        
        $message = "Restore completed!`nSuccess: $successCount`nFailed: $failedCount"
        if ($failedCount -gt 0) {
            $message += "`n`nFailed packages:`n$($failedPackages -join "`n")"
        }
        
        [System.Windows.Forms.MessageBox]::Show($message, "Restore Status")
        Refresh-AppList
        $RestoreForm.Cursor = [System.Windows.Forms.Cursors]::Default
    })

    $RestoreForm.Controls.Add($listBox)
    $RestoreForm.Controls.Add($selectAllButton)
    $RestoreForm.Controls.Add($restoreSelectedButton)
    $RestoreForm.ShowDialog()
}

$Form.Add_FormClosing({
    if ($ContextMenu.Visible) {
        $ContextMenu.Hide()
    }
})

$Form.Add_FormClosed({
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
})

Refresh-AppList
$Form.Controls.Add($DataGridView)
$Form.Add_Shown({ $DataGridView.Focus() })

try {
    [void]$Form.ShowDialog()
}
catch {
    [System.Windows.Forms.MessageBox]::Show("Critical error: $_", "Fatal Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
}