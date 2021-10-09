package main

import (
	"context"
	"fmt"
	"github.com/jackc/pgx/v4/pgxpool"
	"log"
	"sync"
	"sync/atomic"
	"time"
)

type (
	Item  string
	Value string
)

type ItemsSearchParam struct {
	Item  Item
	Value Value
}

// search -- Изделия у которых значение параметра равно заданному
// Из функции возвращается список ItemsSearchParam, отсортированный по Value.
// Размер возвращаемого списка ограничен значением limit.
func search(ctx context.Context, dbpool *pgxpool.Pool, value float64, limit int) ([]ItemsSearchParam, error) {
	const sql = `
		SELECT 	i.name,
				p.value
		FROM proc p
                  LEFT JOIN tests t on p.id_test = t.id
                  LEFT JOIN items i on t.id = i.id
		WHERE p.value = $1
		ORDER BY i.name asc
		LIMIT $2;`

	rows, err := dbpool.Query(ctx, sql, value, limit)
	if err != nil {
		return nil, fmt.Errorf("failed to query data: %w", err)
	}
	// Вызов Close нужен, чтобы вернуть соединение в пул
	defer rows.Close()

	// В слайс hints будут собраны все строки, полученные из базы
	var hints []ItemsSearchParam

	// rows.Next() итерируется по всем строкам, полученным из базы.
	for rows.Next() {
		var hint ItemsSearchParam

		// Scan записывает значения столбцов в свойства структуры hint
		err = rows.Scan(&hint.Value, &hint.Item)
		if err != nil {
			return nil, fmt.Errorf("failed to scan row: %w", err)
		}

		hints = append(hints, hint)
	}

	// Проверка, что во время выборки данных не происходило ошибок
	if rows.Err() != nil {
		return nil, fmt.Errorf("failed to read response: %w", rows.Err())
	}

	return hints, nil
}

type AttackResults struct {
	Duration         time.Duration
	Threads          int
	QueriesPerformed uint64
}

func attack(ctx context.Context, duration time.Duration, threads int, dbpool *pgxpool.Pool) AttackResults {
	var queries uint64

	attacker := func(stopAt time.Time) {
		for {
			_, err := search(ctx, dbpool, 999.9293521371371, 5)
			if err != nil {
				log.Fatal(err)
			}

			atomic.AddUint64(&queries, 1)

			if time.Now().After(stopAt) {
				return
			}
		}
	}

	var wg sync.WaitGroup
	wg.Add(threads)

	startAt := time.Now()
	stopAt := startAt.Add(duration)

	for i := 0; i < threads; i++ {
		go func() {
			attacker(stopAt)
			wg.Done()
		}()
	}

	wg.Wait()

	return AttackResults{
		Duration:         time.Now().Sub(startAt),
		Threads:          threads,
		QueriesPerformed: queries,
	}
}

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

	duration := time.Duration(10 * time.Second)
	threads := 1000
	fmt.Println("start attack")
	fmt.Println("MaxConns=", cfg.MaxConns, " MinConns=", cfg.MinConns)
	res := attack(ctx, duration, threads, dbpool)

	fmt.Println("duration:", res.Duration)
	fmt.Println("threads:", res.Threads)
	fmt.Println("queries:", res.QueriesPerformed)
	qps := res.QueriesPerformed / uint64(res.Duration.Seconds())
	fmt.Println("QPS:", qps)
}
