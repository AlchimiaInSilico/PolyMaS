# PolyMaS
Performs the computational polymerization of linear molecules from their structural repetitive units by using Simplified Molecular Input Line Entry Specification (SMILES).

# Usage
PolyMaS(SMILES_SRU, PD)

# Arguments
-In the first parameter, enter the Structural Repetitive Unit (SMILES_SRU), that is, the SMILES code string. Asterisks (*) are used as indicators of the head (the first one) and the tail (the second one). The polystyrene SRU in SMILES code is provided as an example: *C(C*)c1ccccc1

-The second parameter is the desired Polymerization Degree (PD), expressing the number of SRUs of the molecule to be generated. 

# Value
PolyMaS return The SMILES representation of the resulting polymer with the desired polymerization degree.

# Example
PolyMaS("*C(C*)1ccccc1",19)
