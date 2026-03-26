# Portable PowerShell Web Launcher

A zero-install, single-file HTML viewer for Windows. Double-click a `.bat` file, browse to any local HTML file or URL, and it renders in a native window — no browser install, no admin rights, no setup.

## What It Does

```
User double-clicks .bat
  → PowerShell extracts embedded script to temp .ps1
    → WinForms GUI opens (browse file / enter URL)
      → WebBrowser control renders the HTML
        → Temp .ps1 self-deletes on exit
```

## Tech Stack

| Layer | Technology |
|---|---|
| Entry point | Batch script (`.bat`) |
| Runtime | PowerShell 2.0+ (built-in on Windows 7+) |
| GUI framework | .NET WinForms (`System.Windows.Forms`) |
| Rendering engine | `WebBrowser` control (MSHTML / Trident / IE11) |
| Browser emulation | `FEATURE_BROWSER_EMULATION = 11001` via HKCU (no admin) |

## Guaranteed Run Environment

- **Windows 7, 8, 8.1, 10, 11** — works out of the box
- **No admin rights required** — all registry writes go to `HKCU`
- **No installation** — nothing to install, uninstall, or configure
- **No external dependencies** — uses only components bundled with Windows
- **Offline** — no network access needed

## How to Use

1. Place `Portable-Powershell-Html-Launcher.bat` anywhere on disk
2. Double-click it
3. Press any key when prompted
4. Browse to a local `.html` file **or** type a URL
5. Click **Launch**

## Pros

- **Truly portable** — single `.bat` file, copy anywhere
- **Works on locked-down machines** — no admin, no installs, no policy changes
- **Rich UI via HTML/CSS/JS** — far more flexible than pure PowerShell GUI
- **Self-cleaning** — temp files removed on exit
- **Offline-friendly** — everything runs locally

## Cons

- **Windows-only** — depends on .NET WinForms + WebBrowser control
- **IE11 engine (Trident)** — JavaScript limited to ES5, no modern APIs (`fetch`, `Promise`, `async/await`, arrow functions, `let`/`const`, Web Crypto, etc.)
- **Deprecated engine** — Microsoft no longer updates Trident; it works today but receives no fixes
- **Performance** — slower JS execution compared to modern browsers, especially for CPU-heavy tasks

## Constraints for HTML Apps

Any HTML loaded by this launcher must follow these rules:

- **ES5 JavaScript only** — use `var`, `for` loops, `function` declarations
- **No ES6+ syntax** — no template literals, destructuring, classes, modules
- **No modern Web APIs** — no `fetch`, `crypto.subtle`, `IntersectionObserver`, etc.
- **Use `addEventListener`** — supported in IE11 mode
- **Include `<meta http-equiv="X-UA-Compatible" content="IE=edge" />` in your HTML**
