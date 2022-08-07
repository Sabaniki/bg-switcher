package util

import (
	"fmt"
	"runtime"
	"strings"
	"time"
)

type Result struct {
	StatusUpdated bool
	SpecUpdated   bool
	Requeue       bool
	RequeueAfter  time.Duration
}

func NewResult() Result {
	return Result{
		StatusUpdated: false,
		SpecUpdated:   false,
		Requeue:       false,
		RequeueAfter:  5 * time.Second,
	}
}

func CallerFUNC() string {
	pt, _, _, ok := runtime.Caller(2)
	if !ok {
		return fmt.Sprintf("ERR")
	}
	fn := runtime.FuncForPC(pt).Name()
	fna := strings.Split(fn, "/")
	sn := fna[len(fna)-1]
	return fmt.Sprintf("%s", sn)
}

func CallerLINE() string {
	_, file, line, ok := runtime.Caller(2)
	if !ok {
		return fmt.Sprintf("ERR")
	}
	return fmt.Sprintf("%s:%d", file, line)
}

func LINE() string {
	_, file, line, ok := runtime.Caller(1)
	if !ok {
		return fmt.Sprintf("ERR")
	}
	return fmt.Sprintf("%s:%d", file, line)
}

func Reverse(s string) string {
	runes := []rune(s)
	for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
		runes[i], runes[j] = runes[j], runes[i]
	}
	return string(runes)
}
