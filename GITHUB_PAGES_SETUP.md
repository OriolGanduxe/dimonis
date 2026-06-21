# GitHub Pages Setup per Dimonis

Aquesta és la configuració necessària per deplojar Dimonis a GitHub Pages.

## Passos de Configuració

### 1. Crear el repositori GitHub

```bash
# 1. Crear repositori públic a GitHub amb el nom "dimonis"
# 2. No inicialitzar amb README (ja tenim el nostre)

# 3. Afegir el remote i fer push
git remote add origin https://github.com/OriolGanduxe/dimonis.git
git branch -M main
git push -u origin main
```

### 2. Configurar GitHub Pages

1. Anar a: Settings > Pages
2. Source: Deploy from a branch
3. Branch: `main` 
4. Folder: `/ (root)`
5. Save

### 3. Crear GitHub Action per Deployment Automàtic

Crear `.github/workflows/deploy-web.yml`:

```yaml
name: Deploy Web Build to GitHub Pages

on:
  push:
    branches: [ main ]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout
      uses: actions/checkout@v4
      
    - name: Setup Godot
      uses: chickensoft-games/setup-godot@v1
      with:
        version: 4.7.0
        use-dotnet: false
        
    - name: Import assets
      run: godot --headless --import
      
    - name: Build web export
      run: godot --headless --export-release "Web" exports/web/index.html
      
    - name: Upload Pages artifact
      uses: actions/upload-pages-artifact@v3
      with:
        path: exports/web/

  deploy:
    needs: build
    runs-on: ubuntu-latest
    
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
      
    steps:
    - name: Deploy to GitHub Pages
      id: deployment
      uses: actions/deploy-pages@v4
```

### 4. Actualitzar .gitignore per incloure build web

Modificar `.gitignore` per permetre el directori d'export:

```
# Godot-specific ignores
.godot/
*.tmp
.import/

# Exported builds (excepte web per GitHub Pages)
builds/
# !exports/web/  # Descomenta si vols committejar la build

# Export presets backup
export_presets.cfg.bak

# UIDs generats automàticament
*.uid
```

### 5. Headers per CORS (opcional)

Si hi ha problemes amb CORS, afegir `_headers` a `exports/web/`:

```
/*
  Cross-Origin-Embedder-Policy: require-corp
  Cross-Origin-Opener-Policy: same-origin
```

## Workflow de Desenvolupament

1. **Desenvolupament local:**
   ```bash
   # Obrir amb Godot
   ~/godot/Godot_v4.7-stable_linux.arm64 --path .
   
   # O export manual
   godot --headless --export-release "Web" exports/web/index.html
   ```

2. **Deploy automàtic:**
   ```bash
   git add .
   git commit -m "feat: nova funcionalitat"
   git push origin main
   # GitHub Action s'executa automàticament
   ```

3. **Testing web:**
   - URL: `https://oriolganduxe.github.io/dimonis/`
   - La build es pot provar localment amb un servidor HTTP simple:
     ```bash
     cd exports/web && python3 -m http.server 8000
     ```

## Estructura final esperada

```
dimonis/
├── .github/workflows/deploy-web.yml
├── exports/web/           # Build web (opcional committejar)
├── (resta del projecte...)
```

## Notes Importants

- **CORS**: Els builds web de Godot necessiten un servidor HTTP adequat
- **Threads**: La configuració actual usa `web_nothreads` per compatibilitat
- **Performance**: Primera càrrega pot ser lenta (39MB WASM)
- **Testing**: Sempre provar la build web abans del deploy
- **Cache**: GitHub Pages pot trigar uns minuts en actualitzar-se

## Troubleshooting

### Error "Cannot load .pck file"
- Verificar que tots els fitxers estan al mateix directori
- Comprovar que el servidor serveix fitxers .pck correctament

### Error CORS / SharedArrayBuffer
- Afegir headers CORS (veure secció 5)
- O usar export amb threads desactivats (ja configurat)

### Build massa gran
- Optimitzar assets (comprimir imatges, audio)
- Treure contingut de debug del release
- Considerar lazy loading per assets grans

---

**URL final del joc**: https://oriolganduxe.github.io/dimonis/

Per fer el primer deploy, executar els passos 1-3 i després fer push del codi.