import 'package:flutter/material.dart';

import '../domain/entities/usuario.dart';
import '../domain/usecases/obtener_usuarios_con_vocal.dart';

class PantallaUsuarios extends StatefulWidget {
  const PantallaUsuarios({required this.obtenerUsuariosConVocal, super.key});

  final ObtenerUsuariosConVocal obtenerUsuariosConVocal;

  @override
  State<PantallaUsuarios> createState() => _PantallaUsuariosState();
}

class _PantallaUsuariosState extends State<PantallaUsuarios> {
  final TextEditingController _controladorBusqueda = TextEditingController();
  List<Usuario> _usuarios = const [];
  bool _cargando = true;
  String? _error;
  String _busqueda = '';

  List<Usuario> get _usuariosVisibles {
    final consulta = _busqueda.trim().toLowerCase();
    if (consulta.isEmpty) return _usuarios;

    return _usuarios
        .where((usuario) {
          return usuario.nombre.toLowerCase().contains(consulta) ||
              usuario.email.toLowerCase().contains(consulta);
        })
        .toList(growable: false);
  }

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  @override
  void dispose() {
    _controladorBusqueda.dispose();
    super.dispose();
  }

  Future<void> _cargarUsuarios() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final usuarios = await widget.obtenerUsuariosConVocal.ejecutar();
      if (!mounted) return;

      setState(() {
        _usuarios = usuarios;
        _cargando = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error.toString();
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleSpacing: 20,
        title: const Row(
          children: [
            Icon(Icons.people_alt_rounded),
            SizedBox(width: 10),
            Text('Vocales'),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: RefreshIndicator(
              onRefresh: _cargarUsuarios,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                children: [
                  _Encabezado(total: _usuarios.length),
                  const SizedBox(height: 20),
                  if (!_cargando && _error == null) ...[
                    TextField(
                      controller: _controladorBusqueda,
                      onChanged: (valor) => setState(() => _busqueda = valor),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Buscar por nombre o correo',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _busqueda.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Limpiar búsqueda',
                                onPressed: () {
                                  _controladorBusqueda.clear();
                                  FocusScope.of(context).unfocus();
                                  setState(() => _busqueda = '');
                                },
                                icon: const Icon(Icons.close_rounded),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (_cargando)
                    const _EstadoCargando()
                  else if (_error != null)
                    _EstadoError(
                      detalle: _error!,
                      alReintentar: _cargarUsuarios,
                    )
                  else if (_usuariosVisibles.isEmpty)
                    _EstadoVacio(hayBusqueda: _busqueda.isNotEmpty)
                  else ...[
                    Row(
                      children: [
                        Text(
                          _busqueda.isEmpty
                              ? 'Personas encontradas'
                              : 'Resultados de búsqueda',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: colores.secondaryContainer,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${_usuariosVisibles.length}',
                            style: TextStyle(
                              color: colores.onSecondaryContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    for (final usuario in _usuariosVisibles) ...[
                      _TarjetaUsuario(usuario: usuario),
                      const SizedBox(height: 10),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Encabezado extends StatelessWidget {
  const _Encabezado({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colores.primary, colores.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: colores.primary.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Directorio de usuarios',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  total == 0
                      ? 'Nombres que comienzan con A, E, I, O o U'
                      : '$total nombres comienzan con una vocal',
                  style: const TextStyle(color: Color(0xFFEAE7FF)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaUsuario extends StatelessWidget {
  const _TarjetaUsuario({required this.usuario});

  final Usuario usuario;

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    final inicial = usuario.nombre.trim().isEmpty
        ? '?'
        : usuario.nombre.trim()[0].toUpperCase();

    return Semantics(
      label: '${usuario.nombre}, ${usuario.email}',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: colores.primaryContainer,
                foregroundColor: colores.onPrimaryContainer,
                child: Text(
                  inicial,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      usuario.nombre,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.alternate_email_rounded,
                          size: 16,
                          color: colores.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            usuario.email,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: colores.onSurfaceVariant),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EstadoCargando extends StatelessWidget {
  const _EstadoCargando();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 72),
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 18),
          Text('Preparando el directorio...'),
        ],
      ),
    );
  }
}

class _EstadoError extends StatelessWidget {
  const _EstadoError({required this.detalle, required this.alReintentar});

  final String detalle;
  final VoidCallback alReintentar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          const Icon(Icons.cloud_off_rounded, size: 64),
          const SizedBox(height: 16),
          Text(
            'No pudimos cargar los usuarios',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(detalle, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: alReintentar,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Intentar de nuevo'),
          ),
        ],
      ),
    );
  }
}

class _EstadoVacio extends StatelessWidget {
  const _EstadoVacio({required this.hayBusqueda});

  final bool hayBusqueda;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 56),
      child: Column(
        children: [
          const Icon(Icons.person_search_rounded, size: 64),
          const SizedBox(height: 16),
          Text(
            hayBusqueda
                ? 'No hay coincidencias para tu búsqueda.'
                : 'No hay usuarios con nombres que empiecen con vocal.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
