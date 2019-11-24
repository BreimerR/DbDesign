## Hierarchical database 

### Solutions
- Adjacent list tree.


#### Adjacent List Tree
- This is where you want to achieve parent child relations for your dataset
    ``` 
    Parent > Child1 > GrandChild1 > GreatGrandCHild
    ```
      
- Use case
    - Categorical dataset
        ```
        Clothing & Fashion 
                            > Male
                                > Shoes
                            > Female
                                > Shoes
        ```
- Reads
    - [Adjacent list tree](http://www.mysqltutorial.org/mysql-adjacency-list-tree)
    
### SampleS


- Structure
    - Abstract SQL
        ```
        column = name column_name constraitns
        
        foreign_key = foreign_key_defn  
        
        CREATE TABLE table_name(
            column(,\n columns)*(,\n foreign_key(,\n foreign_key)*)?
        )
        ```
    - SQL
         ```mysql
          CREATE TABLE `table_name`(
              `id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
              `name` VARCHAR(150) NOT NULL,
              `parent_id` INT DEFAULT NULL,
              FOREIGN KEY (`parent_id`) REFERENCES `table_name` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
          );
         ```
    - Visualization
        <table>
            <thead>
                <tr>table_name</tr>
            </thead>
            <tr>
                <td>id</td>
                <td>name</td>
                <td>parent_id</td>
            </tr>
            <tr>
                <td>1</td>
                <td>col_value</td>
                <td>parent_id/NUll(for root nodes)</td>
            </tr>
        </table>
    
    - Example
            <table>
                <thead>
                    <tr>Categories</tr>
                </thead>
                <tr>
                    <td>id</td>
                    <td>name</td>
                    <td>parent_id</td>
                </tr>
                <tr>
                    <td>1</td>
                    <td>Electronics</td>
                    <td>NULL</td>
                </tr>
            </table>
            
- Querying
    <table>
        <thead>
            <tr>query_table</tr>
        </thead>
        <tr>
            <td>id</td>
            <td>title</td>
            <td>parent_id</td>
        </tr>
        <tr>
            <td>1</td>
            <td>Electronics</td>
            <td>NULL</td>
        </tr>
        <tr>
            <td>2</td>
            <td>Computers & Accessories</td>
            <td>1</td>
        </tr>
        <tr>
            <td>3</td>
            <td>Laptops</td>
            <td>2</td>
        </tr>
    </table>
    
    - Find all Root Nodes
        - SQL Abstract
            ```
                columns = \*|column_name(,column_name)*
                
                SELECT 
                    columns 
                FROM 
                    table_name
                WHERE 
                    parent_id IS NULL;      
            ```
            
        - SQL
            ```sql
                SELECT 
                   id,name 
                FROM 
                   categories
                WHERE
                   parent_id IS NULL; 
            ```
    - Select immediate children of a node
        - SQL abstract
            ```
                columns = \*|column_name(, columns_name)*
              
                SELECT 
                    columns
                FROM 
                    table_name 
                WHERE 
                    parent_id = node_id;
            ```
        - SQL 
            ```sql
                SELECT 
                    `id`,`name`
                FROM 
                    `categories`
                WHERE 
                    `parent_id` = 1  
            ```
    - Query whole tree
        - SQL abstract
            ```
                WITH RECURSIVE virtual_table_name (columns) AS
                (
                    SELECT columns
                        FROM table_name
                    WHERE parent_id IS NULL
                    UNION ALL
                        SELECT tn.id, tn.title, CONCAT(vtn.path, ' > ', tn.title)
                            FROM virtual_table_name AS vtn 
                            JOIN table_name AS tn
                            ON vtn.id = tn.parent_id
                )
                SELECT * FROM virtual_table_name
                ORDER BY path;
            ```
        - SQL
            ```sql
                WITH RECURSIVE categories_path (id,name,path) AS
                (
                  SELECT id,name, name as path
                    FROM categories
                    WHERE parent_id IS NULL
                  UNION ALL
                  SELECT c.id, c.name, CONCAT(cp.path, ' > ', c.name)
                    FROM categories_path AS cp JOIN categories AS c
                      ON cp.id = c.parent_id
                )
                SELECT * FROM categories_path
                ORDER BY path;
            ```
    - calculate node hierarchy level
        - SQL abstract
            ```
                default_value_null_parent_id = 0
                columns =  \*|column_name(,column_name)*
                WITH RECURSIVE category_path (columns) AS
                (
                    SELECT id, title, default_value_null_parent_id  lvl
                        FROM category
                    WHERE parent_id IS NULL
                    UNION ALL
                        SELECT c.id, c.title,cp.lvl + 1
                            FROM category_path AS cp 
                            JOIN category AS c
                            ON cp.id = c.parent_id
                )
                SELECT * FROM category_path
                ORDER BY lvl;
            ```
        - SQL abstract
        ```sql
            WITH RECURSIVE category_path (id, name, lvl) AS
            (
              SELECT id, name, 0 lvl
                FROM categories
                WHERE parent_id IS NULL
              UNION ALL
              SELECT c.id, c.name,cp.lvl + 1
                FROM category_path AS cp JOIN categories AS c
                  ON cp.id = c.parent_id
            )
            SELECT * FROM category_path
            ORDER BY lvl;
        ```
            