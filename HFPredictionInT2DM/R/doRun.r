doRun <- function(databaseSchema,model_db,targetCohortId,outcomeCohortId, connectionDetails) {

    writeLines(
        paste0(
            'Database: ',
            databaseSchema,
            ' targetCohortID: ',
            targetCohortId,
            ' outcomeCohortId ',
            outcomeCohortId
        ))

    # Study: ----
    # HF Prediction in T2DM

    # PatientLevelPrediction Installation & Load ----

    options('fftempdir' = 'S:\\temp\\tempff')
    # Uncomment to install PatientLevelPrediction
    # install.packages("devtools")
    # library("devtools")
    # devtools::install_github("ohdsi/PatientLevelPrediction", ref = "2.0.0")

    # Load the PatientLevelPrediction library
    library(PatientLevelPrediction)

    # # Load the StudyProtocolSandbox/HFinT2DM
    library(HFPredictionInT2DM)

    # Data extraction ----

    # TODO: Insert your connection details here

    setwd(outputFolder)


    outcomeList <- c(outcomeCohortId)

    # # PLEASE NOTE ----
    # # If you want to use your code in a distributed network study
    # # you will need to create a temporary cohort table with common cohort IDs.
    # # The code below ASSUMES you are only running in your local network
    # # where common cohort IDs have already been assigned in the cohort table.

    # # Get all  Concept IDs for exclusion ----

    excludedConcepts <- c()

    # # Get all  Concept IDs for inclusion ----

    includedConcepts <- c()

    # # Define which types of covariates must be constructed ----
    covariateSettings <-
        FeatureExtraction::createCovariateSettings(useDemographicsGender = TRUE,
                                                    useDemographicsAge = FALSE,
                                                    useDemographicsAgeGroup = TRUE,
                                                    useDemographicsRace = TRUE,
                                                    useDemographicsEthnicity = TRUE,
                                                    useDemographicsIndexYear = TRUE,
                                                    useDemographicsIndexMonth = TRUE,
                                                    useDemographicsPriorObservationTime = FALSE,
                                                    useDemographicsPostObservationTime = FALSE,
                                                    useDemographicsTimeInCohort = FALSE,
                                                    useDemographicsIndexYearMonth = FALSE,
                                                    useConditionOccurrenceAnyTimePrior = FALSE,
                                                    useConditionOccurrenceLongTerm = TRUE,
                                                    useConditionOccurrenceMediumTerm = FALSE,
                                                    useConditionOccurrenceShortTerm = TRUE,
                                                    useConditionOccurrenceInpatientAnyTimePrior = FALSE,
                                                    useConditionOccurrenceInpatientLongTerm = FALSE,
                                                    useConditionOccurrenceInpatientMediumTerm = FALSE,
                                                    useConditionOccurrenceInpatientShortTerm = FALSE,
                                                    useConditionEraAnyTimePrior = FALSE,
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
                                                    useDrugExposureLongTerm = TRUE,
                                                    useDrugExposureMediumTerm = FALSE,
                                                    useDrugExposureShortTerm = TRUE,
                                                    useDrugEraAnyTimePrior = FALSE,
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
                                                    useProcedureOccurrenceShortTerm = TRUE,
                                                    useDeviceExposureAnyTimePrior = FALSE,
                                                    useDeviceExposureLongTerm = FALSE,
                                                    useDeviceExposureMediumTerm = FALSE,
                                                    useDeviceExposureShortTerm = FALSE,
                                                    useMeasurementAnyTimePrior = FALSE,
                                                    useMeasurementLongTerm = TRUE,
                                                    useMeasurementMediumTerm = FALSE,
                                                    useMeasurementShortTerm = TRUE,
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
                                                    useCharlsonIndex = TRUE,
                                                    useDcsi = TRUE,
                                                    useChads2 = TRUE,
                                                    useChads2Vasc = TRUE,
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
                                                    includedCovariateIds = c())
    setwd(outputFolder)
    plpData <-
        PatientLevelPrediction::getPlpData(
            connectionDetails = connectionDetails,
            cdmDatabaseSchema = cdmDatabaseSchema,
            cohortId = targetCohortId,
            outcomeIds = outcomeList,
            studyStartDate = "",
            studyEndDate = "",
            cohortDatabaseSchema = cohortsDatabaseSchema,
            cohortTable = cohortTable,
            outcomeDatabaseSchema = cohortsDatabaseSchema,
            outcomeTable = outcomeTable,
            cdmVersion = cdmVersion,
            firstExposureOnly = TRUE,
            washoutPeriod = 365,
            sampleSize = NULL,
            covariateSettings = covariateSettings
        )

    # # PLEASE NOTE ----
    # # Creating the plpData object can take considerable computing time, and it is probably a good idea to save it
    # # for future sessions. Uncomment this line to save the data to the file system.
    PatientLevelPrediction::savePlpData(plpData, plpDataSaveName)

    # # Use this command to load the data from the file system
    # plpData <- PatientLevelPrediction::loadPlpData(plpDataSaveName)

    # # Create study population ----
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

    # # train all the models
    fitAllPredictionModels(outputFolder, plpData, population)


    # # # Create the model settings ----
    # modelSettings <-
    #     PatientLevelPrediction::setGradientBoostingMachine()


    # Run the model ----
    setwd(outputFolder)  # why do I need to say this again?
    results <- PatientLevelPrediction::runPlp(
        population = population,
        plpData = plpData,
        modelSettings = modelSettings,
        testSplit = 'person',
        testFraction = 0.25,
        nfold = 3
    )

    # # store name of database used for development
    results$model$model_db <- model_db
    # # PLEASE NOTE ----
    # # You can save and load the model using:
    PatientLevelPrediction::savePlpModel(results$model, dirPath = file.path(getwd(), "model"))
    # plpModel <- PatientLevelPrediction::loadPlpModel(file.path(getwd(), "model"))

    # # You can save and load the full results structure using:
    PatientLevelPrediction::savePlpResult(results, dirPath = file.path(getwd(), "lr"))
    # results <- PatientLevelPrediction::loadPlpResult(file.path(getwd(), "lr"))


    writeLines(paste0(
        'Model output saved to ',
        file.path(getwd(), 'plpmodels', results$analysisRef$analysisId)
    ))


}
