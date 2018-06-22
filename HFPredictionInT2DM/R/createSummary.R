# @file createSummary.R
#
# Copyright 2016 Observational Health Data Sciences and Informatics
#
# This file is part of LargeScalePrediction package
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' Get the summary details for the directory
#'
#' @description
#' This function creates a csv summarising all the model results
#'
#' @details
#' Searching through the directory to extract the model evaluation for each model
#'
#' @param workFolder                   The directory where the plpData and population are saved to
#'
#' @return
#' Returns TRUE when finished and saves the summary csv  into the workFolder directory
#' names summary.csv
#' @export
createSummary <- function(workFolder){
    # find all the models

    extLocations <- list.files(workFolder, full.names = T, recursive = T)[grep('*erformanceEvaluation.rds', list.files(workFolder, recursive = T))]
    extLocations <- extLocations[c(grep('lrModels',extLocations), grep('gbmModels',extLocations))]
    getDetails<- function(location){
                result <- readRDS(location)
                if (!grepl('externalPerformance',location)){
                    location_clean <- (gsub('/performanceEvaluation.rds','',location))
                    settings <- PatientLevelPrediction::loadPlpResult(location_clean)

                    extRes <- result$evaluationStatistics[result$evaluationStatistics[, 'Eval']=='test','Value']
                    extRes$AUC.auc_lb95ci <- 0

                    extRes$AUC.auc_ub95ci <- 0
                    if (grepl('CCAE', location_clean)){
                        model_db <- 'CCAE'
                    } else if (grepl('IPCI', location_clean)){
                        model_db <- 'IPCI'
                    } else if (grepl('MDCD', location_clean)){
                        model_db <- 'MDCD'
                    } else if (grepl('MDCR', location_clean)){
                        model_db <- 'MDCR'
                    }
                    #discuss with peter the best way to do this
                    results <- c(model = settings$inputSetting$modelSettings$model,
                                 targetId = settings$inputSetting$populationSettings$cohortId,
                                 outcomeId = settings$inputSetting$populationSettings$outcomeId,
                                 model_db = model_db,
                                 ext_db = model_db,
                                 extRes)
                    results <- unlist(results, recursive = TRUE, use.names = TRUE)

                    # results <- data.frame(results)
                    # return(results)

                } else{
                    if (grepl('6681', location)){
                        location_clean <- (gsub('/6681/\\w+PerformanceEvaluation.rds','/6681',location))
                        } else if (grepl('173', location)){
                        location_clean <- (gsub('/173/\\w+PerformanceEvaluation.rds','/173',location))
                    }

                    settings <- PatientLevelPrediction::loadPlpResult(location_clean)
                    extRes <- result$evaluationStatistics
                    if(sum(names(extRes)%in%c('AUC.auc_lb95ci'))<1){
                        extRes$AUC$auc_lb95ci <- NULL
                    }
                    if(sum(names(extRes)%in%c('AUC.auc_lb95ci.1'))<1)
                        extRes$AUC$auc_lb95ci.1 <- NULL
                    # extRes$CalibrationIntercept <- extRes$CalibrationIntercept[['Intercept']]
                    # extRes$CalibrationSlope <-  extRes$CalibrationSlope[['Gradient']]
                    if(length(names(extRes$AUC))){
                        extRes$AUC <- extRes$AUC[[1]]
                    }
                    extRes$AUC$auc_lb95ci <- 0
                    extRes$AUC$auc_lb95ci.1 <- 0
                    results <- c(model = settings$inputSetting$modelSettings$model,
                                 targetId = settings$inputSetting$populationSettings$cohortId,
                                 outcomeId = settings$inputSetting$populationSettings$outcomeId,
                                 model_db = result$modelDb,
                                 ext_db = result$externalDb,
                                 extRes)
                    results <- unlist(results, recursive = TRUE, use.names = TRUE)
                    # results <- data.frame(results)
                    return(results)
                    }
            }

        completeExtSummary <- sapply(file.path(extLocations), getDetails)
        t_comp_ext <- t(completeExtSummary)

    outputTo <- file.path(workFolder, 'summary.csv')
    write.csv(t_comp_ext, outputTo)
    print(paste0("file output to ", outputTo))
    return(TRUE)
}
