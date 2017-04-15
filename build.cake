
Action<string,string> process = (cmd, args) => {
    StartProcess(cmd, new ProcessSettings {
        Arguments = args
    });
};

Task("Run-Test").Does(() => {
   process("emacs", "-batch -l ert -l cake-mode-tests.el -f ert-run-tests-batch-and-exit");
});

var target = Argument("Target", "Default");
RunTarget(target);
