import React, { useState, useEffect } from 'react';
import { useAuth } from '../contexts/AuthContext';
import { projectsApi } from '../services/api';
import type { Project } from '../types';
import { Button } from '../components/ui/Button';
import { Card } from '../components/ui/Card';

export const Projects: React.FC = () => {
  const { user, logout } = useAuth();
  const [projects, setProjects] = useState<Project[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    loadProjects();
  }, []);

  const loadProjects = async () => {
    setIsLoading(true);
    setError('');

    try {
      const data = user?.isAdmin
        ? await projectsApi.getAll()
        : await projectsApi.getMyProjects();
      setProjects(data);
    } catch (err: any) {
      setError(err.response?.data?.message || 'Errore durante il caricamento dei progetti');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-100">
      <nav className="bg-white shadow">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16 items-center">
            <div>
              <h1 className="text-xl font-bold">LeadOne2</h1>
            </div>
            <div className="flex items-center gap-4">
              <span className="text-sm text-gray-700">
                {user?.name} {user?.surname}
                {user?.isAdmin && ' (Admin)'}
              </span>
              <Button variant="secondary" onClick={logout}>
                Esci
              </Button>
            </div>
          </div>
        </div>
      </nav>

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-2xl font-bold">
            {user?.isAdmin ? 'Tutti i Progetti' : 'I Miei Progetti'}
          </h2>
          {user?.isAdmin && (
            <Button>Crea Nuovo Progetto</Button>
          )}
        </div>

        {error && (
          <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded mb-4">
            {error}
          </div>
        )}

        {isLoading ? (
          <div className="text-center py-12">
            <p className="text-gray-600">Caricamento progetti...</p>
          </div>
        ) : projects.length === 0 ? (
          <Card>
            <p className="text-center text-gray-600">Nessun progetto disponibile</p>
          </Card>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {projects.map((project) => (
              <Card key={project.id}>
                <h3 className="text-lg font-semibold mb-2">{project.name}</h3>
                <p className="text-gray-600 mb-4">{project.description}</p>
                <div className="flex justify-between items-center">
                  <span className={`text-sm ${project.isActive ? 'text-green-600' : 'text-gray-500'}`}>
                    {project.isActive ? 'Attivo' : 'Inattivo'}
                  </span>
                  <Button variant="secondary" className="text-sm">
                    Dettagli
                  </Button>
                </div>
              </Card>
            ))}
          </div>
        )}
      </main>
    </div>
  );
};
