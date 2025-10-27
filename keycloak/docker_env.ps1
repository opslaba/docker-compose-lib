param(
    [string]$arg = ""
)

if ($arg -eq "up") {
    Write-Output  "Fixing eol for *.sh files"
    Get-ChildItem * -Include *.sh | ForEach-Object {
      ## If contains Windows line endings, replace with UNIX line endings
      Write-Output "fixing file {$_}"
      $content = Get-Content -Raw -Path $_.FullName
      $unixContent = $content -replace "`r`n","`n" -replace "`r","`n"
      [System.IO.File]::WriteAllText($_.FullName, $unixContent, (New-Object System.Text.UTF8Encoding($false)))
    }

    Write-Output  "Starting integration test dependencies"
    docker compose up keycloak.local
}
elseif ($arg -eq "down") {
    Write-Output "Tearing down integration test dependencies"
    docker compose down --remove-orphans
}

Write-Output "============== local_deps_env complete. ==============="
