package executer

import (
	"github.com/mattn/go-pipeline"
)

func ExecCommand(args [][]string) (string, error) {
	res, err := pipeline.Output(args...)
	return string(res), err
}

func ExecWithJq(arg string, jqArgs ...string) (string, error) {
	var commands = [][]string{
		{"/bin/bash", "-c", arg},
	}
	for _, jqArg := range jqArgs {
		builtArg := append([]string{"jq"}, jqArg)
		commands = append(commands, builtArg)
	}
	res, err := pipeline.Output(commands...)
	if err != nil {
		return "", err
	}

	return string(res), err
}
