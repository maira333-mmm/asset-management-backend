export default function Table({ columns, data, actions }) {
  return (
    <div className="overflow-x-auto">
      <table className="w-full text-sm">
        <thead>
          <tr className="bg-primary text-white">
            {columns.map((col) => (
              <th key={col.key} className="px-4 py-3 text-left uppercase tracking-wide text-xs">{col.label}</th>
            ))}
            {actions && <th className="px-4 py-3 text-left uppercase tracking-wide text-xs">Actions</th>}
          </tr>
        </thead>
        <tbody>
          {data.map((row, i) => (
            <tr key={i} className={i % 2 ? 'bg-gray-50' : 'bg-white'}>
              {columns.map((col) => (
                <td key={col.key} className="px-4 py-3">
                  {col.render ? col.render(row) : row[col.key]}
                </td>
              ))}
              {actions && <td className="px-4 py-3">{actions(row)}</td>}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}