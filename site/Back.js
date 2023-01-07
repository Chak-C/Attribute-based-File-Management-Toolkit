const input = document.querySelector('#file-input');
const output = document.querySelector('#output');
let data;

input.addEventListener('change', () => {
const file = input.files[0];

if (file) {
    const reader = new FileReader();
    reader.readAsText(file);

    reader.onload = () => {
    try {
        const csvData = reader.result;
        data = Papa.parse(csvData).data;

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
        output.innerHTML = '';
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