class _SwimmerListPageState extends State<SwimmerListPage> {
  final SyncService _syncService = SyncService();
  List<Swimmer> _swimmers = [];
  StreamSubscription? _swimmersSubscription;

  @override
  void initState() {
    super.initState();
    _setupSync();
  }

  void _setupSync() {
    // Écouter les changements en temps réel
    _swimmersSubscription = _syncService.getSwimmersStream().listen((swimmers) {
      setState(() {
        _swimmers = swimmers;
      });
    });
  }

  void _addSwimmer(Swimmer swimmer) {
    // Sauvegarde locale immédiate
    setState(() {
      _swimmers.add(swimmer);
    });
    
    // Synchronisation automatique
    _syncService.autoSyncSwimmer(swimmer);
  }

  void _manualSync() async {
    try {
      setState(() {
        // Afficher un indicateur de chargement
      });
      
      await _syncService.manualSyncAllData();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Synchronisation réussie')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Erreur de synchronisation: $e')),
      );
    } finally {
      setState(() {
        // Cacher l'indicateur de chargement
      });
    }
  }

  @override
  void dispose() {
    _swimmersSubscription?.cancel();
    super.dispose();
  }
}
