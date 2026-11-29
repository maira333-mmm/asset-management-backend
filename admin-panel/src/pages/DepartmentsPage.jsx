import { useState } from 'react';
import {
  useGetDepartmentsQuery,
  useCreateDepartmentMutation,
  useDeleteDepartmentMutation,
} from '../features/departments/departmentsApi';
import Card from '../components/ui/Card';
import Input from '../components/ui/Input';
import Button from '../components/ui/Button';
import Table from '../components/ui/Table';

export default function DepartmentsPage() {
  const { data: departments = [], isLoading } = useGetDepartmentsQuery();
  const [createDepartment] = useCreateDepartmentMutation();
  const [deleteDepartment] = useDeleteDepartmentMutation();
  const [name, setName] = useState('');

  const handleAdd = async (e) => {
    e.preventDefault();
    await createDepartment({ department_name: name });
    setName('');
  };

  const columns = [{ key: 'department_name', label: 'Name' }];

  return (
    <div>
      <h1 className="text-2xl font-bold mb-6" style={{ color: 'var(--primary-color)' }}>Departments</h1>
      <Card className="mb-6">
        <form onSubmit={handleAdd} className="flex gap-3 items-end">
          <Input label="Department Name" value={name} onChange={(e) => setName(e.target.value)} required />
          <Button type="submit" className="mb-3">Add</Button>
        </form>
      </Card>
      <Card>
        {isLoading ? (
          <p>Loading...</p>
        ) : (
          <Table
            columns={columns}
            data={departments}
            actions={(row) => (
              <button 
                onClick={() => deleteDepartment(row.department_id)}
                className="text-white px-3 py-1.5 rounded text-sm font-semibold transition-all hover:opacity-90"
                style={{ backgroundColor: 'var(--primary-color)' }}
              >
                Delete
              </button>
            )}
          />
        )}
      </Card>
    </div>
  );
}