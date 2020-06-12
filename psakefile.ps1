FormatTaskName "-------- {0} --------"

Task default -depends Publish

Task Symlink {
    $Module='PsFlexiLog'
    $Here = Get-Location
    Push-Location ~/.local/share/powershell/Modules
    ln -s "$Here/$Module" $Module
    Pop-Location
}

Task Publish {
    publish-module -name ./PsFlexiLog -Repository Lorenz
}