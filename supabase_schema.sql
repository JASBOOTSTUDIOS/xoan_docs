-- Habilitar extensión para UUIDs
create extension if not exists "uuid-ossp";

-- 1. Tabla Perfiles (Profiles)
-- Se vincula automáticamente con auth.users
create table perfiles (
  id uuid references auth.users not null primary key,
  email text,
  rol text default 'estudiante' check (rol in ('estudiante', 'admin')),
  nombre_completo text,
  avatar_url text
);

-- Políticas RLS para Perfiles
alter table perfiles enable row level security;
create policy "Perfiles públicos para lectura" on perfiles for select using (true);
create policy "Usuarios pueden editar su propio perfil" on perfiles for update using (auth.uid() = id);

-- Trigger para crear perfil automáticamente al registrarse
create function public.handle_new_user()
returns trigger as $$
begin
  insert into public.perfiles (id, email, rol, nombre_completo)
  values (new.id, new.email, 'estudiante', new.raw_user_meta_data->>'nombre_completo');
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- 2. Tabla Cursos
create table cursos (
  id uuid default uuid_generate_v4() primary key,
  titulo text not null,
  descripcion text,
  precio numeric not null,
  url_imagen text,
  url_contenido text, -- Puede ser JSON o Link
  publicado boolean default false,
  creado_en timestamp with time zone default timezone('utc'::text, now())
);

-- Políticas RLS para Cursos
alter table cursos enable row level security;
create policy "Cursos publicados son visibles para todos" on cursos for select using (publicado = true);
create policy "Admins pueden ver todo" on cursos for select using (exists (select 1 from perfiles where id = auth.uid() and rol = 'admin'));
create policy "Solo Admins pueden editar cursos" on cursos for all using (exists (select 1 from perfiles where id = auth.uid() and rol = 'admin'));

-- 3. Tabla Pedidos (Orders)
create table pedidos (
  id uuid default uuid_generate_v4() primary key,
  usuario_id uuid references auth.users not null,
  curso_id uuid references cursos not null,
  monto numeric not null,
  metodo_pago text check (metodo_pago in ('transferencia', 'efectivo', 'tarjeta')),
  estado text default 'pendiente' check (estado in ('pendiente', 'pagado', 'rechazado')),
  url_comprobante text,
  creado_en timestamp with time zone default timezone('utc'::text, now())
);

-- Políticas RLS para Pedidos
alter table pedidos enable row level security;
create policy "Usuarios ven sus propios pedidos" on pedidos for select using (auth.uid() = usuario_id);
create policy "Usuarios crean sus pedidos" on pedidos for insert with check (auth.uid() = usuario_id);
create policy "Admins ven todos los pedidos" on pedidos for select using (exists (select 1 from perfiles where id = auth.uid() and rol = 'admin'));
create policy "Admins gestionan pedidos" on pedidos for update using (exists (select 1 from perfiles where id = auth.uid() and rol = 'admin'));

-- 4. Tabla Inscripciones (Enrollments)
create table inscripciones (
  usuario_id uuid references auth.users not null,
  curso_id uuid references cursos not null,
  fecha_inscripcion timestamp with time zone default timezone('utc'::text, now()),
  primary key (usuario_id, curso_id)
);

-- Políticas RLS para Inscripciones
alter table inscripciones enable row level security;
create policy "Usuarios ven sus inscripciones" on inscripciones for select using (auth.uid() = usuario_id);
create policy "Admins insertan inscripciones" on inscripciones for insert with check (exists (select 1 from perfiles where id = auth.uid() and rol = 'admin'));

-- 5. Storage Buckets (comandos SQL para crear buckets no siempre son estándar, hacer en interfaz)
-- insert into storage.buckets (id, name) values ('comprobantes_pago', 'comprobantes_pago');
-- insert into storage.buckets (id, name) values ('contenido_curso', 'contenido_curso');
