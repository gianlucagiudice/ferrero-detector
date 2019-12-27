### Elenco dei test effettuai
- Differenze nei vari color space
  - "color_space.m"
- Differrenze nei vari algoritmi di edge per la scatola
  - "edge_comparison.m"
- Il canale Cr funziona meglio di Cb per edge Canny
  - Mettere esempi
- Spazio colore YCbCr funziona meglio per riconoscimento edge Canny
  - Mettere Esempi
- Da canny a binarizzazione
  - Elimino oggetti che no sono la scatola
- Trovo i vertici dell'immagine
  - Vertice pivot è quello in verde 
  - Correggo gli errori prospettici, (Esempio vertici troppo vicini)
    - Le foto sono scattate dall'alto davanti alla scatolam non perfettamente sopra
  - **NUOVA IDEA**
    - Cercare i vertici "massimizando" e minimizzando" le funzioni f(x) = $\pm$x;
- ...
- Per trovare i vertici uso come feature edge canny

### Assunzioni
- C'è la scatola
- La scatola occupa la maggior parte dell'immagine
- Non possono esserci oggetti attacati alla scatola
- 