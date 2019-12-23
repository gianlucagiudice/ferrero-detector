## Best practices
 - Prima di un filtro di edge, aplicare filtri di smooothing

## Processing
 - Unire gli edge con transofrmata di Hugh
 - Edge detection
 - laplaciano gaussiano
 - trasformata di Hugh
 - Spazi colore
 - Texture per riconoscere il tipo di scatola

## Idee
 - Per cercare la scatola si usa il pattern della scatola e rapporto lati
 - Per guardare se c'è il bollino sul ferrero rocher, basta guardare gli istogrammi dei cioccolatini sullo spazio colore hsv e prendendo solo il canale S

## Pipeline
 - Convertire in spazio colore YCbCr
 - Segmentare con edge Canny
 - Labeling delle componenti usando k-means clustering su media colore di edge Canny
 - Eliminare il bordo della scatola
   - Dilation su label relativa al background per trovare label del bordo
 - Trovare vertici scatola
