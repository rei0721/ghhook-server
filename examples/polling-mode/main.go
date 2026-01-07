package main

import (
	"log"
	"os"
	"time"

	"github.com/rei0721/ghhook"
)

func main() {
	hook, err := ghhook.New(":8080", "",
		// 启用轮询模式
		ghhook.WithPolling(true),
		ghhook.WithGitHubToken(os.Getenv("GITHUB_TOKEN")),
		ghhook.WithRepositories("owner/repo"), // 替换为你的仓库
		ghhook.WithPollingInterval(30*time.Second),
	)
	if err != nil {
		log.Fatal(err)
	}

	hook.On("push", func(ctx *ghhook.Context) error {
		log.Printf("📦 仓库 %s 收到推送: %s",
			ctx.Repo.FullName,
			ctx.Push.HeadCommit.Message)
		return nil
	})

	hook.On("issues", func(ctx *ghhook.Context) error {
		log.Printf("📝 新 Issue: %s", ctx.Issue.Title)
		return nil
	})

	hook.Run()
}
