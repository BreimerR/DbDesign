## Hierarchical database 

### Solutions
- Adjacent List tree


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
    
### Sample
- Structure
    - SQL
         ```mysql
          CREATE TABLE `table_name`(
              id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
              name VARCHAR(150) NOT NULL,
              parent_id INT DEFAULT NULL,
              FOREIGN KEY (parent_id) REFERENCES `table_name` (id) ON DELETE CASCADE ON UPDATE CASCADE
          );
         ```
    - Visualization
    <table>
        <thead>
            <tr>TableName</tr>
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