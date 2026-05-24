# Parser dei Percorsi

Semplice parser PowerShell per analizzare percorsi di eseguibili da file .txt.

Lo strumento legge un file di testo contenente un percorso per riga ed esegue una validazione forense di base su ogni voce.

---

# Funzionalità

- Analizza rapidamente liste di percorsi anche molto grandi
- Verifica:
  - esistenza del file
  - stato della firma
  - timestamp ultima modifica
- Visualizzazione risultati tramite Out-GridView
- Gestione di percorsi non validi o mancanti

---

# Colonne Output

| Colonna   | Descrizione |
|------------|------------|
| Percorso   | Percorso completo del file |
| Timestamp  | LastWriteTime del file |
| Signature  | Signed / Unsigned / Not Found |

---

# Stato Firma

| Stato      | Significato |
|------------|------------|
| Signed     | Firma valida |
| Unsigned   | Nessuna firma valida |
| Not Found  | File non esistente |

---

# Requisiti

- Windows PowerShell 5.1+
- Supporto Out-GridView
- Ambiente Windows

---

# Esempio

1. Esporta percorsi da:
   - System Informer > csrss > `^(?:\\\\\?\\)?[A-Za-z]:\\.+$`

2. Salva in un .txt

3. Esegui lo script

4. Analizza

---

# Autore

DS: @imsandy.dll

---

# Esecuzione da CMD (Amministratore)

```
powershell -ExecutionPolicy Bypass -Command "& { $p = \"$env:TEMP\PathParser.ps1\"; iwr 'https://raw.githubusercontent.com/sandydll-bs/PathParser/main/PathParser.ps1' -OutFile $p; Start-Process powershell -Verb RunAs -ArgumentList @('-NoExit','-ExecutionPolicy','Bypass','-File',$p) }"
