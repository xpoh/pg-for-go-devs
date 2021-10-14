package main

import (
	"context"
	"fmt"
	"github.com/jackc/pgx/v4/pgxpool"
	pg "github.com/xpoh/pg-for-go-devs/lesson-5/pkg/storage/postgres"
	"log"
)

func main() {
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

	fmt.Println("Find by value:")
	res, err := pg.SearchItemByValue(ctx, dbpool, 200.1703924840258, 5)

	if err != nil {
		log.Fatal(err)
	}
	if len(res) > 0 {
		for i := 0; i < len(res); i++ {
			fmt.Println("Record", i, "=", res[i])
		}
	}

	fmt.Println("Find by name:")
	res, err = pg.SearchItemByName(ctx, dbpool, "022ff469c06c392c375d26de14f99be7", 5)

	if err != nil {
		log.Fatal(err)
	}

	if len(res) > 0 {
		for i := 0; i < len(res); i++ {
			fmt.Println("Record", i, "=", res[i])
		}
	}
}
