# Guida alla Configurazione di Neovim

## Indice

1. [Panoramica](#1-panoramica)
2. [Struttura delle Cartelle](#2-struttura-delle-cartelle)
3. [Impostazioni Generali](#3-impostazioni-generali)
4. [Funzionalità Principali](#4-funzionalità-principali)
5. [Riferimento Completo alle Scorciatoie (Keymap)](#5-riferimento-completo-alle-scorciatoie-keymap)
6. [Categorie dei Plugin](#6-categorie-dei-plugin)
7. [Supporto ai Linguaggi](#7-supporto-ai-linguaggi)
8. [Riferimento agli Snippet LaTeX](#8-riferimento-agli-snippet-latex)
9. [Guida Rapida](#9-guida-rapida)

---

### 1. Panoramica

Configurazione moderna per Neovim ottimizzata per Windows e Linux, focalizzata sulla scrittura in LaTeX, lo sviluppo in Python e l'editing generico di testo con:

- **Plugin Manager**: Lazy.nvim con caricamento pigro (lazy loading)
- **Tema**: OneDark (variante più calda)
- **Leader Key**: `;` (punto e virgola)
- **Casi d'Uso Principali**: Documenti LaTeX, codice Python, scrittura in Markdown, redazione di articoli accademici

**Integrazioni Principali:**
- SumatraPDF (Windows) / Zathura (Linux) per l'anteprima LaTeX
- GitHub Copilot come assistente IA
- FZF per la ricerca dei file
- LSP (Pyright, Texlab) per un editing intelligente
- Treesitter per l'evidenziazione avanzata della sintassi

---

### 2. Struttura delle Cartelle

Questa repository contiene tre cartelle di configurazione distinte per fornire un supporto su misura per tutti i sistemi operativi:
- `linux/`: Configurazione pensata per gli ambienti Linux (usa Zathura per la visualizzazione PDF, percorsi Unix, terminali bash/zsh).
- `windows/`: Configurazione pensata per gli ambienti Windows (usa SumatraPDF per la visualizzazione PDF, percorsi Windows).
- `macos/`: Configurazione pensata per gli ambienti macOS (usa Skim per la visualizzazione PDF, percorsi Unix, terminali bash/zsh).

> **Nota**: Tutte le configurazioni sono mantenute completamente identiche per quanto riguarda plugin, scorciatoie e funzionalità (incluse l'anteprima avanzata di Markdown, la sintassi Treesitter e il debug in Python). Le uniche differenze tra di esse riguardano i percorsi assoluti dei file e la configurazione del visualizzatore PDF.

---

### 3. Impostazioni Generali

```lua
vim.g.mapleader = ";"                    -- Leader key
vim.opt.number = true                    -- Mostra i numeri di riga
vim.opt.relativenumber = true            -- Numeri di riga relativi
vim.opt.cursorline = true                -- Evidenzia la riga corrente
vim.opt.clipboard = "unnamedplus"        -- Usa gli appunti di sistema
vim.opt.ignorecase = true                -- Ricerca non sensibile alle maiuscole/minuscole
vim.opt.smartcase = true                 -- Sensibile alle maiuscole solo se presenti
vim.opt.spell = false                    -- Controllo ortografico (Dizionario italiano di default)
vim.opt.spelllang = 'it'                 -- Dizionario italiano
vim.opt.selection = "inclusive"
vim.opt.virtualedit = "onemore"
```

**Stili del Cursore:**
- Normale/Visuale: Barra verticale sottile
- Inserimento: Barra verticale spessa  
- Sostituzione: Barra orizzontale

---

### 4. Funzionalità Principali

#### Dashboard (Alpha.nvim)
Art ASCII personalizzata con azioni rapide all'avvio di Neovim:
- `f` - Cerca file nella cartella di lavoro tramite FZF
- `r` - Cronologia dei file recenti
- `e` - Apri un nuovo buffer vuoto
- `c` - Apri la cartella di configurazione di Neovim
- `u` - Aggiorna i plugin tramite Lazy
- `q` - Esci da Neovim

#### Comportamento Intelligente del Tab
Il tasto Tab gestisce il contesto in modo intelligente:
1. Espansione/navigazione di UltiSnips.
2. Navigazione nel menu di autocompletamento.
3. Funzionalità classica del tasto tab.
*(Nota: GitHub Copilot usa `Alt-Spazio` al posto di Tab per evitare conflitti).*

#### Salvataggio Automatico per LaTeX
I file LaTeX (`*.tex`) vengono salvati automaticamente ogni 3 secondi di inattività, innescando un aggiornamento nel visualizzatore PDF senza interventi manuali.

#### Code Folding (Chiusura del Codice)
Sfrutta Treesitter e l'indentazione per un folding intelligente del codice (tramite `nvim-ufo`), permettendoti di comprimere in modo pulito funzioni e classi molto lunghe.

#### Anteprima Live Markdown
Rendering Markdown integrato direttamente nell'editor, unito al supporto per l'anteprima in tempo reale via browser.

---

### 5. Riferimento Completo alle Scorciatoie (Keymap)

#### Azioni dalla Dashboard
| Tasto | Azione | Descrizione |
|-------|--------|-------------|
| `f`   | Find Files | Ricerca FZF nella cartella di lavoro |
| `r`   | Recent Files | Cronologia file tramite FZF |
| `e`   | New File | Crea un nuovo buffer |
| `c`   | Config | Apri la cartella config tramite FZF |
| `u`   | Update | Sincronizza i plugin tramite Lazy |
| `q`   | Quit | Esci da Neovim |

#### Navigazione & Finestre
| Tasto | Modalità | Azione | Descrizione |
|-------|----------|--------|-------------|
| `<Tab>` | Normale | Navigazione Finestre | Passa allo split successivo |
| `<S-Tab>`| Normale | Navigazione Finestre | Passa allo split precedente |
| `<C-n>` | Normale | File Tree | Attiva/disattiva nvim-tree nella cartella di lavoro |
| `<C-k>` | Normale | Outline | Attiva/disattiva la struttura del documento |

#### Modifica del Testo (Modalità Visuale)
Queste scorciatoie si applicano al testo attualmente selezionato senza perdere la selezione visiva.
| Tasto | Modalità | Azione | Descrizione |
|-------|----------|--------|-------------|
| `<Tab>` | Visuale | Indenta | Aumenta l'indentazione, mantieni la selezione |
| `<S-Tab>` | Visuale | De-indenta | Riduci l'indentazione, mantieni la selezione |
| `'` | Visuale | Apici Singoli | Racchiudi la selezione in apici singoli `'testo'` |
| `"` | Visuale | Virgolette | Racchiudi la selezione in doppie virgolette `"testo"` |
| `$` | Visuale | Modalità Matematica | Racchiudi la selezione nei dollari LaTeX `$testo$` |
| `(` | Visuale | Parentesi Tonde | Racchiudi la selezione in parentesi tonde `(testo)` |
| `[` | Visuale | Parentesi Quadre | Racchiudi la selezione in parentesi quadre `[testo]` |
| `{` | Visuale | Parentesi Graffe | Racchiudi la selezione in parentesi graffe `{testo}` |

#### Specifiche per LaTeX
| Tasto | Modalità | Azione | Descrizione |
|-------|----------|--------|-------------|
| `<M-b>` | Visuale | Grassetto | Racchiudi la selezione in `\textbf{}` |
| `<M-i>` | Visuale | Corsivo | Racchiudi la selezione in `\textit{}` |
| `<C-o>` | Normale | Compila | Salva e innesca la compilazione con VimTeX |
| `<C-l>` | Inserimento| Correzione Ortografica | Correggi in automatico la precedente parola errata |

#### Esecuzione del Codice & Debugging
| Tasto | Modalità | Azione | Descrizione |
|-------|----------|--------|-------------|
| `<Leader>r` | Normale | Esegui Python | Salva ed esegui lo script python in un terminale split a destra |

#### Markdown
| Tasto | Modalità | Azione | Descrizione |
|-------|----------|--------|-------------|
| `<Leader>mp`| Normale | Toggle Anteprima | Attiva/disattiva l'anteprima live nel browser web |

#### Code Folding
| Tasto | Modalità | Azione | Descrizione |
|-------|----------|--------|-------------|
| `zR` | Normale | Apri Tutti | Espandi tutte le pieghe nel documento |
| `zM` | Normale | Chiudi Tutti | Comprimi tutte le pieghe nel documento |
| `za` | Normale | Alterna | Alterna la piega sotto il cursore |
| `zo` | Normale | Apri | Espandi la piega sotto il cursore |
| `zc` | Normale | Chiudi | Comprimi la piega sotto il cursore |

#### Autocompletamento & Snippets
| Tasto | Modalità | Azione | Descrizione |
|-------|----------|--------|-------------|
| `<M-Space>`| Inserimento | Copilot | Accetta il suggerimento di GitHub Copilot |
| `<Tab>` | Inserimento | Snippets | Espandi lo snippet o salta al campo successivo |
| `<S-Tab>` | Inserimento | Precedente | Salta al campo precedente dello snippet |
| `<CR>` | Inserimento | Conferma | Conferma l'autocompletamento (senza selezionare in automatico il primo) |
| `<C-j>` | Inserimento | Prossimo | Passa alla voce successiva nell'autocompletamento |
| `<Up>`/`<Down>` | Inserimento | Naviga | Naviga tra le opzioni dell'autocompletamento |

---

### 6. Categorie dei Plugin

#### Interfaccia Utente & Estetica
- **alpha-nvim**: Dashboard personalizzata con ASCII art e scorciatoie.
- **onedark.nvim**: Tema (variante calda).
- **lualine.nvim**: Barra di stato con branch git, diagnostica e informazioni sul file.
- **indent-blankline.nvim**: Guide per l'indentazione colorate in stile arcobaleno per abbinare facilmente i livelli.

#### Gestione File & Navigazione
- **nvim-tree.lua**: Barra laterale dell'esploratore file (`Ctrl-N`).
- **fzf + fzf.vim**: Ricerca fuzzy incredibilmente veloce per file e buffer.
- **outline.nvim**: Albero della struttura del documento (`Ctrl-K`).

#### Editing del Codice & Evidenziazione
- **nvim-treesitter**: Evidenziazione avanzata della sintassi e parsing del codice per un folding accurato.
- **nvim-autopairs**: Chiusura automatica di parentesi, virgolette e apici.
- **nvim-ufo**: Folding intelligente e ultraveloce.
- **copilot.vim**: Suggerimenti di codice potenziati dall'IA.

#### Sistema di Autocompletamento
- **nvim-cmp**: Motore di completamento altamente personalizzabile.
- **UltiSnips**: Sistema di gestione degli snippet.
- Fonti: LSP, parole del buffer, percorsi dei file e cronologia della command line.

#### Utilità
- **render-markdown.nvim**: Rendering markdown all'interno dell'editor per intestazioni, elenchi, blocchi di codice.
- **markdown-preview.nvim**: Anteprima in tempo reale basata su browser per file markdown.

---

### 7. Supporto ai Linguaggi

#### LaTeX (VimTeX + Texlab LSP)
**Requisiti di Installazione:**
- Distribuzione LaTeX (TeX Live / MiKTeX)
- **Linux:** Visualizzatore PDF Zathura
- **Windows:** Visualizzatore PDF SumatraPDF
- **macOS:** Visualizzatore PDF Skim
- Texlab LSP: installato tramite script automatici (`cargo` / `brew` / `winget`)

**Funzionalità:**
- Salvataggio e compilazione automatici via `latexmk`.
- Anteprima PDF con SyncTeX automatico (ricerca diretta e inversa).
- Colori di evidenziazione personalizzati per i delimitatori matematici (`$`, `\[`, `\]`).
- Integrazione nativa e profonda degli snippet tramite UltiSnips.

#### Python (Pyright LSP + Black + DAP)
**Requisiti di Installazione:**
- Python 3.x
- Pyright: `npm install -g pyright`
- Formattatore Black: `pip install black`

**Funzionalità:**
- Controllo statico dei tipi e autocompletamento via Pyright.
- Auto-formattazione al salvataggio tramite `conform.nvim` usando Black.
- Esecuzione di script in terminale split usando `<Leader>r`.
- Supporto DAP (Debug Adapter Protocol) tramite `nvim-dap` e `nvim-dap-python` per debug passo-passo.

#### Linguaggi Aggiuntivi
- **Markdown**: Anteprima completa e rendering interno all'editor.
- **JavaScript/HTML/CSS**: Supporto LSP base e sintassi Treesitter.
- **Lua**: Supporto dedicato per modificare le configurazioni di Neovim.

---

### 8. Riferimento agli Snippet LaTeX

La configurazione include una ricca libreria di snippet LaTeX personalizzati (`UltiSnips/tex.snippets`). Molti snippet usano l'**Espansione Automatica** (scattano istantaneamente senza premere `<Tab>`). Gli snippet marcati come **Contesto Matematico** si attivano solo all'interno di un ambiente matematico (es. `$ ... $` o `\begin{equation}`).

#### Ambienti & Struttura del Documento
| Trigger | Azione | Contesto |
|---------|--------|---------|
| `template` | Template base per un documento LaTeX | Qualsiasi |
| `beg` | Blocco `\begin{...} \end{...}` | Qualsiasi |
| `table` | Ambiente table | Qualsiasi |
| `fig` | Ambiente figure | Qualsiasi |
| `enum` | Ambiente enumerate | Qualsiasi |
| `item` | Ambiente itemize | Qualsiasi |
| `desc` | Ambiente description | Qualsiasi |
| `pac` | `\usepackage{}` | Qualsiasi |
| `case` | `\begin{cases}` | Qualsiasi |
| `ali` | `\begin{align*}` | Qualsiasi |
| `bigfun` | Mappatura funzione estesa (`\begin{align*}`) | Qualsiasi |
| `SI` | `\SI{value}{unit}` | Qualsiasi |
| `letw` | "Let $\Omega \subset \mathbb{C}$ be open." | Qualsiasi |

#### Attivatori Modalità Matematica
| Trigger | Azione |
|---------|--------|
| `mk` | Matematica inline (`$ ... $`) |
| `dm` | Matematica display (`\[ ... \]` o `$$`) |

#### Simboli & Costanti
| Trigger | Azione | Contesto |
|---------|--------|---------|
| `ooo` | `\infty` | Matematica |
| `eps` | `\varepsilon` | Matematica |
| `lll` | `\ell` | Matematica |
| `nabl` | `\nabla` | Matematica |
| `**` | `\cdot` | Matematica |
| `xx` | `\times` | Matematica |

#### Testo in Modalità Matematica & Font
| Trigger | Azione | Contesto |
|---------|--------|---------|
| `txt` | `\text{...}` | Qualsiasi |
| `sts` | `_\text{...}` (Testo a pedice) | Qualsiasi |
| `mcal` | `\mathcal{...}` | Matematica |
| `bf` | `\textbf{...}` | Matematica |

#### Frazioni Automatiche, Potenze & Pedici
| Trigger | Azione | Contesto |
|---------|--------|---------|
| `//` | `\frac{...}{...}` | Matematica |
| `x/` | Converte `x/` in `\frac{x}{...}` | Matematica |
| `(x+y)/` | Converte `(x+y)/` in `\frac{x+y}{...}` | Matematica |
| `x1` | Converte in `x_1` (qualsiasi lettera + cifra) | Qualsiasi |
| `x_12` | Converte in `x_{12}` | Qualsiasi |
| `__` | Pedice `_{...}` | Matematica |
| `td` | Apice `^{...}` | Matematica |
| `sr` | Al quadrato `^2` | Matematica |
| `cb` | Al cubo `^3` | Matematica |
| `invs` | Inverso `^{-1}` | Matematica |
| `cmpl` | Complemento `^{c}` | Matematica |
| `xnn` | `x_n` (anche `ynn`, `xii`, `yii`, `xjj`, `yjj`, `xmm`) | Matematica |
| `xp1` | `x_{n+1}` | Matematica |

#### Logica & Relazioni
| Trigger | Azione | Contesto |
|---------|--------|---------|
| `=>`, `=<` | `\implies`, `\impliedby` | Matematica |
| `iff` | `\iff` | Matematica |
| `==` | `&= ... \\` (Uguale allineato) | Matematica |
| `!=` | `\neq` | Matematica |
| `<=`, `>=` | `\le`, `\ge` | Matematica |
| `>>`, `<<` | `\gg`, `\ll` | Matematica |
| `~~` | `\sim` | Matematica |
| `->`, `!>` | `\to`, `\mapsto` | Matematica |
| `<->` | `\leftrightarrow` | Matematica |
| `<!` | `\triangleleft` | Matematica |
| `<>` | `\diamond` | Matematica |

#### Insiemi & Operatori
| Trigger | Azione | Contesto |
|---------|--------|---------|
| `set` | `\{ ... \}` | Matematica |
| `inn`, `notin` | `\in`, `\not\in` | Matematica |
| `sbst` | `\subset` | Matematica |
| `Nn`, `UU` | `\cap`, `\cup` | Matematica |
| `nnn`, `uuu`| `\bigcap`, `\bigcup` | Matematica |
| `OO` | `\emptyset` | Matematica |
| `\\\` | `\setminus` | Matematica |
| `NN`, `RR`, `QQ`, `ZZ`, `DD`, `HH` | Blackboard bold `\mathbb{X}` | Matematica |
| `R0+` | `\mathbb{R}_0^+` | Matematica |
| `EE`, `AA`, `PP`, `Ee` | `\exists`, `\forall`, `\mathbb{P}`, `\mathbb{E}` | Matematica |

#### Calcolo, Limiti & Integrali
| Trigger | Azione | Contesto |
|---------|--------|---------|
| `sum` | `\sum_{...}^{...}` | Matematica |
| `prod` | `\prod_{...}^{...}` | Matematica |
| `lim`, `limsup`| `\lim_{n \to \infty}`, `\limsup` | Matematica |
| `int` | `\int_{...}^{...}` | Matematica |
| `part` | `\frac{\partial ...}{\partial ...}` | Matematica |
| `taylor` | Sviluppo in serie di Taylor | Matematica |
| `sqrt` | `\sqrt{...}` | Matematica |

#### Parentesi & Delimitatori (Auto-espandibili)
| Trigger | Azione | Contesto |
|---------|--------|---------|
| `()`, `[]`, `{}` | `\left( \right)`, `\left[ \right]`, `\left\{ \right\}` | Matematica |
| `||` | `\left\| \right\|` | Matematica |
| `lra` | `\left< \right>` | Matematica |
| `ceil`, `floor`| `\left\lceil \right\rceil`, `\left\lfloor \right\rfloor`| Qualsiasi |
| `norm` | `\| ... \|` | Matematica |
| `conj` | `\overline{...}` | Matematica |
| `bar`, `hat` | `\bar{...}`, `\hat{...}` (Auto-applicato al carattere precedente) | Matematica |

#### Matrici & Vettori
| Trigger | Azione | Contesto |
|---------|--------|---------|
| `pmat`, `bmat` | `\begin{pmatrix}`, `\begin{bmatrix}` | Matematica |
| `cvec` | Vettore colonna con `\vdots` | Matematica |
| `rij` | `(x_n)_{n \in \mathbb{N}}` | Matematica |

#### Attivatori Automatici per Funzioni Matematiche
Quando sei in **modalità matematica**, digitare uno di questi seguiti da uno spazio o da un carattere non alfabetico li convertirà automaticamente aggiungendo un backslash (es. digitando `sin` diventerà automaticamente `\sin`):  
`sin`, `cos`, `arccot`, `cot`, `csc`, `ln`, `log`, `exp`, `star`, `perp`, `arcsin`, `arccos`, `arctan`, `pi`, `zeta`, `delta`, `kappa`, `lambda`, `mu`, `nu`, `rho`, `sigma`, `tau`, `omega`.

#### Grafici & Calcolo Esterno
| Trigger | Azione | Contesto |
|---------|--------|---------|
| `plot` | Blocco assi 2D TikZ/PGFPlots | Qualsiasi |
| `surf` | Blocco superficie 3D TikZ/PGFPlots | Qualsiasi |
| `node` | Nodo TikZ | Qualsiasi |
| `sympy` | Valuta l'espressione matematica usando SymPy | Qualsiasi |
| `math` | Valuta l'espressione matematica usando WolframScript | Qualsiasi |

---

### 9. Guida Rapida

#### Installazione
Sono forniti degli script di installazione automatica per tutti i principali sistemi operativi. Installeranno Neovim, Git, Node.js, Python, le distribuzioni LaTeX, i visualizzatori PDF e tutte le dipendenze necessarie, oltre al font **RobotoMono Nerd Font**.
- **Windows:** Fai doppio clic su `install_windows.bat` per avviare l'installazione. Assicurati di avere `winget` installato (nella maggior parte dei casi è già preinstallato su Windows 10 e 11).
- **macOS:** Apri un terminale ed esegui `bash install_macos.sh`. Utilizza Homebrew sotto il cofano.
- **Linux:** Apri un terminale ed esegui `bash install_linux.sh`. Rileva e supporta automaticamente sia `apt` (Ubuntu/Debian) che `pacman` (Arch Linux).

Lo script copia automaticamente i file di configurazione nella cartella corretta di Neovim (`~/.config/nvim/` su Linux/macOS, `%USERPROFILE%\AppData\Local\nvim\` su Windows). Non è necessaria alcuna copia manuale.

#### Primo Avvio
1. Apri Neovim → Apparirà la Dashboard personalizzata.
2. Premi `f` per cercare file usando FZF, oppure `e` per iniziare un nuovo file vuoto.
3. Usa `Ctrl-N` per attivare la barra laterale dei file, `Ctrl-K` per vedere la struttura del documento in corso.

#### Workflow con LaTeX
1. Crea un file `.tex`.
2. Scrivi il contenuto. Il file si salva automaticamente ogni 3 secondi.
3. Usa `Ctrl-O` per forzare una compilazione se necessario.
4. Il visualizzatore PDF configurato (Zathura/Sumatra/Skim) si aprirà e si sincronizzerà con la posizione del tuo cursore.
5. Evidenzia il testo in Modalità Visuale e usa `Alt-B` / `Alt-I` per formattarlo in grassetto/corsivo, o `$` per la modalità matematica.

#### Sviluppo in Python
1. Crea un file `.py`.
2. Scrivi codice con il Pyright LSP che fornisce controllo e autocompletamento in tempo reale.
3. Salva il file: Black formatterà automaticamente il tuo codice secondo gli standard PEP-8.
4. Premi `;r` (Leader + r) per eseguire lo script in un terminale laterale integrato.

#### Editing Generico
1. `<Alt-Spazio>` per accettare i suggerimenti di Copilot.
2. `Tab` per espandere gli snippet e muoversi tra i loro segnaposto.
3. In modalità Visuale, racchiudi i testi istantaneamente selezionandoli e premendo `"`, `'`, `(`, `[` o `{`.
4. Salta tra gli split delle finestre usando `<Tab>` e `<Shift-Tab>`.

#### Gestione dei Plugin
- Digita `:Lazy` per aprire l'interfaccia del plugin manager.
- Digita `:Lazy sync` per aggiornare e sincronizzare tutti i plugin installati.
- Digita `:checkhealth` per visualizzare le informazioni diagnostiche di Neovim e verificare l'installazione degli strumenti.

#### Personalizzazione
A seconda del tuo sistema operativo, modifica la configurazione nella rispettiva cartella:
- **Linux:** `linux/init.lua`
- **Windows:** `windows/init.lua` (spesso collegato a `C:/Users/Lorenzo/AppData/Local/nvim/init.lua`)
- **macOS:** `macos/init.lua`

**Modifiche Comuni:**
- Cambiare il leader key: `lua/config/options.lua` -> `vim.g.mapleader`
- Aggiungere nuove scorciatoie: `lua/config/keymaps.lua`
- Modificare il tema o la dashboard: `lua/plugins/ui.lua`
- Aggiungere un nuovo linguaggio: `lua/plugins/languages/`

---

### Disclaimer sui Plugin di Terze Parti

La licenza MIT inclusa in questa repository si applica **esclusivamente ai file di configurazione e agli script** scritti qui (ad es., `init.lua`, impostazioni dei plugin, scorciatoie, script di installazione, snippet, ecc.).

Tutti i plugin di terze parti referenziati tramite il plugin manager (ad es., `lazy.nvim`, `vimtex`, `nvim-cmp`, ecc.) sono sviluppati e mantenuti dai rispettivi autori, e **non sono inclusi** in questa repository né tantomeno coperti da questa licenza. Si prega di fare riferimento alla repository originale e alla licenza specifica di ogni plugin per i relativi termini di utilizzo.
