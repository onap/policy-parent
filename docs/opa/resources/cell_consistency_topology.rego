package cell.consistency.topology
import rego.v1
# Rule to check cell consistency
check_cell_consistency if {
    input.cell != data.node.cell.consistency.allowedCellId
}