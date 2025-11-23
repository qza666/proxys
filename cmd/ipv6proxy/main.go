package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/qza1314526-debug/v6-ee/internal/config"
	"github.com/qza1314526-debug/v6-ee/internal/proxy"
	"github.com/qza1314526-debug/v6-ee/internal/sysutils"
)

func main() {
	log.SetOutput(os.Stdout)
	cfg := config.ParseFlags()
	if cfg.CIDR == "" {
		log.Fatal("CIDR is required")
	}

	if cfg.AutoForwarding {
		sysutils.SetV6Forwarding()
	}

	if cfg.AutoRoute {
		sysutils.AddV6Route(cfg.CIDR)
	}

	if cfg.AutoIpNoLocalBind {
		sysutils.SetIpNonLocalBind()
	}

	log.Printf("Starting random IPv6 proxy server on %s:%d", cfg.Bind, cfg.RandomIPv6Port)
	proxyServer := proxy.NewProxyServer(cfg)
	if err := http.ListenAndServe(fmt.Sprintf("%s:%d", cfg.Bind, cfg.RandomIPv6Port), proxyServer); err != nil {
		log.Fatal(err)
	}
}
