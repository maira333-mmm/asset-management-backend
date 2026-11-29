import { useDispatch } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { logout } from '../../features/auth/authSlice';
import Button from '../ui/Button';

export default function Topbar() {
  const dispatch = useDispatch();
  const navigate = useNavigate();

  const handleLogout = () => {
    dispatch(logout());
    navigate('/');
  };

  return (
    <header className="bg-white shadow px-6 py-4 flex justify-between items-center">
      <h2 className="text-lg font-semibold text-primary">Admin Panel</h2>
      <Button variant="secondary" onClick={handleLogout}>Logout</Button>
    </header>
  );
}