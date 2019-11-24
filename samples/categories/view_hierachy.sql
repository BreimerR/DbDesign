CREATE VIEW categories_path AS
    WITH RECURSIVE procedure_name (id, name, path) AS
                       (
                           SELECT id, name, name as path
                           FROM `categories`
                           WHERE `parent_id` IS NULL
                           UNION ALL
                           SELECT cat.id, cat.name, CONCAT(cp.path, ' > ', cat.name)
                           FROM procedure_name AS cp
                                    JOIN categories AS cat
                                         ON cp.id = cat.parent_id
                       )
    SELECT *
    FROM procedure_name
    ORDER BY path;