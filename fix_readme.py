import re

with open('README.md', 'r', encoding='utf-8') as f:
    content = f.read()

new_snippets = """### 8. LaTeX Snippets Reference

The configuration includes a rich library of custom LaTeX snippets (`UltiSnips/tex.snippets`). Many snippets use **Auto-expand** (they trigger instantly without pressing `<Tab>`). Snippets marked with **Math Context** only trigger when inside a math environment (e.g., `$ ... $` or `\begin{equation}`).

#### Environments & Document Structure
| Trigger | Action | Auto | Context |
|---------|--------|------|---------|
| `template` | Basic LaTeX document template | No | Any |
| `beg` | `\begin{...} \end{...}` block | **Yes** | Any |
| `table` | Table environment | No | Any |
| `fig` | Figure environment | No | Any |
| `enum` | Enumerate environment | **Yes** | Any |
| `item` | Itemize environment | **Yes** | Any |
| `desc` | Description environment | No | Any |
| `pac` | `\usepackage{}` | No | Any |
| `case` | `\begin{cases}` | **Yes** | Any |
| `ali` | `\begin{align*}` | **Yes** | Any |
| `bigfun` | Big function map (`\begin{align*}`) | **Yes**| Any |
| `SI` | `\SI{value}{unit}` | **Yes**| Any |
| `letw` | "Let $\Omega \subset \mathbb{C}$ be open." | **Yes**| Any |

#### Math Mode Toggles
| Trigger | Action | Auto |
|---------|--------|------|
| `mk` | Inline math (`$ ... $`) | **Yes** |
| `dm` | Display math (`\[ ... \]` or `$$`) | **Yes** |

#### Symbols & Constants
| Trigger | Action | Auto | Context |
|---------|--------|------|---------|
| `ooo` | `\infty` | **Yes** | Math |
| `eps` | `\varepsilon` | **Yes** | Math |
| `lll` | `\ell` | **Yes** | Math |
| `nabl` | `\nabla` | **Yes** | Math |
| `**` | `\cdot` | **Yes** | Math |
| `xx` | `\times` | **Yes** | Math |

#### Math Text & Fonts
| Trigger | Action | Auto | Context |
|---------|--------|------|---------|
| `txt` | `\text{...}` | **Yes** | Any |
| `sts` | `_\text{...}` (Text subscript) | **Yes** | Any |
| `mcal` | `\mathcal{...}` | **Yes** | Math |
| `bf` | `\textbf{...}` | **Yes** | Math |

#### Automatic Fractions, Powers & Subscripts
| Trigger | Action | Auto | Context |
|---------|--------|------|---------|
| `//` | `\frac{...}{...}` | **Yes** | Math |
| `x/` | Converts `x/` to `\frac{x}{...}` | **Yes** | Math |
| `(x+y)/` | Converts `(x+y)/` to `\frac{x+y}{...}` | **Yes** | Math |
| `x1` | Converts to `x_1` (any letter + digit) | **Yes** | Any |
| `x_12` | Converts to `x_{12}` | **Yes** | Any |
| `__` | Subscript `_{...}` | **Yes** | Math |
| `td` | Superscript `^{...}` | **Yes** | Math |
| `sr` | Squared `^2` | **Yes** | Math |
| `cb` | Cubed `^3` | **Yes** | Math |
| `invs` | Inverse `^{-1}` | **Yes** | Math |
| `cmpl` | Complement `^{c}` | **Yes** | Math |
| `xnn` | `x_n` (also `ynn`, `xii`, `yii`, `xjj`, `yjj`, `xmm`) | **Yes** | Math |
| `xp1` | `x_{n+1}` | **Yes** | Math |

#### Logic & Relations
| Trigger | Action | Auto | Context |
|---------|--------|------|---------|
| `=>`, `=<` | `\implies`, `\impliedby` | **Yes** | Math |
| `iff` | `\iff` | **Yes** | Math |
| `==` | `&= ... \\` (Align equals) | **Yes** | Math |
| `!=` | `\neq` | **Yes** | Math |
| `<=`, `>=` | `\le`, `\ge` | **Yes** | Math |
| `>>`, `<<` | `\gg`, `\ll` | **Yes** | Math |
| `~~` | `\sim` | **Yes** | Math |
| `->`, `!>` | `\to`, `\mapsto` | **Yes** | Math |
| `<->` | `\leftrightarrow` | **Yes** | Math |
| `<!` | `\triangleleft` | **Yes** | Math |
| `<>` | `\diamond` | **Yes** | Math |

#### Sets & Operators
| Trigger | Action | Auto | Context |
|---------|--------|------|---------|
| `set` | `\{ ... \}` | **Yes** | Math |
| `inn`, `notin` | `\in`, `\not\in` | **Yes** | Math |
| `sbst` | `\subset` | **Yes** | Math |
| `Nn`, `UU` | `\cap`, `\cup` | **Yes** | Math |
| `nnn`, `uuu`| `\bigcap`, `\bigcup` | **Yes** | Math |
| `OO` | `\emptyset` | **Yes** | Math |
| `\\\` | `\setminus` | **Yes** | Math |
| `NN`, `RR`, `QQ`, `ZZ`, `DD`, `HH` | Blackboard bold `\mathbb{X}` | **Yes** | Math |
| `R0+` | `\mathbb{R}_0^+` | **Yes** | Math |
| `EE`, `AA`, `PP`, `Ee` | `\exists`, `\forall`, `\mathbb{P}`, `\mathbb{E}` | **Yes** | Math |

#### Calculus, Limits & Integrals
| Trigger | Action | Auto | Context |
|---------|--------|------|---------|
| `sum` | `\sum_{...}^{...}` | No | Math |
| `prod` | `\prod_{...}^{...}` | No | Math |
| `lim`, `limsup`| `\lim_{n \to \infty}`, `\limsup` | No | Math |
| `int` | `\int_{...}^{...}` | **Yes** | Math |
| `part` | `\frac{\partial ...}{\partial ...}` | No | Math |
| `taylor` | Taylor series expansion | No | Math |
| `sqrt` | `\sqrt{...}` | **Yes** | Math |

#### Brackets & Enclosures (Auto-expanding)
| Trigger | Action | Auto | Context |
|---------|--------|------|---------|
| `()`, `[]`, `{}` | `\left( \right)`, `\left[ \right]`, `\left\{ \right\}` | No | Math |
| `||` | `\left\| \right\|` | No | Math |
| `lra` | `\left< \right>` | **Yes**| Math |
| `ceil`, `floor`| `\left\lceil \right\rceil`, `\left\lfloor \right\rfloor`| **Yes**| Any |
| `norm` | `\| ... \|` | **Yes**| Math |
| `conj` | `\overline{...}` | **Yes**| Math |
| `bar`, `hat` | `\bar{...}`, `\hat{...}` (Auto-applied to previous character) | **Yes**| Math |

#### Matrices & Vectors
| Trigger | Action | Auto | Context |
|---------|--------|------|---------|
| `pmat`, `bmat` | `\begin{pmatrix}`, `\begin{bmatrix}` | **Yes**| Math |
| `cvec` | Column vector with `\vdots` | **Yes**| Math |
| `rij` | `(x_n)_{n \in \mathbb{N}}` | No | Math |

#### Auto-Triggers for Math Functions
When in **math mode**, typing any of these followed by a space or non-alphabet character will auto-escape them with a backslash (e.g. typing `sin` automatically becomes `\sin`):  
`sin`, `cos`, `arccot`, `cot`, `csc`, `ln`, `log`, `exp`, `star`, `perp`, `arcsin`, `arccos`, `arctan`, `pi`, `zeta`, `delta`, `kappa`, `lambda`, `mu`, `nu`, `rho`, `sigma`, `tau`, `omega`.

#### Plotting & External Computation
| Trigger | Action | Auto | Context |
|---------|--------|------|---------|
| `plot` | TikZ/PGFPlots 2D axis block | No | Any |
| `surf` | TikZ/PGFPlots 3D surface block | No | Any |
| `node` | TikZ node | No | Any |
| `sympy` | Evaluate mathematical expression using SymPy | No | Any |
| `math` | Evaluate mathematical expression using WolframScript | No | Any |

---

### 9. Quick Start Guide"""

new_content = re.sub(r'### 8\. LaTeX Snippets Reference.*?### 9\. Quick Start Guide', new_snippets, content, flags=re.DOTALL)

with open('README.md', 'w', encoding='utf-8') as f:
    f.write(new_content)
