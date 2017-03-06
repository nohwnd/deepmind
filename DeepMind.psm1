function Add-DeepMind ($A, $B) {
    $body = [pscustomobject]@{
        a = $A;
        b = $B
    } | ConvertTo-Json

    Invoke-WebRequest -Uri "http://dupsug10.0115633a.svc.dockerapp.io/deepmind/add" `
        -ContentType "application/json" -Method Post -Body $body | 
            select -expand Content
}