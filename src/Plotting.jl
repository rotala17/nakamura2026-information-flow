
function plot_MI(MI;only_legend=false)
    red = colorant"#FF644E"
    blue = colorant"#00A2FF"
    gray = colorant"#5E5E5E"
    colors = [blue,red]
    markershapes = [:dtriangle,:utriangle]
    label_uplw = ["upper bound: ","lower bound: "]
    label_mutant = ["RB+","RB\$-\$"]
    w = 0.1
    offset = [w,-w]
    offset_mutant = [0,n_cells + 0.5]

    plot()
    for i_mutant in 1:n_mutants, i_cell in 1:n_cells
        #cell_ID = (i_mutant-1)*n_cells + i_cell
        for i_uplw in 1:2
            label = (i_cell == 1) ? label_uplw[i_uplw]*label_mutant[i_mutant] : ""
            scatter!([i_cell + offset[i_uplw] + offset_mutant[i_mutant]],[mean(MI[i_uplw][:,i_mutant,i_cell])],
                    yerror = std(MI[i_uplw][:,i_mutant,i_cell]),
                    color = colors[i_mutant], markerstrokecolor=colors[i_mutant],
                    markershape = markershapes[i_uplw],label=label)
        end
    end
    

    if only_legend
        plot!(xlim=(-1,-1),ticks=false,showaxis=false,legend=:left)
    else
        plot!(xlim=(1-5w,n_mutants*n_cells+1+5w), ylim=(-0.25,1.),yticks = -0.2:0.2:1.0,xlabel = "Cell ID",ylabel="\$\\mathcal{I}[\\mathcal{X}_{t};Y_{t}]\\ (\\mathrm{bit})\$",legend=false,yguidefontfamily="Bookman")
        plot!(xticks = (reshape([i_cell + offset_mutant[i_mutant] for i_cell in 1:n_cells,i_mutant in 1:n_mutants],n_cells*n_mutants),["$(label_mutant[i_mutant])$(i_cell)" for i_cell in 1:n_cells,i_mutant in 1:n_mutants]),xrotation=45)
    end
end

function plot_dual_trajectory(i_mutant,i_cell,cell_id,color,offset)
    plot(df[i_mutant,i_cell,1][:,:time],df[i_mutant,i_cell,1][:,:state],color=color)
    plot!(df[i_mutant,i_cell,2][:,:time],df[i_mutant,i_cell,2][:,:state] .- offset,color=color)
    plot!(
        xlabel="\$t\\ (\\mathrm{s})\$",
        ylabel="State of two motors \n in cell $(cell_id)\n\n",
        yticks=([-1-offset,-0-offset,1-offset,-1,0,1],["\$-1\$","\$0\$","\$+1\$","\$-1\$","\$0\$","\$+1\$"]),
        legend=false
        )
    annotate!([-22,-22],[0,-offset],[text("\$Y_{t}\$",12),text("\$Y'_{t}\$",12)])
end