package cell.consistency
import rego.v1
import data.cell.consistency.topology
default allow = false
# Rule to allow if PCI is within range 1-3000
allow_if_pci_in_range  if {
    input.PCI >= data.node.cell.consistency.minPCI
    input.PCI <= data.node.cell.consistency.maxPCI
}
# Main rule to determine the final decision
allow  if{
    topology.check_cell_consistency
    allow_if_pci_in_range
}