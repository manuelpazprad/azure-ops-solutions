using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

try {
    $Name = $Request.Body.Name
    $userName = $env:CLIENT_ID
    $userPassword = ConvertTo-SecureString -String $env:CLIENT_SECRET -AsPlainText -Force
    $tenantId = $env:TENANT_ID

    $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $userName, $userPassword

    Connect-AzAccount -ServicePrincipal -TenantId $tenantId -Credential $credential

    $body = Get-AzResourceGroup -Name $Name
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body = $body
    })
}
catch {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::BadRequest
        Body = $body
    })
}
finally {
    Disconnect-AzAccount
}

