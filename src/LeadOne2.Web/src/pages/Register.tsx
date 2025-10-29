import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import { Button } from '../components/ui/Button';
import { Input } from '../components/ui/Input';
import { Card } from '../components/ui/Card';

export const Register: React.FC = () => {
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    name: '',
    surname: '',
  });
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const { register } = useAuth();
  const navigate = useNavigate();

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setIsLoading(true);

    try {
      await register(formData);
      navigate('/projects');
    } catch (err: any) {
      setError(err.response?.data?.message || 'Errore durante la registrazione');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-100">
      <Card className="w-full max-w-md">
        <h1 className="text-2xl font-bold text-center mb-6">LeadOne2</h1>
        <h2 className="text-xl font-semibold text-center mb-6">Registrati</h2>

        <form onSubmit={handleSubmit} className="space-y-4">
          <Input
            type="text"
            name="name"
            label="Nome"
            value={formData.name}
            onChange={handleChange}
            required
            placeholder="Mario"
          />

          <Input
            type="text"
            name="surname"
            label="Cognome"
            value={formData.surname}
            onChange={handleChange}
            required
            placeholder="Rossi"
          />

          <Input
            type="email"
            name="email"
            label="Email"
            value={formData.email}
            onChange={handleChange}
            required
            placeholder="email@esempio.it"
          />

          <Input
            type="password"
            name="password"
            label="Password"
            value={formData.password}
            onChange={handleChange}
            required
            placeholder="Minimo 8 caratteri"
          />

          {error && (
            <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded">
              {error}
            </div>
          )}

          <Button type="submit" isLoading={isLoading} className="w-full">
            Registrati
          </Button>

          <p className="text-center text-sm text-gray-600">
            Hai già un account?{' '}
            <a href="/login" className="text-blue-600 hover:underline">
              Accedi
            </a>
          </p>
        </form>
      </Card>
    </div>
  );
};
