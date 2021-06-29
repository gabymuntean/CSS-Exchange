function Write-TestMailEnabledFolderResult {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [object]
        $TestResult
    )

    begin {
        $mailEnabledSystemFolder = 0
        $mailEnabledWithNoADObject = 0
        $mailDisabledWithProxyGuid = 0
        $orphanedMPF = 0
        $orphanedMPFDuplicate = 0
        $orphanedMPFDisconnected = 0
    }

    process {
        if ($TestResult.TestName -eq "MailEnabledFolder") {
            switch ($TestResult.ResultType) {
                "MailEnabledSystemFolder" { $mailEnabledSystemFolder++ }
                "MailEnabledWithNoADObject" { $mailEnabledWithNoADObject++ }
                "MailDisabledWithProxyGuid" { $mailDisabledWithProxyGuid++ }
                "OrphanedMPF" { $orphanedMPF++ }
                "OrphanedMPFDuplicate" { $orphanedMPFDuplicate++ }
                "OrphanedMPFDisconnected" { $orphanedMPFDisconnected++ }
            }
        }
    }

    end {
        if ($mailEnabledSystemFolder -gt 0) {
            Write-Host
            Write-Host $mailEnabledSystemFolder "system folders are mail-enabled. These folders should be mail-disabled."
            Write-Host "This can be done manually, or the following command can be used:"
            Write-Host ".\SourceSideValidations.ps1 -Fix MailEnabledSystemFolder" -ForegroundColor Green
        }

        if ($mailEnabledWithNoADObject -gt 0) {
            Write-Host
            Write-Host $mailEnabledWithNoADObject "folders are mail-enabled, but have no AD object. These folders should be mail-disabled."
            Write-Host "This can be done manually, or the following command can be used:"
            Write-Host ".\SourceSideValidations.ps1 -Fix MailEnabledWithNoADObject" -ForegroundColor Green
        }

        if ($mailDisabledWithProxyGuid -gt 0) {
            Write-Host
            Write-Host $mailDisabledWithProxyGuid "folders are mail-disabled, but have proxy GUID values. These folders should be mail-enabled."
            Write-Host "This can be done manually, or the following command can be used:"
            Write-Host ".\SourceSideValidations.ps1 -Fix MailDisabledWithProxyGuid" -ForegroundColor Green
        }

        if ($orphanedMPF -gt 0) {
            Write-Host
            Write-Host $orphanedMPF "mail public folders are orphaned. These directory objects should be deleted."
            Write-Host "This can be done manually, or the following command can be used:"
            Write-Host ".\SourceSideValidations.ps1 -Fix OrphanedMPF" -ForegroundColor Green
        }

        if ($orphanedMPFDuplicate -gt 0) {
            Write-Host
            Write-Host $orphanedMPFDuplicate "mail public folders point to public folders that point to a different directory object."
            Write-Host "These should be deleted. Their email addresses may be merged onto the linked object."
            Write-Host "This can be done manually, or the following command can be used:"
            Write-Host ".\SourceSideValidations.ps1 -Fix OrphanedMPFDuplicate" -ForegroundColor Green
        }

        if ($orphanedMPFDisconnected -gt 0) {
            Write-Host
            Write-Host $orphanedMPFDisconnected "mail public folders point to public folders that are mail-disabled."
            Write-Host "These require manual intervention. Either the directory object should be deleted, or the folder should be mail-enabled, or both."
            Write-Host "Open the ValidationResults.csv and filter for ResultType of OrphanedMPFDisconnected to identify these folders."
        }
    }
}
