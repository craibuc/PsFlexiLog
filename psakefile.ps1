FormatTaskName "-------- {0} --------"

Task default -depends Publish

Task Publish {
    publish-module -name ./PsFlexiLog -Repository Lorenz
}