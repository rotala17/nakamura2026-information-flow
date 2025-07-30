#Estimator applicable for general time series from dual reporter systems

function state2α(Y1,Y2)
    if length(Y1) != length(Y2)
        error("Y1 and Y2 must have the same length")
    else
        N = length(Y1)
    end
    unique_set = sort(unique([Y1;Y2]))
    n_unique_set = length(unique_set)
    α1 = zeros(n_unique_set)
    α2 = zeros(n_unique_set)
    for i_u in 1:n_unique_set
        α1[i_u] = (sum(Y1 .== unique_set[i_u]) + sum(Y2 .== unique_set[i_u])) / (2N)
        α2[i_u] = sum((Y1 .== unique_set[i_u]) .& (Y2 .== unique_set[i_u])) / N
    end
    return α1,α2
end

function stationary_bootstrap(Y,block_size,do_bootstrap)
    if !do_bootstrap
        return Y
    end
    
    N = size(Y)[1]
    sumL = 0
    Ybs = zeros(size(Y)[1],size(Y)[2])
    while sumL < N
        L = rand(Geometric(block_size^(-1)))
        I = sample(1:N)
        B = Y[mod.(I-1:I+L-2,N).+1,:]
        Ybs[sumL+1:min(sumL+L,N),:] = B[1:(min(sumL+L,N)-sumL),:]
        sumL += L
    end
    return Ybs
end



I_UB(α1,α2) = sum(α2 ./ α1) - 1
SY(α1) = -sum(α1 .*log.(α1))
S0(P0) = -sum(P0 .* log.(P0))
D(α1,P0) = sum((log.(P0) .+1) .* (α1 - P0))
I_TA(α1,α2,P0) = SY(α1) - S0(P0) + D(α1,P0) +  1/2 * (sum(α2./P0) - 1)
I_LB(α1,α2,iy) = SY(α1) - S0([1/2,1/2]) + 2(α2[iy]-α1[iy]) + 1/2


function MI_bootstrap(Y,LB_formula,binarize!,do_bootstrap,n_samples,block_size)
    α1,α2 = state2α(Y[:,1],Y[:,2])
    I_UBs = zeros(n_samples)
    I_LBs = zeros(n_samples)
    for i_sample in 1:n_samples
        #Calculation of upper bound
        Y_sb = stationary_bootstrap(Y,block_size,do_bootstrap)
        α1,α2 = state2α(Y_sb[:,1],Y_sb[:,2])
        I_UBs[i_sample] = I_UB(α1,α2)
        #Calculation of lower bound
        binarize!(Y_sb)
        α1,α2 = state2α(Y_sb[:,1],Y_sb[:,2])
        if LB_formula == :TA
            I_LBs[i_sample] = I_TA(α1,α2,[1/2,1/2])
        elseif LB_formula ∈ [:LB1,:LB2]
            iy_dict = Dict(:LB1 => 1, :LB2 => 2)
            iy = iy_dict[LB_formula]
            I_LBs[i_sample] = I_LB(α1,α2,iy)
        else
            error("invalid value for argument \"formula\"")
        end
    end
    I_UBs ./= log(2); I_LBs ./= log(2)
    return I_UBs,I_LBs
end


