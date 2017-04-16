var sln = "MySolution.sln";

Task("Restore").Does(() => {
        DotNetRestore(sln);
    });

Task("Build").Does(() => {
        DotNetBuild(sln);
    });

Task("Test").Does(() => {});

var target = Argument("target", "default");
RunTarget(target);




