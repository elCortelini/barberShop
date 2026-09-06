import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/barbershop_provider.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _customEmailController = TextEditingController();
  final TextEditingController _customNameController = TextEditingController();

  @override
  void dispose() {
    _customEmailController.dispose();
    _customNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarbershopProvider>(context);
    final currentUser = provider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Autenticação & Perfis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Header Logo Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.darkSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primaryGold, width: 1.5),
              ),
              child: Column(
                children: [
                  const Icon(Icons.account_circle_outlined,
                      color: AppTheme.primaryGold, size: 54),
                  const SizedBox(height: 12),
                  const Text(
                    'CONTA LOGADA ATUALMENTE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white54,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentUser.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    currentUser.email,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.primaryGold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGold.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.primaryGold),
                    ),
                    child: Text(
                      'PERFIL: ${currentUser.roleDisplayName}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Google Login Button
            const Text(
              'ENTRAR COM CONTA GOOGLE',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 14),

            ElevatedButton.icon(
              onPressed: () => _showGoogleLoginDialog(provider),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon(Icons.g_mobiledata, size: 28, color: Colors.blue),
              label: const Text(
                'CONTINUAR COM O GOOGLE',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 30),

            // Quick Role Switcher Buttons for Demo (4 Roles)
            const Text(
              'ATALHOS DE TESTE RÁPIDO DOS 4 NÍVEIS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white54,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 14),

            // 1. Super Admin Button
            _RoleTestTile(
              roleTitle: '1. Super Administrador (Super Usuário)',
              email: 'elcortelini@gmail.com',
              badgeColor: AppTheme.primaryGold,
              icon: Icons.shield,
              onTap: () {
                provider.loginWithGoogle(
                  email: 'elcortelini@gmail.com',
                  name: 'elcortelini (Super Admin)',
                );
                _notifyLogged(context, 'Super Administrador');
              },
            ),

            const SizedBox(height: 10),

            // 2. Store Owner / Manager Button
            _RoleTestTile(
              roleTitle: '2. Dono / Gerente de Loja',
              email: 'gerente.centro@estacaoelite.com',
              badgeColor: AppTheme.accentAmber,
              icon: Icons.store,
              onTap: () {
                provider.loginWithGoogle(
                  email: 'gerente.centro@estacaoelite.com',
                  name: 'Gerente da Matriz',
                );
                _notifyLogged(context, 'Gerente de Loja');
              },
            ),

            const SizedBox(height: 10),

            // 3. Barber Professional Button
            _RoleTestTile(
              roleTitle: '3. Profissional Barbeiro',
              email: 'carlos.barba@estacaoelite.com',
              badgeColor: AppTheme.successGreen,
              icon: Icons.content_cut,
              onTap: () {
                provider.loginWithGoogle(
                  email: 'carlos.barba@estacaoelite.com',
                  name: 'Carlos Barba Silva',
                );
                _notifyLogged(context, 'Profissional Barbeiro');
              },
            ),

            const SizedBox(height: 10),

            // 4. Client Button
            _RoleTestTile(
              roleTitle: '4. Cliente da Barbearia',
              email: 'cliente.marcos@gmail.com',
              badgeColor: AppTheme.infoBlue,
              icon: Icons.person,
              onTap: () {
                provider.loginWithGoogle(
                  email: 'cliente.marcos@gmail.com',
                  name: 'Marcos Cliente',
                );
                _notifyLogged(context, 'Cliente Elite');
              },
            ),

            const SizedBox(height: 36),

            // Footer Version Info
            const Text(
              'Estação Elite Barbearia • Versão: ${BarbershopProvider.currentVersion}',
              style: TextStyle(fontSize: 12, color: Colors.white38),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showGoogleLoginDialog(BarbershopProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: const Row(
          children: [
            Icon(Icons.g_mobiledata, color: Colors.blue, size: 30),
            SizedBox(width: 8),
            Text('Simular Google Sign-In',
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Informe um e-mail do Google para determinar as permissões automaticamente:',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _customNameController,
              decoration: const InputDecoration(labelText: 'Seu Nome Completo'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _customEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-mail do Google',
                hintText: 'ex: elcortelini@gmail.com',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_customEmailController.text.isNotEmpty) {
                provider.loginWithGoogle(
                  email: _customEmailController.text,
                  name: _customNameController.text.isNotEmpty
                      ? _customNameController.text
                      : null,
                );
                Navigator.pop(context);
                _notifyLogged(context, provider.currentUser.roleDisplayName);
              }
            },
            child: const Text('Entrar'),
          ),
        ],
      ),
    );
  }

  void _notifyLogged(BuildContext context, String roleName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.primaryGold,
        content: Text(
          'Logado com sucesso como $roleName!',
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
    widget.onLoginSuccess();
  }
}

class _RoleTestTile extends StatelessWidget {
  final String roleTitle;
  final String email;
  final Color badgeColor;
  final IconData icon;
  final VoidCallback onTap;

  const _RoleTestTile({
    required this.roleTitle,
    required this.email,
    required this.badgeColor,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: badgeColor.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: badgeColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roleTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 12,
                      color: badgeColor,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white38),
          ],
        ),
      ),
    );
  }
}
