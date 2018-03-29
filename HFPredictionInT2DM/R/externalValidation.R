# @file externalValidation.R
#
# Copyright 2016 Observational Health Data Sciences and Informatics
#
# This file is part of HFinT2DM package
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
#' This function creates a prediction for each model in unseen databases
#'
#' @details
#'
#'
#' @param workFolder               The directory where the plpData and population are saved to
#' @param model_db                 database model was developed in
#' @param other_db                 database(s) to make prediction in
#' @param targetId                 target cohort id
#' @param outcomeId                outcome cohort id
#' @return                         returns true if succesful
#' @export

externalValidation <- function(workFolder, model_db, other_db, targetId, outcomeId  ){

        # get the data
        data_path <- file.path(workFolder, other_db, paste(targetId,outcomeId,sep = '-'))
        print(data_path)
        plpdatasavename <- 'data'
        setwd(data_path)
        plpData <- PatientLevelPrediction::loadPlpData(plpdatasavename)
        print("data loaded")

        #create the population
        population <-
            PatientLevelPrediction::createStudyPopulation(
                plpData = plpData,
                outcomeId = outcomeId,
                binary = TRUE,
                includeAllOutcomes = TRUE,
                firstExposureOnly = TRUE,
                washoutPeriod = 365,
                removeSubjectsWithPriorOutcome = TRUE,
                priorOutcomeLookback = 99999,
                requireTimeAtRisk = TRUE,
                minTimeAtRisk = 365 -
                    1,
                riskWindowStart = 1,
                addExposureDaysToStart = FALSE,
                riskWindowEnd = 365,
                addExposureDaysToEnd = FALSE
            )




        # get the model
        model_path <- file.path(workFolder, model_db, paste(targetId, outcomeId, sep = '-'))
        print(model_path)
        setwd(model_path)
        #TODO: sort this to make it parameters or auto for all files?
        locations <- list.dirs(model_path, full.names = FALSE)[grep('/model$', list.dirs(model_path))]
        locations <- locations[c(grep('gbmModels',locations), grep('lrModels',locations))]

        for(location in locations){
            full_model_path <- file.path(model_path, location)
            plpModel <- PatientLevelPrediction::loadPlpModel(full_model_path)

            #make the prediction
            prediction <- plpModel$predict(plpData = plpData, population = population)

            #evaluate performance
            evaluation <- PatientLevelPrediction::evaluatePlp(prediction, plpData)
            evaluation$modelDb <- model_db
            evaluation$externalDb <- other_db
            output <- gsub('/model$','',full_model_path)

            saveRDS(evaluation, file.path(output,paste(model_db,other_db,"externalPerformanceEvaluation.rds", sep = '_')))
        }
        return(TRUE)


}
