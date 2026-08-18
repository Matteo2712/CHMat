# CH Mat — Da file a App sul telefono

Questo pacchetto contiene tutto il necessario. Segui i passi nell'ordine.

## 0. Estrai lo ZIP

Estrai `chmat-pwa.zip` in una cartella sul tuo computer (es. `CH Mat/`). Dentro troverai tutti i file alla radice: `index.html`, `manifest.json`, `service-worker.js`, `icons/`, `supabase-schema.sql`, questo file.

## 1. Supabase (login + sincronizzazione)

1. Usa il tuo progetto Supabase già esistente (condiviso con le tue altre app).
2. Vai su **SQL Editor** → **New query**, incolla il contenuto di `supabase-schema.sql` incluso qui, ed esegui (▶ Run). Crea una tabella chiamata **`CH_progress`** (prefisso `CH_` per riconoscerla tra le tabelle delle tue altre app).
3. Vai su **Authentication → Providers** → assicurati che **Email** sia abilitato (dovrebbe già esserlo, dato che lo usi per le altre app).
4. Vai su **Authentication → URL Configuration**:
   - In **Site URL** metti l'indirizzo dove pubblicherai l'app (es. `https://chmat.pages.dev` — lo saprai dopo il passo 3 con Cloudflare, puoi tornare qui e aggiornarlo dopo).
   - In **Redirect URLs** aggiungi lo stesso indirizzo (serve per il link di reset password).
5. Vai su **Project Settings → API**: copia **Project URL** e **anon public key** (probabilmente li hai già da un'altra app).
6. Apri `index.html` con un editor di testo, cerca queste due righe (vicino alla fine del file):
   ```js
   const SUPABASE_URL = "https://TUO-PROGETTO.supabase.co";
   const SUPABASE_ANON_KEY = "TUA-ANON-KEY";
   ```
   e sostituisci con i valori copiati al punto 5.

**Login**: nell'app potrai scegliere tra "Accedi" (se hai già un account su questo progetto Supabase, anche creato da un'altra tua app) e "Registrati" (email + password, per crearne uno nuovo). C'è anche "Password dimenticata?" per il reset via email.

## 2. GitHub — tramite GitKraken

Sì, puoi creare tutto direttamente da GitKraken (repository locale + repository su GitHub), esattamente come hai già fatto altre volte, senza terminale:

1. Apri **GitKraken** → **File → Init Repository** (o "Nuovo repository").
2. Scegli come cartella locale quella dove hai estratto lo ZIP (quella con dentro `index.html`, `manifest.json`, ecc. alla radice).
3. GitKraken creerà il `.git` locale. Nella schermata di init trovi anche l'opzione per **collegarlo subito a GitHub** ("Create repository on GitHub.com" o simile) — selezionala, scegli il nome **CH Mat** (o `ch-mat`), visibilità privata o pubblica a tua scelta, e conferma.
4. Nella vista di GitKraken vedrai i file come "non tracciati" (untracked): selezionali tutti, scrivi un messaggio di commit (es. "Prima versione CH Mat"), fai **Commit**, poi **Push** (in alto a destra) per caricarli sul repository GitHub appena creato.
5. Se in futuro modifico l'app e ti mando un nuovo `index.html`, ti basterà sostituire il file nella cartella locale, e in GitKraken vedrai la modifica pronta da fare commit + push.

## 3. Cloudflare Pages (hosting + HTTPS, richiesto per la PWA)

1. Vai su [dash.cloudflare.com](https://dash.cloudflare.com) → **Workers & Pages** → **Create** → **Pages** → **Connect to Git**.
2. Seleziona il repository **CH Mat**.
3. Build settings: **Framework preset: None**, **Build command: (vuoto)**, **Build output directory: /** (radice).
4. Deploy. Otterrai un indirizzo tipo `https://ch-mat.pages.dev`.
5. Torna su Supabase (punto 1.4) e aggiorna **Site URL** e **Redirect URLs** con questo indirizzo definitivo.
6. Apri l'indirizzo dal telefono: dovresti vedere la schermata di accesso, ricevere il link via email e poter usare l'app.

## 4. PWABuilder → APK

1. Vai su [pwabuilder.com](https://www.pwabuilder.com).
2. Incolla l'URL Cloudflare Pages (es. `https://ch-mat.pages.dev`) e premi Start.
3. PWABuilder analizzerà `manifest.json` e il service worker (dovrebbero risultare entrambi ✅ dato che sono già inclusi).
4. Vai su **Package for stores → Android** → scarica il pacchetto APK/AAB.
5. Installa l'APK sul telefono (o pubblicalo su Play Store se preferisci).

## Nota sul database e sui contenuti

- **I contenuti da studiare (flashcard, capitoli, domande di ortografia) NON sono nel database**: sono scritti direttamente dentro `index.html`. Il database Supabase contiene solo i tuoi progressi (una riga per utente nella tabella `CH_progress`). Se in futuro aggiorniamo le domande, basta aggiornare `index.html` — nessuna azione richiesta sul database.
- **Puoi usare lo stesso progetto Supabase delle tue altre app**: se usi lo stesso URL/anon key, il login (email) è condiviso automaticamente tra tutte le app collegate a quel progetto. Ti basta accedere con la stessa email che usi già altrove.

## Note importanti

- **Senza login**, l'app funziona comunque, ma resta locale solo su quel telefono (nessuna sincronizzazione).
- **Con login**, ogni volta che completi un test, una flashcard o l'ortografia, i progressi vengono automaticamente inviati a Supabase (con un piccolo ritardo di 1,5s per non sovraccaricare) e scaricati sugli altri dispositivi al login.
- **Flashcard e Ortografia sono sempre disponibili**, anche senza aver completato nessun capitolo al 100%: in entrambe le sezioni trovi un menu "Ambito" per scegliere tra "Tutti i capitoli" o un capitolo specifico (i capitoli superati al 100% sono contrassegnati con ✓, ma non è un requisito per usarli).
- Il service worker rende l'app **utilizzabile offline** una volta aperta almeno una volta (utile in viaggio/aereo): i tuoi progressi si sincronizzeranno automaticamente alla prossima connessione.
- Se in futuro vuoi rigenerare le icone con un design diverso, dimmelo pure.
