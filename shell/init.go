package main

import (
	"bytes"
	"context"
	"fmt"
	"github.com/zdnscloud/gok8s/client"
	"github.com/zdnscloud/gok8s/client/config"
	corev1 "k8s.io/api/core/v1"
	k8stypes "k8s.io/apimachinery/pkg/types"
	"os"
	"os/exec"
)

func getBlocks(name string) string {
	config, err := config.GetConfig()
	cli, err := client.New(config, client.Options{})
	if err != nil {
		fmt.Println(err)
	}
	node := corev1.Node{}
	err = cli.Get(context.TODO(), k8stypes.NamespacedName{"", name}, &node)
	return node.Annotations["zdnscloud.cn/external-ip"]
}
func exec_shell(devs string) string {
	cmd := exec.Command("/bin/bash", "-c", "/lvmd.sh", devs)
	var out bytes.Buffer
	cmd.Stdout = &out
	err := cmd.Run()
	if err != nil {
		return fmt.Sprintf("%s", err)
	}
	return out.String()
}

func main() {
	/*
		name := os.Getenv("NodeName")
		devs := getBlocks(name)
		result := exec_shell(strings.Replace(devs, ",", " ", -1))
		fmt.Println(result)
	*/
	fmt.Println("===")
}
