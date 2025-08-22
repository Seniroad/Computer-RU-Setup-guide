$AllMitigations = @(
    "DEP","EmulateAtlThunks","SEHOP","ForceRelocateImages","RequireInfo","BottomUp",
    "HighEntropy","StrictHandle","DisableWin32kSystemCalls","AuditSystemCall",
    "DisableExtensionPoints","BlockDynamicCode","AllowThreadsToOptOut","AuditDynamicCode",
    "CFG","SuppressExports","StrictCFG","MicrosoftSignedOnly","AllowStoreSignedBinaries",
    "AuditMicrosoftSigned","AuditStoreSigned","EnforceModuleDependencySigning",
    "DisableNonSystemFonts","AuditFont","BlockRemoteImageLoads","BlockLowLabelImageLoads",
    "PreferSystem32","AuditRemoteImageLoads","AuditLowLabelImageLoads","AuditPreferSystem32",
    "EnableExportAddressFilter","AuditEnableExportAddressFilter",
    "EnableExportAddressFilterPlus","AuditEnableExportAddressFilterPlus",
    "EnableImportAddressFilter","AuditEnableImportAddressFilter",
    "EnableRopStackPivot","AuditEnableRopStackPivot","EnableRopCallerCheck",
    "AuditEnableRopCallerCheck","EnableRopSimExec","AuditEnableRopSimExec",
    "SEHOP","AuditSEHOP","SEHOPTelemetry","TerminateOnError",
    "DisallowChildProcessCreation","AuditChildProcess"
)

# Отключение глобально
Set-ProcessMitigation -System -Disable $AllMitigations

# Отключение для всех exe в System32
$exeFiles = Get-ChildItem "C:\Windows\System32" -Filter *.exe -File
foreach ($exe in $exeFiles) {
    try {
        Write-Host "Отключаю политики для $($exe.Name)..."
        Set-ProcessMitigation -Name $exe.Name -Disable $AllMitigations -ErrorAction Stop
    }
    catch {
        Write-Host "Не удалось отключить для $($exe.Name): $_"
    }
}
