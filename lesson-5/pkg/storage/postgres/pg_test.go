// +build integration

package postgres

import (
	"context"
	"fmt"
	"github.com/jackc/pgx/v4/pgxpool"
	"log"
	"testing"
)

func TestIntegrationSearchItemByName(t *testing.T) {
	ctx := context.Background()
	url := "postgres://akaddr:aswqas@localhost:5432/base10"

	cfg, err := pgxpool.ParseConfig(url)
	if err != nil {
		log.Fatal(err)
	}

	cfg.MaxConns = 15
	cfg.MinConns = 15

	dbpool, err := pgxpool.ConnectConfig(ctx, cfg)
	if err != nil {
		log.Fatal(err)
	}
	defer dbpool.Close()

	fmt.Println("Find by name test:")
	res, err := SearchItemByName(ctx, dbpool, "022ff469c06c392c375d26de14f99be7", 5)

	if err != nil {
		log.Fatal(err)
	}
	if len(res) == 0 {
		t.Errorf("Record count 0")
	} else {
		if res[0].Item != "022ff469c06c392c375d26de14f99be7" {
			t.Errorf("got Value = %s, want 022ff469c06c392c375d26de14f99be7", res[0].Item)
		}
	}
}

func TestIntegrationSearchItemByValue(t *testing.T) {
	ctx := context.Background()
	url := "postgres://akaddr:aswqas@localhost:5432/base10"

	cfg, err := pgxpool.ParseConfig(url)
	if err != nil {
		log.Fatal(err)
	}

	cfg.MaxConns = 15
	cfg.MinConns = 15

	dbpool, err := pgxpool.ConnectConfig(ctx, cfg)
	if err != nil {
		log.Fatal(err)
	}
	defer dbpool.Close()

	fmt.Println("Find by value test:")
	res, err := SearchItemByValue(ctx, dbpool, 200.1703924840258, 5)

	if err != nil {
		log.Fatal(err)
	}
	if len(res) == 0 {
		t.Errorf("Record count 0")
	} else {
		if res[0].Value != 200.1703924840258 {
			t.Errorf("got Value = %f, want 200.1703924840258", res[0].Value)
		}
	}
}
