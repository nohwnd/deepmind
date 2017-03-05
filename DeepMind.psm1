function Add-DeepMind ($Url, $A, $B) {
    $body = [pscustomobject]@{
        a = $A;
        b = $B
    } | ConvertTo-Json

    Invoke-WebRequest -Uri "$Url/deepmind/add" -ContentType "application/json" -Method Post -Body $body | 
        select -expand Content
}