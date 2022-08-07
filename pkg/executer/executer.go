package executer

import (
	"fmt"
	"regexp"
	"strconv"
	"strings"

	"github.com/mattn/go-pipeline"
)

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

func ExecShowCommand(containername string, vtyshArg string, jqArgs ...string) (string, error) {
	var commands = [][]string{
		{"docker", "exec", containername, "bash", "-c", "vtysh -c 'show " + vtyshArg + " json'"},
	}
	for _, jqArg := range jqArgs {
		builtArg := append([]string{"jq"}, jqArg)
		commands = append(commands, builtArg)
	}
	fmt.Println(commands)
	res, err := pipeline.Output(commands...)
	if err != nil {
		return "", err
	}
	print(string(res))

	return string(res), nil
}

func ExecCommand(containerName string, vtyshArgs ...string) error {
	for i, vtyshArg := range vtyshArgs {
		vtyshArgs[i] = "-c '" + vtyshArg + "'"
	}
	commands := []string{"docker", "exec", containerName, "bash", "-c", "vtysh -c 'conf t' " + strings.Join(vtyshArgs, " ")}

	fmt.Println(commands)
	_, err := pipeline.Output(commands)
	if err != nil {
		fmt.Println(err)
	}
	return err
}

// find num and convert. ignore other chars.
func ExtractAndToInt(strVal string) (int64, error) {
	rex := regexp.MustCompile("[0-9]+")
	strVal = rex.FindString(strVal)
	return strconv.ParseInt(strVal, 10, 64)
}
