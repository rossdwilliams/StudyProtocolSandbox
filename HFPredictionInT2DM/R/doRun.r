doRun <- function(cdmDatabaseSchema,subFolder,targetCohortId,outcomeCohortId) {

    writeLines(
        paste0(
            'Database: ',
            cdmDatabaseSchema,
            ' targetCohortID: ',
            targetCohortId,
            ' outcomeCohortId ',
            outcomeCohortId
        ))

    # Study: ----
    # [PR] HF Prediction in T2DM

    # PatientLevelPrediction Installation & Load ----

    options('fftempdir' = 'S:\\temp\\tempff')
    # Uncomment to install PatientLevelPrediction
    # install.packages("devtools")
    # library("devtools")
    # devtools::install_github("ohdsi/PatientLevelPrediction", ref = "2.0.0")

    # Load the PatientLevelPrediction library
    library(PatientLevelPrediction)

    # # Load the StudyProtocolSandbox/HFinT2DM
    # library(HFPredictionInT2DM)

    # Data extraction ----

    # TODO: Insert your connection details here
    connectionDetails <-
        DatabaseConnector::createConnectionDetails(
            dbms = "pdw",
            server = "JRDUSAPSCTL01",
            user = NULL,
            password = NULL,
            port = 17001
        )
    #cdmDatabaseSchema <- "CDM_TRUVEN_CCAE_V656.dbo"
    #cohortsDatabaseSchema <- "CDM_TRUVEN_CCAE_V656.dbo"

    #cdmDatabaseSchema <- "CDM_TRUVEN_MDCR_V657.dbo"
    #cohortsDatabaseSchema <- "CDM_TRUVEN_MDCR_V657.dbo"
    cohortsDatabaseSchema <- cdmDatabaseSchema

    #cdmDatabaseSchema <- "CDM_TRUVEN_MDCD_V635.dbo"
    #cohortsDatabaseSchema <- "CDM_TRUVEN_MDCD_V635.dbo"

    cohortTable <- "cohort"
    outcomeTable <- "cohort"
    cdmVersion <- "5"
    outputFolder <- paste0("S:\\rwilliams\\HFinT2DM\\",subFolder,"\\",targetCohortId,"-",outcomeCohortId)
    writeLines(paste0("outputFolder: ", outputFolder))
    plpDataSaveName <- 'data'
    if (!dir.exists(outputFolder)) {
        dir.create(outputFolder, recursive = TRUE)
    }
    setwd(outputFolder)

    #5781	[PR] Heart failure prediction in T2DM (T2-narrow) V2	2018-01-25 07:51:00 pm	2018-01-25 08:12:00 pm	anonymous
    #5782	[PR] T2DM by PheKB Phenotype (T) V1	2018-01-25 08:01:00 pm	2018-01-25 08:02:00 pm	anonymous
    #5779	[PR] Heart failure prediction in T2DM (O2-Diastolic HF) V2	2018-01-25 06:38:00 pm	2018-01-25 07:41:00 pm	anonymous
    #5778	[PR] Heart failure prediction in T2DM (O2-Systolic HF) v2	2018-01-25 06:36:00 pm	2018-01-25 06:37:00 pm	anonymous
    #5617	[PR] Heart failure prediction in T2DM (O1-Any HF)	2018-01-22 11:18:00 pm	2018-01-25 06:33:00 pm	anonymous
    #5777	[PR] Heart failure prediction in T2DM (T2-narrow) incl drug	2018-01-25 06:06:00 pm	2018-01-25 06:09:00 pm	anonymous
    #5769	[PR] Heart failure prediction in T2DM (T1-broad) no Hist HF	2018-01-25 05:25:00 pm	2018-01-25 05:28:00 pm	anonymous
    #5656	[PR] Heart failure prediction in T2DM (O2-Diastolic HF)	2018-01-23 07:40:00 pm	2018-01-23 08:59:00 pm	anonymous
    #5657	[PR] Heart failure prediction in T2DM (O2-Systolic HF)	2018-01-23 07:43:00 pm	2018-01-23 08:57:00 pm	anonymous
    #5651	[PR] Heart failure prediction in T2DM (T2-narrow)	2018-01-23 06:24:00 pm	2018-01-23 08:53:00 pm	anonymous
    #5616	[PR] Heart failure prediction in T2DM (T1-broad)

    # targetCohortId <-
    #    5769 # [PR] Heart failure prediction in T2DM (T1-broad) no Hist HF
    # outcomeCohortId <- 5617 # [PR] Heart failure prediction in T2DM (O1)
    # outcomeCohortId <- 5779 #	[PR] Heart failure prediction in T2DM (O2-Diastolic HF) V2
    # outcomeCohortId <- 5778	[PR] Heart failure prediction in T2DM (O2-Systolic HF) v2

    outcomeList <- c(outcomeCohortId)

    # PLEASE NOTE ----
    # If you want to use your code in a distributed network study
    # you will need to create a temporary cohort table with common cohort IDs.
    # The code below ASSUMES you are only running in your local network
    # where common cohort IDs have already been assigned in the cohort table.

    # Get all  Concept IDs for exclusion ----

    excludedConcepts <- c()

    # Get all  Concept IDs for inclusion ----

    includedConcepts <- c()

    # Define which types of covariates must be constructed ----
    covariateSettings <-
        FeatureExtraction::createCovariateSettings(
            useDemographicsGender = TRUE,
            useDemographicsAge = FALSE,
            useDemographicsAgeGroup = TRUE,
            useDemographicsRace = FALSE,
            useDemographicsEthnicity = FALSE,
            useDemographicsIndexYear = FALSE,
            useDemographicsIndexMonth = FALSE,
            useDemographicsPriorObservationTime = FALSE,
            useDemographicsPostObservationTime = FALSE,
            useDemographicsTimeInCohort = FALSE,
            useDemographicsIndexYearMonth = FALSE,
            useConditionOccurrenceAnyTimePrior = FALSE,
            useConditionOccurrenceLongTerm = TRUE,
            useConditionOccurrenceMediumTerm = FALSE,
            useConditionOccurrenceShortTerm = FALSE,
            useConditionOccurrenceInpatientAnyTimePrior = FALSE,
            useConditionOccurrenceInpatientLongTerm = FALSE,
            useConditionOccurrenceInpatientMediumTerm = FALSE,
            useConditionOccurrenceInpatientShortTerm = FALSE,
            useConditionEraAnyTimePrior = TRUE,
            useConditionEraLongTerm = FALSE,
            useConditionEraMediumTerm = FALSE,
            useConditionEraShortTerm = FALSE,
            useConditionEraOverlapping = FALSE,
            useConditionEraStartLongTerm = FALSE,
            useConditionEraStartMediumTerm = FALSE,
            useConditionEraStartShortTerm = FALSE,
            useConditionGroupEraAnyTimePrior = FALSE,
            useConditionGroupEraLongTerm = FALSE,
            useConditionGroupEraMediumTerm = FALSE,
            useConditionGroupEraShortTerm = FALSE,
            useConditionGroupEraOverlapping = FALSE,
            useConditionGroupEraStartLongTerm = FALSE,
            useConditionGroupEraStartMediumTerm = FALSE,
            useConditionGroupEraStartShortTerm = FALSE,
            useDrugExposureAnyTimePrior = FALSE,
            useDrugExposureLongTerm = FALSE,
            useDrugExposureMediumTerm = FALSE,
            useDrugExposureShortTerm = FALSE,
            useDrugEraAnyTimePrior = TRUE,
            useDrugEraLongTerm = FALSE,
            useDrugEraMediumTerm = FALSE,
            useDrugEraShortTerm = FALSE,
            useDrugEraOverlapping = FALSE,
            useDrugEraStartLongTerm = FALSE,
            useDrugEraStartMediumTerm = FALSE,
            useDrugEraStartShortTerm = FALSE,
            useDrugGroupEraAnyTimePrior = FALSE,
            useDrugGroupEraLongTerm = FALSE,
            useDrugGroupEraMediumTerm = FALSE,
            useDrugGroupEraShortTerm = FALSE,
            useDrugGroupEraOverlapping = FALSE,
            useDrugGroupEraStartLongTerm = FALSE,
            useDrugGroupEraStartMediumTerm = FALSE,
            useDrugGroupEraStartShortTerm = FALSE,
            useProcedureOccurrenceAnyTimePrior = FALSE,
            useProcedureOccurrenceLongTerm = TRUE,
            useProcedureOccurrenceMediumTerm = FALSE,
            useProcedureOccurrenceShortTerm = FALSE,
            useDeviceExposureAnyTimePrior = FALSE,
            useDeviceExposureLongTerm = FALSE,
            useDeviceExposureMediumTerm = FALSE,
            useDeviceExposureShortTerm = FALSE,
            useMeasurementAnyTimePrior = FALSE,
            useMeasurementLongTerm = TRUE,
            useMeasurementMediumTerm = FALSE,
            useMeasurementShortTerm = FALSE,
            useMeasurementValueAnyTimePrior = FALSE,
            useMeasurementValueLongTerm = FALSE,
            useMeasurementValueMediumTerm = FALSE,
            useMeasurementValueShortTerm = FALSE,
            useMeasurementRangeGroupAnyTimePrior = FALSE,
            useMeasurementRangeGroupLongTerm = FALSE,
            useMeasurementRangeGroupMediumTerm = FALSE,
            useMeasurementRangeGroupShortTerm = FALSE,
            useObservationAnyTimePrior = FALSE,
            useObservationLongTerm = FALSE,
            useObservationMediumTerm = FALSE,
            useObservationShortTerm = FALSE,
            useCharlsonIndex = FALSE,
            useDcsi = FALSE,
            useChads2 = FALSE,
            useChads2Vasc = FALSE,
            useDistinctConditionCountLongTerm = FALSE,
            useDistinctConditionCountMediumTerm = FALSE,
            useDistinctConditionCountShortTerm = FALSE,
            useDistinctIngredientCountLongTerm = FALSE,
            useDistinctIngredientCountMediumTerm = FALSE,
            useDistinctIngredientCountShortTerm = FALSE,
            useDistinctProcedureCountLongTerm = FALSE,
            useDistinctProcedureCountMediumTerm = FALSE,
            useDistinctProcedureCountShortTerm = FALSE,
            useDistinctMeasurementCountLongTerm = FALSE,
            useDistinctMeasurementCountMediumTerm = FALSE,
            useDistinctMeasurementCountShortTerm = FALSE,
            useVisitCountLongTerm = FALSE,
            useVisitCountMediumTerm = FALSE,
            useVisitCountShortTerm = FALSE,
            longTermStartDays = -365,
            mediumTermStartDays = -180,
            shortTermStartDays = -30,
            endDays = 0,
            includedCovariateConceptIds = includedConcepts,
            addDescendantsToInclude = FALSE,
            excludedCovariateConceptIds = excludedConcepts,
            addDescendantsToExclude = FALSE,
            includedCovariateIds = c()
        )
    setwd(outputFolder)
    # plpData <-
    #     PatientLevelPrediction::getPlpData(
    #         connectionDetails = connectionDetails,
    #         cdmDatabaseSchema = cdmDatabaseSchema,
    #         cohortId = targetCohortId,
    #         outcomeIds = outcomeList,
    #         studyStartDate = "",
    #         studyEndDate = "",
    #         cohortDatabaseSchema = cohortsDatabaseSchema,
    #         cohortTable = cohortTable,
    #         outcomeDatabaseSchema = cohortsDatabaseSchema,
    #         outcomeTable = outcomeTable,
    #         cdmVersion = cdmVersion,
    #         firstExposureOnly = TRUE,
    #         washoutPeriod = 365,
    #         sampleSize = NULL,
    #         covariateSettings = covariateSettings
    #     )
    #
    # # PLEASE NOTE ----
    # # Creating the plpData object can take considerable computing time, and it is probably a good idea to save it
    # # for future sessions. Uncomment this line to save the data to the file system.
    # PatientLevelPrediction::savePlpData(plpData, plpDataSaveName)

    # Use this command to load the data from the file system
    plpData <- PatientLevelPrediction::loadPlpData(plpDataSaveName)

    # Create study population ----
    population <-
        PatientLevelPrediction::createStudyPopulation(
            plpData = plpData,
            outcomeId = outcomeCohortId,
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

    # train all the models
    fitAllPredictionModels(outputFolder, plpData, population)


    # # Create the model settings ----
    # modelSettings <-
    #     PatientLevelPrediction::setLassoLogisticRegression(variance = 0.01,
    #                                                        seed = NULL)
    #
    #
    # # Run the model ----
    # setwd(outputFolder)  # why do I need to say this again?
    # results <- PatientLevelPrediction::runPlp(
    #     population = population,
    #     plpData = plpData,
    #     modelSettings = modelSettings,
    #     testSplit = 'time',
    #     testFraction = 0.25,
    #     nfold = 3
    # )
    #
    #
    # # PLEASE NOTE ----
    # # You can save and load the model using:
    # PatientLevelPrediction::savePlpModel(results$model, dirPath = file.path(getwd(), "model"))
    # # plpModel <- PatientLevelPrediction::loadPlpModel(file.path(getwd(), "model"))
    #
    # # You can save and load the full results structure using:
    # PatientLevelPrediction::savePlpResult(results, dirPath = file.path(getwd(), "lr"))
    # results <- PatientLevelPrediction::loadPlpResult(file.path(getwd(), "lr"))
    #
    # #to interactively view the performance
    # #PatientLevelPrediction::viewPlp(results)
    #
    #
    # # add plots and document to output folder
    # PatientLevelPrediction::plotPlp(
    #     results,
    #     file.path(getwd(), 'plpmodels', results$analysisRef$analysisId)
    # )
#
#
#     PatientLevelPrediction::createPlpJournalDocument(
#         results,
#         plpData,
#         targetName = '[PR] Heart failure prediction in T2DM (T)',
#         outcomeName = '[PR] Heart failure prediction in T2DM (O1)',
#         outputLocation = file.path(
#             getwd(),
#             'plpmodels',
#             results$analysisRef$analysisId,
#             'ready_for_JAMA.docx'
#         )
#     )


    # writeLines(paste0(
    #     'Model output saved to ',
    #     file.path(getwd(), 'plpmodels', results$analysisRef$analysisId)
    # ))

    ######################################################################################
    # The plots can be found in the output older, but you can view them within R by removing the comments below:
    ######################################################################################
    # plot F1 over thresholds ----
    #PatientLevelPrediction::plotF1Measure(results$performanceEvaluation, type = "test")
    # precision recall plot ----
    #PatientLevelPrediction:: plotPrecisionRecall(results$performanceEvaluation, type = "test")
    # plot outcome probability distribution vs non-outcome probability distribution ----
    #PatientLevelPrediction:: plotPredictedPDF(results$performanceEvaluation, type = "test")
    #PatientLevelPrediction:: plotPreferencePDF(results$performanceEvaluation, type = "test")
    #PatientLevelPrediction:: plotPredictionDistribution(results$performanceEvaluation, type = "test")
    # Plot the calibration ----
    #PatientLevelPrediction::plotSparseCalibration(results$performanceEvaluation, type = "test")
    # Plot the ROC ----
    #PatientLevelPrediction::plotSparseRoc(results$performanceEvaluation, type = "test")

    # plot variable frequency in outcome vs non-outcome ----
    #PatientLevelPrediction::plotVariableScatterplot(results$covariateSummary)
    # plot variable frequency comparing test/train split ----
    #PatientLevelPrediction::plotGeneralizability(results$covariateSummary)
    # Plot the calibration ----
    #PatientLevelPrediction::plotSparseCalibration2(results$performanceEvaluation, type = "test")
    # Plot the ROC ----
    #PatientLevelPrediction::plotSparseRoc(results$performanceEvaluation, type = "test")
}
