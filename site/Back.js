//Listens for csv file change
const input = document.querySelector('#file-input');
const output = document.querySelector('#output');
let data;

input.addEventListener('change', () => {
  output.innerHTML = ''; // clear the output element

  const file = input.files[0];

  if (file) {
    const reader = new FileReader();
    reader.readAsText(file);

    reader.onload = () => {
      try {
        const csvData = reader.result;
        data = Papa.parse(csvData).data;

        // get the unique values from the second column of the data array
        const values = data.map(row => row[1]);
        const uniqueValues = Array.from(new Set(values));

        // build an HTML table from the data
        const table = document.createElement('table');
        const thead = document.createElement('thead');
        const tbody = document.createElement('tbody');

        const headers = data[0];
        const rows = data.slice(1);

        // create a table header
        thead.innerHTML = `
        <tr>
            ${headers.map(header => `<th>${header}</th>`).join('')}
        </tr>
        `;

        // create the table rows
        tbody.innerHTML = rows.map(row => {
        return `
            <tr>
            ${row.map(cell => `<td>${cell}</td>`).join('')}
            </tr>
        `;
        }).join('');

        // append thead and tbody to the table and the table to the output element
        table.appendChild(thead);
        table.appendChild(tbody);
        output.appendChild(table);
        } catch (error) {
          output.innerHTML = `<p>Error: ${error.message}</p>`;
        }
      };
  
      reader.onerror = () => {
        output.innerHTML = '<p>Error: Failed to read file.</p>';
      };
    }
  });
  
  const select = document.querySelector('#filter-select');
  
  select.addEventListener('change', () => {
    const value = select.value;
    
    
    // update the table rows based on the selected value
    const rows = Array.from(document.querySelectorAll('tbody tr'));
    rows.forEach(row => {
      const sectionCell = row.querySelector('td:nth-child(2)');
      if ('All' !== value && sectionCell.textContent !== value) {
        row.style.display = 'none';
      } else {
        row.style.display = '';
      }
    });
  });
  
  


//listens for column change
const filterCol = document.querySelector('#filterCol-form');

filterCol.addEventListener('change', event => {
  event.preventDefault();

  // get the search query from the input element
  const input = document.querySelector('#search-input');
  const query = input.value.trim().toLowerCase();

  // search the tables for rows that match the query
  const tables = Array.from(document.querySelectorAll('table'));
  tables.forEach(table => {
    const rows = Array.from(table.querySelectorAll('tbody tr'));
    rows.forEach(row => {
      const cells = Array.from(row.querySelectorAll('td'));
      if (!cells.some(cell => cell.textContent.toLowerCase().includes(query))) {
        row.style.display = 'none';
      } else {
        row.style.display = '';
      }
    });
  });
});