package postgres

import (
	"context"
	"fmt"
	"github.com/jackc/pgx/v4/pgxpool"
)

type (
	Item  string
	Value float64
)

type ItemsSearchParam struct {
	Item  Item
	Value float64
}

// SearchItemByValue -- Изделия у которых значение параметра равно заданному
// Из функции возвращается список ItemsSearchParam, отсортированный по Value.
// Размер возвращаемого списка ограничен значением limit.
func SearchItemByValue(ctx context.Context, dbpool *pgxpool.Pool, value float64, limit int) ([]ItemsSearchParam, error) {
	const sql = `
		SELECT 	i.name,
				p.value::double precision
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
		err = rows.Scan(&hint.Item, &hint.Value)
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

// SearchItemByName -- поиск изделия по имени
// Из функции возвращается список ItemsSearchParam, отсортированный по Item.
// Размер возвращаемого списка ограничен значением limit.
func SearchItemByName(ctx context.Context, dbpool *pgxpool.Pool, name string, limit int) ([]ItemsSearchParam, error) {
	const sql = `
		SELECT 	i.name,
				p.value::double precision
		FROM proc p
                  LEFT JOIN tests t on p.id_test = t.id
                  LEFT JOIN items i on t.id = i.id
		WHERE i.name LIKE $1
		ORDER BY i.name asc
		LIMIT $2;`

	rows, err := dbpool.Query(ctx, sql, "%"+name+"%", limit)
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
		err = rows.Scan(&hint.Item, &hint.Value)
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
