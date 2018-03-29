plotExternalHeatmap <- function(extResults, outcome, development, validation, fill, target, method, low = 'red', high = 'green', fileName = NULL){
    plot <- ggplot2::ggplot(extResults) +
        ggplot2::facet_wrap(get(development)  ~ get(target) + get(method), ncol = 4) +
        ggplot2::geom_tile(ggplot2::aes(x = get(outcome), y = get(validation), fill = get(fill))) +
        ggplot2::scale_fill_gradient(low = low, high = high, name = 'AUC') +
        # ggplot2::scale_y_discrete(name ="Validation Database",
        #                           limits = rev(levels(all_dbs$ext_db))) +
        ggplot2::labs(x = "Outcome", y = "Validation Database" ) +
        # ggplot2::scale_x_discrete(limit = c('5617', '5778', '5779'),
        #                          labels = c("all","HFpEF","HFrEF")) +
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
                       panel.background = ggplot2::element_blank(),
                       panel.spacing.y = ggplot2::unit(2,'lines'))

    if (!is.null(fileName))
        ggplot2::ggsave(fileName, plot, width = 5, height = 4.5, dpi = 400)
    return(plot)
}
results <- read.csv("S:/rwilliams/HFinT2DM/results/summary.csv")
plotExternalHeatmap(results, outcome = 'outcomeId', development = 'model_db', validation = 'ext_db', fill = 'AUC', target = 'targetId', method = 'method')
