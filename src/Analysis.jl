#Data-specific part of analysis

function binarize_motor!(Y,pad) 
    if pad == :random
        Y[Y .== 0] = binary_rand(sum(Y .== 0))
    elseif pad ∈ [+1,-1]
        Y[Y .== 0] .= pad
    else
        error("invalid invalid value for argument \"formula\"")
    end
end

function calc_MI_bootstrap(df,n_samples,block_size,do_bootstrap,formula,pad) 
    I_UBs = zeros(n_samples,n_mutants,n_cells)
    I_LBs = zeros(n_samples,n_mutants,n_cells)
    for i_mutant in 1:n_mutants, i_cell in 1:n_cells
        Y1 = df[i_mutant,i_cell,1][:,:state]
        Y2 = df[i_mutant,i_cell,2][:,:state]
        Y = [Y1 Y2]
        I_UBs[:,i_mutant,i_cell],I_LBs[:,i_mutant,i_cell] = MI_bootstrap(Y,formula,Y->binarize_motor!(Y,pad),do_bootstrap,n_samples,block_size)
    end
    return I_UBs,I_LBs
end