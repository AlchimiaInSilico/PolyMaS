# PolyMaS
Performs the computational polymerization of linear molecules from their structural repetitive units by using Simplified Molecular Input Line Entry Specification (SMILES).

# Install package

```
install.packages("devtools")
devtools::install_github("AlchimiaInSilico/PolyMaS")
library(PolyMaS)
```

or 

```
install.packages("remotes")
remotes::install_github("AlchimiaInSilico/PolyMaS")
library(PolyMaS)
```

NOTE: for "cannot open URL" error, this [guide](https://www.fnbky.com/TLS1_2TroubleShootingGuide.pdf) recommended enabling TLS 1.2

In the Internet Options window, click on the Advanced tab at the top of the window.
• Scroll down to the end of the list and click in the square check boxes next to "Use TLS 1.1" and "Use
TLS 1.2" if they don't already have a check mark in them. 
• Press the OK button to save this change.

# Usage
PolyMaS(SMILES_SRU, PD)

# Arguments
-In the first parameter, enter the Structural Repetitive Unit (SMILES_SRU), that is, the SMILES code string. Asterisks (*) are used as indicators of the head (the first one) and the tail (the second one). The polystyrene SRU in SMILES code is provided as an example:
``` *C(C*)c1ccccc1 ```

-The second parameter is the desired Polymerization Degree (PD), expressing the number of SRUs of the molecule to be generated. 

# Value
PolyMaS return The SMILES representation of the resulting polymer with the desired polymerization degree.

# Example
``` PolyMaS("*C(C*)1ccccc1",19) ```
