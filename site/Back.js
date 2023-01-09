/*Listens for csv file change */
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

        // update the options in the dropdown menu
        const select = document.querySelector('#filter-select');
        select.innerHTML = `
          <option value="All">Show all</option>
          ${generateOptions(data)}
        `;

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
  
  /* filter by section */
  function generateOptions(data) {
    // get the unique values from the second column of the data array
    const values = data.slice(1).map(row => row[1]);
    const uniqueValues = Array.from(new Set(values));
  
    // generate the option elements for the dropdown menu
    return uniqueValues.map(value => `<option value="${value}">${value}</option>`).join('');
  }

  
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
  
  //keyword search
  function searchRows(keywords) {
    // get all the rows in the table
    const rows = document.querySelectorAll('tbody tr');
  
    // search the rows for the keywords
    rows.forEach(row => {
      let match = false;
  
      // get the cells in the row
      const cells = row.querySelectorAll('td');
  
      // search the cells for the keywords
      cells.forEach(cell => {
        if (cell.textContent.toLowerCase().includes(keywords)) {
          match = true;
        }
      });
  
      // show or hide the row based on the search result
      if (match) {
        row.style.display = '';
      } else {
        row.style.display = 'none';
      }
    });
  }
  
const form = document.querySelector('#search-form');
form.addEventListener('input', event => {
  event.preventDefault();

  // get the search keywords
  const input = document.querySelector('#search-input');
  const keywords = input.value.toLowerCase();

    // search the rows
    searchRows(keywords);
});

/* Dark mode */
function toggleDarkMode() {
    const body = document.querySelector('body');
    const toggle = document.querySelector('#dark-mode-toggle');
  
    if (toggle.checked) {
      body.classList.add('dark-mode');
    } else {
      body.classList.remove('dark-mode');
    }
  }
  
const darkModeToggle = document.getElementById('dark-mode-toggle');

darkModeToggle.addEventListener('input', function() {
if (this.value === '0') {
    document.body.classList.remove('dark-mode');
} else {
    document.body.classList.add('dark-mode');
}
});
  

