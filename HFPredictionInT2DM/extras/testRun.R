source('S:/rwilliams/git/StudyProtocolSandbox/HFPredictionInT2DM/R/doRun.R')

#5769  [PR] Heart failure prediction in T2DM (T1-broad) no Hist HF


#doRun("IMS_GERDA_V539.dbo","GERDA",5769,5617)
#doRun("IMS_FRDA_V541.dbo","FRDA",5769,5617)
#doRun("IMS_AUSLPD_V525.dbo","AUSLPD",5769,5617)
#doRun("JMDC_V651.dbo","JMDC",5769,5617)
#doRun("OPTUMEXTDOD_V654.dbo","OPTUM",5769,5617)
#doRun("PREMIER_V636.dbo","PREMIER",5769,5617)

#broad t2dm definition
#5617  [PR] Heart failure prediction in T2DM (O1)
doRun("CDM_TRUVEN_MDCR_V657.dbo","MDCR",5769,5617)
doRun("CDM_TRUVEN_MDCD_V635.dbo","MDCD",5769,5617)
doRun("CDM_TRUVEN_CCAE_V656.dbo","CCAE",5769,5617)

#5778	[PR] Heart failure prediction in T2DM (O2-Systolic HF) v2
doRun("CDM_TRUVEN_MDCR_V657.dbo","MDCR",5769,5778)
doRun("CDM_TRUVEN_MDCD_V635.dbo","MDCD",5769,5778)
doRun("CDM_TRUVEN_CCAE_V656.dbo","CCAE",5769,5778)

#5779	[PR] Heart failure prediction in T2DM (O2-Diastolic HF) V2
doRun("CDM_TRUVEN_MDCR_V657.dbo","MDCR",5769,5779)
doRun("CDM_TRUVEN_MDCD_V635.dbo","MDCD",5769,5779)
doRun("CDM_TRUVEN_CCAE_V656.dbo","CCAE",5769,5779)

#Narrow T2DM definition

#5617  [PR] Heart failure prediction in T2DM (O1)
doRun("CDM_TRUVEN_MDCR_V657.dbo","MDCR",5796,5617)
doRun("CDM_TRUVEN_MDCD_V635.dbo","MDCD",5796,5617)
doRun("CDM_TRUVEN_CCAE_V656.dbo","CCAE",5796,5617)

#5778	[PR] Heart failure prediction in T2DM (O2-Systolic HF) v2
doRun("CDM_TRUVEN_MDCR_V657.dbo","MDCR",5796,5778)
doRun("CDM_TRUVEN_MDCD_V635.dbo","MDCD",5796,5778)
doRun("CDM_TRUVEN_CCAE_V656.dbo","CCAE",5796,5778)

#5779	[PR] Heart failure prediction in T2DM (O2-Diastolic HF) V2
doRun("CDM_TRUVEN_MDCR_V657.dbo","MDCR",5796,5779)
doRun("CDM_TRUVEN_MDCD_V635.dbo","MDCD",5796,5779)
doRun("CDM_TRUVEN_CCAE_V656.dbo","CCAE",5796,5779)
