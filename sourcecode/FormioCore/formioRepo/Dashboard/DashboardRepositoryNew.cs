using formioCommon.Constants;
using formioModels.Dashboard;
using formioModels;
using System;
using System.Collections.Generic;
using System.Linq;
using MongoDB.Bson;
using formioModels.Data;
using MongoDB.Driver;
using Microsoft.Extensions.Configuration;
using formioRepo.Helpers;
using static formioRepo.Dashboard.CommodityConstants;
using Microsoft.AspNetCore.Mvc;

namespace formioRepo.Dashboard
{
    public class DashboardRepositoryNew
    {
        private readonly IConfiguration _iconfiguration;
        public DashboardRepositoryNew(IConfiguration iConfiguration)
        {
            _iconfiguration = iConfiguration;
        }

        protected IMongoCollection<T> GetMongoCollectionObject<T>(string collectionName)
        {
            IMongoDatabase imongoDb = GetMongoDbConnection();
            return imongoDb.GetCollection<T>(collectionName);
        }
        protected IMongoDatabase GetMongoDbConnection()
        {
            MongoClient client = new MongoClient(_iconfiguration["MongoDBConnectionString"]);
            return client.GetDatabase(_iconfiguration["MongoCommunicatorDB"]);
        }

        public VesselDashboardOutputModel GetVesselDashboard(VesselDashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool? isloop = false)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetVesselDashboard", "DataSetService"));
            IMongoCollection<DataSetOutputModel> datasetCollection = GetMongoCollectionObject<DataSetOutputModel>(MongoDBCollectionConstants.DataSet);
            var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
            VesselDashboardOutputModel result = new VesselDashboardOutputModel();
            List<ProductionDataModel> productionList = new List<ProductionDataModel>();
            List<ProfitAndLossModel> profitandlossList = new List<ProfitAndLossModel>();

            PurchaseFormIds.TryGetValue(inputModel.CompanyName, out string purchageFormId);
            SalesFormIds.TryGetValue(inputModel.CompanyName, out string salesFormId);
            CustomsDutyFormIds.TryGetValue(inputModel.CompanyName, out string customsDutyFormId);

            purchageFormId = purchageFormId.ToLower();
            salesFormId = salesFormId.ToLower();
            customsDutyFormId = customsDutyFormId.ToLower();
            string vesselIdString = inputModel.ContractUniqueId;
            string dailyRatesFormId = DailyRatesFormId.ToLower();
            string dutyFormId = DutyFormId.ToLower();
            string fxPaymentsFormId = inputModel.CompanyName == "Umiro-INDIA" ?
                                             FXPaymentsUmiroFormId.ToLower()
                                             : FXPaymentsANAFormId.ToLower();
            string locationMasterFormId = LocationMasterFormId.ToLower();
            string CompanyIdString = loggedInContext.CompanyGuid.ToString().ToLower();
            DateTime fromDate = inputModel.FromDate ?? DateTime.UtcNow;
            DateTime toDate = inputModel.Todate ?? DateTime.UtcNow;
            int fromDay = fromDate.Day;
            int fromMonth = fromDate.Month;
            int fromYear = fromDate.Year;
            int toDay = toDate.Day;
            int toMonth = toDate.Month;
            int toYear = toDate.Year;
            string location = inputModel.CompanyName == "Umiro-INDIA" ? "umiro-india" : "ana-india";
            string subLocation = "";
            decimal finalQty = 0;
            decimal valueInr = 0;

            List<BsonDocument> pipelineSourceData = new List<BsonDocument>
            {
                new BsonDocument("$match",
                    new BsonDocument
                    {
                        { "DataSourceId", purchageFormId },
                        { "CompanyId", CompanyIdString },
                        { "IsArchived", false },
                        { "DataJson.FormData.uniqueIdImportLocal", vesselIdString }
                    }),
                new BsonDocument("$project",
                    new BsonDocument
                    {
                        { "_id", 0 },
                        { "Source", "$DataJson.FormData.commodity" },
                        { "SubLocation", "$DataJson.FormData.location" },
                        { "ProductName", "$DataJson.FormData.productGroup1" },
                        { "TotalQty", "$DataJson.FormData.contractQuantityMt" },
                        { "ContractQty", "$DataJson.FormData.netPurchasesSinceJan2023" },
                        { "FinalQty", "$DataJson.FormData.finalAdjustedQuantityMt" },
                        { "ValueInr", "$DataJson.FormData.valueInr" },
                        { "SOTQty",
                            new BsonDocument("$ifNull",
                                new BsonArray
                                {
                                    "$DataJson.FormData.sotQuantityMt",
                                    0
                                })
                        },
                        { "AdjustmentQty",
                                new BsonDocument("$ifNull",
                                new BsonArray
                                {
                                    "$DataJson.FormData.adjustmentQuantityMt",
                                    0
                                })
                        }
                    })
            };
            var sourceDataSet = datasetCollection.Aggregate<BsonDocument>(pipelineSourceData, aggregateOptions).FirstOrDefault();

            if (sourceDataSet != null)
            {
                result.SourceCommodity = sourceDataSet.TryGetValue("Source", out BsonValue sourceValue) && sourceValue.IsString ? sourceValue.AsString : string.Empty;
                subLocation = sourceDataSet.TryGetValue("SubLocation", out BsonValue subLocationValue) && subLocationValue.IsString ? subLocationValue.AsString : string.Empty;
                result.ProductGroup = sourceDataSet.TryGetValue("ProductName", out BsonValue productNameValue) && productNameValue.IsString ? productNameValue.AsString : string.Empty;
                result.TotalContractQuantity = sourceDataSet.TryGetValue("TotalQty", out BsonValue totalQtyValue) && totalQtyValue.RawValue != null ? totalQtyValue.ToDecimal() : 0;
                result.PurchaseQuantity = sourceDataSet.TryGetValue("ContractQty", out BsonValue contractQtyValue) && contractQtyValue.RawValue != null ? contractQtyValue.ToDecimal() : 0;
                result.TotalSotQuantity = sourceDataSet.TryGetValue("SOTQty", out BsonValue sotQtyValue) && sotQtyValue.RawValue != null ? sotQtyValue.ToDecimal() : 0;
                result.AddBack = sourceDataSet.TryGetValue("AdjustmentQty", out BsonValue adjustmentQtyValue) && adjustmentQtyValue.RawValue != null ? adjustmentQtyValue.ToDecimal() : 0;
                result.SotDifference = result.TotalContractQuantity - result.PurchaseQuantity; //4.Net Purchases since Jan 2023(MT)
                finalQty = sourceDataSet.TryGetValue("FinalQty", out BsonValue finalQtyValue) && finalQtyValue.RawValue != null ? finalQtyValue.ToDecimal() : 0;
                valueInr = sourceDataSet.TryGetValue("ValueInr", out BsonValue ValueInrValue) && ValueInrValue.RawValue != null ? ValueInrValue.ToDecimal() : 0;
            }

            if (!string.IsNullOrWhiteSpace(result.SourceCommodity))
            {
                List<BsonDocument> pipelineSalesData1 = new List<BsonDocument>
                {
                    new BsonDocument("$match",
                        new BsonDocument
                        {
                            { "DataSourceId", salesFormId },
                            { "CompanyId", CompanyIdString},
                            { "IsArchived", false },
                            { "DataJson.FormData.ImportUniqueId", vesselIdString },
                            { "DataJson.FormData.commodity1", new BsonDocument("$nin", new BsonArray { BsonNull.Value, "" , " "}) }
                        }),
                    new BsonDocument("$addFields",
                        new BsonDocument
                        {
                            { "sourceCommodity", new BsonDocument("$toLower", "$DataJson.FormData.sourceCommodity") },
                            { "dateFilter", new BsonDocument("$toDate", "$DataJson.FormData.tradeDate") }
                        }),
                    new BsonDocument("$match",
                        new BsonDocument
                        {
                            { "sourceCommodity", result.SourceCommodity.ToLower() },
                            { "dateFilter",
                                new BsonDocument
                                {
                                    { "$gte", BsonDateTime.Create(new DateTime(fromYear, fromMonth, fromDay, 0, 0, 0)) },
                                    { "$lte", BsonDateTime.Create(new DateTime(toYear, toMonth, toDay, 23, 59, 59)) }
                                }
                            }
                        }),
                    new BsonDocument("$group",
                        new BsonDocument
                        {
                            { "_id", "$DataJson.FormData.commodity1" },
                            { "soldQty", new BsonDocument("$sum", "$DataJson.FormData.quantityMt2") },
                            { "realisedValue", new BsonDocument("$sum", "$DataJson.FormData.valueInr1") }
                        }),
                    new BsonDocument("$project",
                        new BsonDocument
                        {
                            { "_id", 0 },
                            { "Commodity", new BsonDocument("$toLower", "$_id") },
                            { "RealisedValue", new BsonDocument("$ifNull", new BsonArray { "$realisedValue", 0 }) },
                            { "SoldQty", new BsonDocument("$ifNull", new BsonArray { "$soldQty", 0 }) }
                        })
                };

                var salesDataSet1 = datasetCollection.Aggregate<BsonDocument>(pipelineSalesData1, aggregateOptions).ToList();
                List<salesList1> salesList1 = BsonHelper.ConvertBsonDocumentListToModel<salesList1>(salesDataSet1).ToList();

                List<BsonDocument> pipelineSalesData2 = new List<BsonDocument>
                {
                    new BsonDocument("$match", new BsonDocument
                    {
                        { "DataSourceId", salesFormId },
                        { "CompanyId", CompanyIdString },
                        { "IsArchived", false },
                        { "DataJson.FormData.ImportUniqueId", vesselIdString }
                    }),
                    new BsonDocument("$addFields", new BsonDocument
                    {
                        { "sourceCommodity", new BsonDocument("$toLower", "$DataJson.FormData.sourceCommodity") },
                        { "dateFilter", new BsonDocument("$toDate", "$DataJson.FormData.tradeDate") }
                    }),
                    new BsonDocument("$match", new BsonDocument("dateFilter", new BsonDocument
                    {
                        { "$gte", BsonDateTime.Create(new DateTime(fromYear, fromMonth, fromDay, 0, 0, 0)) },
                        { "$lte", BsonDateTime.Create(new DateTime(toYear, toMonth, toDay, 23, 59, 59)) }

                    })),
                    new BsonDocument("$group", new BsonDocument
                    {
                        { "_id", BsonNull.Value },
                        { "RefiningCost", new BsonDocument("$sum", "$DataJson.FormData.expectedRefiningCostInr1") },
                        { "cpo", new BsonDocument("$sum", "$DataJson.FormData.cpoMt") },
                        { "cpo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.cpoTradingMt") },
                        { "rbd-palm-olein", new BsonDocument("$sum", "$DataJson.FormData.rbdOleinMt") },
                        { "refined-palm-oil", new BsonDocument("$sum", "$DataJson.FormData.rpoMt") },
                        { "stearin", new BsonDocument("$sum", "$DataJson.FormData.stearinMt") },
                        { "soft-stearin", new BsonDocument("$sum", "$DataJson.FormData.softStearinMt") },
                        { "hard-stearin", new BsonDocument("$sum", "$DataJson.FormData.hardStearinMt") },
                        { "pfad", new BsonDocument("$sum", "$DataJson.FormData.pfadMt") },
                        { "white-olein", new BsonDocument("$sum", "$DataJson.FormData.whiteOleinMt") },
                        { "calcium-soap", new BsonDocument("$sum", "$DataJson.FormData.calciumSoapMt") },
                        { "loss", new BsonDocument("$sum", "$DataJson.FormData.lossMt") },
                        { "rbd-palm-olein-trading", new BsonDocument("$sum", "$DataJson.FormData.rbdPalmoleinImportMt") },
                        { "rbd-palm-olein-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.rbdPalmoleinTradingMt") },
                        { "refined-palm-oil-trading", new BsonDocument("$sum", "$DataJson.FormData.rpoMt1") },
                        { "refined-palm-oil-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.rpoMt2") },
                        { "csfo", new BsonDocument("$sum", "$DataJson.FormData.csfoMt") },
                        { "csfo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.csfoTradingMt") },
                        { "rsfo", new BsonDocument("$sum", "$DataJson.FormData.rsfoMt") },
                        { "sunflower-fatty-acid", new BsonDocument("$sum", "$DataJson.FormData.sunflowerFattyAcidMt") },
                        { "rsfo-trading", new BsonDocument("$sum", "$DataJson.FormData.rsfoLocalMt") },
                        { "rsfo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.rsfoTradingMt") },
                        { "crbo", new BsonDocument("$sum", "$DataJson.FormData.crboMt") },
                        { "crbo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.crboTradingMt") },
                        { "rrbo", new BsonDocument("$sum", "$DataJson.FormData.rrboMt") },
                        { "rb-fatty-acid", new BsonDocument("$sum", "$DataJson.FormData.rbFattyAcidMt") },
                        { "rb-oil-wax", new BsonDocument("$sum", "$DataJson.FormData.rbOilWaxMt") },
                        { "rrbo-trading", new BsonDocument("$sum", "$DataJson.FormData.rrboLocalMt") },
                        { "rrbo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.rrboTradingMt") },
                        { "cdsbo", new BsonDocument("$sum", "$DataJson.FormData.cdsboMt") },
                        { "cdsbo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.cdsboTradingMt") },
                        { "rsbo", new BsonDocument("$sum", "$DataJson.FormData.rsboMt") },
                        { "soy-acid-oil", new BsonDocument("$sum", "$DataJson.FormData.soyAcidOilMt") },
                        { "rsbo-trading", new BsonDocument("$sum", "$DataJson.FormData.rsboLocalMt") },
                        { "rsbo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.rsboTradingMt") },
                        { "crude-glycerin", new BsonDocument("$sum", "$DataJson.FormData.crudeGlycerinMt") },
                        { "refined-glycerin", new BsonDocument("$sum", "$DataJson.FormData.refinedGycerinMt") },
                        { "refined-glycerin-trading", new BsonDocument("$sum", "$DataJson.FormData.refinedGlycerinLocalMt1") },
                        { "refined-glycerin-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.refinedGlycerinTradingMt") }
                    }),
                    new BsonDocument("$addFields", new BsonDocument
                    {
                        { "data", new BsonDocument("$map", new BsonDocument
                        {
                            { "input", new BsonDocument("$objectToArray", "$$ROOT") },
                            { "as", "item" },
                            { "in", new BsonDocument
                            {
                                { "k", "$$item.k" },
                                { "v", new BsonDocument("$cond", new BsonDocument
                                {
                                    { "if", new BsonDocument("$gt", new BsonArray { "$$item.v", 0 }) },
                                    { "then", "$$item.v" },
                                    { "else", 0 }
                                })}
                            }}
                        })}
                    }),
                    new BsonDocument("$unwind", "$data"),
                    new BsonDocument("$project", new BsonDocument
                    {
                        { "_id", 0 },
                        { "commodity", "$data.k" },
                        { "quantity", new BsonDocument("$convert", new BsonDocument
                            {
                                { "input", "$data.v" },
                                { "to", "decimal" } // Convert to decimal data type
                            })
                        }
                    })
                };

                var salesDataSet2 = datasetCollection.Aggregate<BsonDocument>(pipelineSalesData2, aggregateOptions).ToList();
                List<salesList2> salesList2 = BsonHelper.ConvertBsonDocumentListToModel<salesList2>(salesDataSet2).ToList();

                var commoditiesList = CommodityGroups[result.SourceCommodity];
                result.Utilization = salesList2.FirstOrDefault(item => item.commodity == result.SourceCommodity.Replace(" ", "-").ToLower())?.quantity ?? 0;

                List<BsonDocument> pipelineSalesData3 = new List<BsonDocument>
                {
                    new BsonDocument("$match",
                        new BsonDocument
                        {
                            { "DataSourceId", dailyRatesFormId },
                            { "IsArchived", false },
                            { "DataJson.FormData.commodity1",new BsonDocument("$nin",new BsonArray{BsonNull.Value,""}) },
                        }
                    ),
                    new BsonDocument("$addFields",
                        new BsonDocument
                        {
                            { "productGroup", new BsonDocument("$toLower", "$DataJson.FormData.productGroup") },
                            { "location", new BsonDocument("$toLower", "$DataJson.FormData.location") },
                            { "date", new BsonDocument("$toDate", "$DataJson.FormData.entryDate") }
                        }
                    ),
                    new BsonDocument("$match",
                        new BsonDocument
                        {
                            { "productGroup", result.ProductGroup.ToLower() },
                            { "location", location },
                            { "date", new BsonDocument("$lte", BsonDateTime.Create(new DateTime(toYear, toMonth, toDay, 23, 59, 59))) }
                        }
                    ),
                    new BsonDocument("$sort",
                        new BsonDocument("date", -1)
                    ),
                    new BsonDocument("$group",
                        new BsonDocument
                        {
                            { "_id", "$DataJson.FormData.commodity1" },
                            { "MTMRate", new BsonDocument("$first", "$DataJson.FormData.rateInr") },
                            { "USDToInr", new BsonDocument("$first", "$DataJson.FormData.usdToInr") }
                        }
                    ),
                    new BsonDocument("$project",
                        new BsonDocument
                        {
                            { "_id", 0 },
                            { "Commodity", new BsonDocument("$toLower", "$_id") },
                            { "MTMRate", new BsonDocument("$ifNull", new BsonArray { "$MTMRate", 0 }) },
                            { "USDToInr", new BsonDocument("$ifNull", new BsonArray { "$USDToInr", 0 }) }
                        }
                    )
                };
                var salesDataSet3 = datasetCollection.Aggregate<BsonDocument>(pipelineSalesData3, aggregateOptions).ToList();
                List<salesList3> salesList3 = BsonHelper.ConvertBsonDocumentListToModel<salesList3>(salesDataSet3).ToList();

                List<BsonDocument> pipelineSalesData4 = new List<BsonDocument>
                {
                    new BsonDocument("$match",
                        new BsonDocument
                        {
                            { "DataSourceId", salesFormId },
                            { "CompanyId", CompanyIdString},
                            { "IsArchived", false },
                            { "DataJson.FormData.ImportUniqueId", vesselIdString },
                            { "DataJson.FormData.consumptionCommodity", new BsonDocument("$nin", new BsonArray { BsonNull.Value, "" , " "}) }
                        }),
                    new BsonDocument("$addFields",
                        new BsonDocument
                        {
                            { "sourceCommodity", new BsonDocument("$toLower", "$DataJson.FormData.sourceCommodity") },
                            { "dateFilter", new BsonDocument("$toDate", "$DataJson.FormData.tradeDate") }
                        }),
                    new BsonDocument("$match",
                        new BsonDocument
                        {
                            { "sourceCommodity", result.SourceCommodity.ToLower() },
                            { "dateFilter",
                                new BsonDocument
                                {
                                    { "$gte", BsonDateTime.Create(new DateTime(fromYear, fromMonth, fromDay, 0, 0, 0)) },
                                    { "$lte", BsonDateTime.Create(new DateTime(toYear, toMonth, toDay, 23, 59, 59)) }
                                }
                            }
                        }),
                    new BsonDocument("$group",
                        new BsonDocument
                        {
                            { "_id", "$DataJson.FormData.consumptionCommodity" },
                            { "soldQty", new BsonDocument("$sum", "$DataJson.FormData.consumedQuantityMt") },
                        }),
                    new BsonDocument("$project",
                        new BsonDocument
                        {
                            { "_id", 0 },
                            { "Commodity", new BsonDocument("$toLower", "$_id") },
                            { "ConsumedQty", new BsonDocument("$ifNull", new BsonArray { "$soldQty", 0 }) }
                        })
                };

                var salesDataSet4 = datasetCollection.Aggregate<BsonDocument>(pipelineSalesData4, aggregateOptions).ToList();
                List<salesList1> salesList4 = BsonHelper.ConvertBsonDocumentListToModel<salesList1>(salesDataSet4).ToList();

                foreach (var record in commoditiesList)
                {
                    ProductionDataModel dataRecord = new ProductionDataModel
                    {
                        ProducedCommodity = record.DisplayName,
                        ProducedQuantity = record.NameLower == result.SourceCommodity.ToLower() ? 0 : salesList2.FirstOrDefault(item => item.commodity == record.NameKey)?.quantity ?? 0,
                        SoldQuantity = (-1) * (salesList1.FirstOrDefault(item => item.Commodity == record.NameLower)?.SoldQty ?? 0
                                       + salesList4.FirstOrDefault(item => item.Commodity == record.NameLower)?.ConsumedQty ?? 0),
                        RealisedValue = salesList1.FirstOrDefault(item => item.Commodity == record.NameLower)?.RealisedValue ?? 0,
                        MTMRate = salesList3.FirstOrDefault(item => item.Commodity == record.NameLower)?.MTMRate ?? 0,
                        Order = record.Order
                    };
                    dataRecord.AvailableBalance = record.Name == result.SourceCommodity ?
                                                   (finalQty - result.Utilization)
                                                  : (dataRecord.ProducedQuantity + dataRecord.SoldQuantity);
                    dataRecord.UnRealisedValue = dataRecord.AvailableBalance * dataRecord.MTMRate;

                    productionList.Add(dataRecord);
                }

                var totalRecord = new ProductionDataModel
                {
                    ProducedCommodity = "Total",
                    ProducedQuantity = productionList.Sum(x => x.ProducedQuantity),
                    SoldQuantity = productionList.Sum(x => x.SoldQuantity),
                    RealisedValue = productionList.Sum(x => x.RealisedValue),
                    AvailableBalance = productionList.Sum(x => x.AvailableBalance),
                    UnRealisedValue = productionList.Sum(x => x.UnRealisedValue),
                    Order = productionList.Max(x => x.Order) + 1
                };
                productionList.Add(totalRecord);

                List<BsonDocument> pipelinePandL1 = new List<BsonDocument>
                {
                    new BsonDocument("$match", new BsonDocument
                    {
                        { "DataSourceId", customsDutyFormId },
                        { "CompanyId", CompanyIdString },
                        { "IsArchived", false },
                        { "DataJson.FormData.selectSourceContract",  vesselIdString }
                    }),
                    new BsonDocument("$addFields", new BsonDocument
                    {
                        { "date", new BsonDocument("$toDate", "$DataJson.FormData.entryDate") }
                    }),
                    new BsonDocument("$match", new BsonDocument
                    {
                        { "date", new BsonDocument("$lte", BsonDateTime.Create(new DateTime(toYear, toMonth, toDay, 23, 59, 59))) }
                    }),
                    new BsonDocument("$sort", new BsonDocument
                    {
                        { "date", -1 }
                    }),
                    new BsonDocument("$limit", 1),
                    new BsonDocument("$project", new BsonDocument
                    {
                        { "_id", 0 },
                        { "DutyInr", new BsonDocument("$ifNull", new BsonArray
                            {
                                "$DataJson.FormData.totalPaidDutyInclIgstValueInr", 0
                            })
                        },
                        { "DutyQty", new BsonDocument("$ifNull", new BsonArray
                            {
                                "$DataJson.FormData.totalUnpaidDutyQuantityMt", 0
                            })
                        }
                    })
                };
                var profitandloss1 = datasetCollection.Aggregate<BsonDocument>(pipelinePandL1, aggregateOptions).FirstOrDefault();
                decimal customsDutyInr = profitandloss1 == null ? 0 : profitandloss1.TryGetValue("DutyInr", out BsonValue customsDutyInrValue) &&
                                                  customsDutyInrValue.RawValue != null ? customsDutyInrValue.ToDecimal() : 0;
                decimal customsDutyQty = profitandloss1 == null ? 0 : profitandloss1.TryGetValue("DutyQty", out BsonValue customsDutyQtyValue) &&
                                                  customsDutyQtyValue.RawValue != null ? customsDutyQtyValue.ToDecimal() : 0;

                List<BsonDocument> pipelinePandL2 = new List<BsonDocument>
                {
                    new BsonDocument("$match", new BsonDocument
                    {
                        { "DataSourceId", dutyFormId },
                        { "IsArchived", false },
                        { "DataJson.FormData.commodity" ,result.SourceCommodity }
                    }),
                    new BsonDocument("$addFields", new BsonDocument
                    {
                        { "date", new BsonDocument("$toDate", "$DataJson.FormData.startDate") }
                    }),
                    new BsonDocument("$match", new BsonDocument
                    {
                        { "date", new BsonDocument("$lte", BsonDateTime.Create(new DateTime(toYear, toMonth, toDay, 23, 59, 59))) }
                    }),
                    new BsonDocument("$sort", new BsonDocument
                    {
                        { "date", -1 }
                    }),
                    new BsonDocument("$limit", 1),
                    new BsonDocument("$project", new BsonDocument
                    {
                        { "_id", 0 },
                        { "InrCustomsDutyPerMt", new BsonDocument("$ifNull", new BsonArray
                            {
                                "$DataJson.FormData.inrCustomsDutyPerMt",
                                0
                            })
                        }
                    })
                };
                var profitandloss2 = datasetCollection.Aggregate<BsonDocument>(pipelinePandL2, aggregateOptions).FirstOrDefault();
                decimal _InrCustomsDutyPerMt = profitandloss2 == null ? 0 : profitandloss2.TryGetValue("InrCustomsDutyPerMt", out BsonValue inrCustomsDutyPerMtValue) &&
                                                   inrCustomsDutyPerMtValue.RawValue != null ? inrCustomsDutyPerMtValue.ToDecimal() : 0;
                decimal _USDToInr = salesList3.FirstOrDefault(item => item.Commodity == result.SourceCommodity.ToLower())?.USDToInr ?? 0;

                List<BsonDocument> pipelinePandL3 = new List<BsonDocument>
                {
                    new BsonDocument("$match", new BsonDocument
                    {
                        { "DataJson.FormData.sourceContract", vesselIdString },
                        { "DataJson.FormData.location", subLocation },
                        { "DataSourceId", fxPaymentsFormId },
                        { "IsArchived", false },
                    }),
                    new BsonDocument("$addFields", new BsonDocument
                    {
                        { "date", new BsonDocument("$toDate", "$DataJson.FormData.entryDate") },
                        { "location", new BsonDocument("$toLower", "$DataJson.FormData.location") }
                    }),
                    new BsonDocument("$match", new BsonDocument
                    {
                        { "location", subLocation.ToLower() },
                        { "date", new BsonDocument("$lte", BsonDateTime.Create(new DateTime(toYear, toMonth, toDay, 23, 59, 59))) }
                    }),
                    new BsonDocument("$sort", new BsonDocument
                    {
                        { "date", -1 }
                    }),
                    new BsonDocument("$limit", 1),
                    new BsonDocument("$project", new BsonDocument { { "_id", 0 },
                        { "FxSettledUsd", "$DataJson.FormData.totalFxSettledValueInInr" },
                        { "FxContractUsd", "$DataJson.FormData.fxValuePendingRemittance" }
                    }),
                };
                var profitandloss3 = datasetCollection.Aggregate<BsonDocument>(pipelinePandL3, aggregateOptions).FirstOrDefault();
                decimal fxPaymentSettledUsd = profitandloss3 == null ? 0 : profitandloss3.TryGetValue("FxSettledUsd", out BsonValue fxPaymentSettledUsdValue) &&
                                                   fxPaymentSettledUsdValue.RawValue != null ? fxPaymentSettledUsdValue.ToDecimal() : 0;
                decimal fxPendingRemittance = profitandloss3 == null ? 0 : profitandloss3.TryGetValue("FxContractUsd", out BsonValue fxPaymentContractUsdValue) &&
                                                   fxPaymentContractUsdValue.RawValue != null ? fxPaymentContractUsdValue.ToDecimal() : 0;

                List<BsonDocument> pipelinePandL4 = new List<BsonDocument>
                {
                    new BsonDocument("$match", new BsonDocument
                    {
                        { "DataSourceId", locationMasterFormId },
                        { "IsArchived", false },
                        { "$expr", new BsonDocument
                            {
                                { "$eq", new BsonArray
                                    {
                                        new BsonDocument("$toLower", "$DataJson.FormData.location"),
                                        subLocation.ToLower()
                                    }
                                }
                            }
                        }
                    }),
                    new BsonDocument("$addFields", new BsonDocument
                    {
                        { "date", new BsonDocument("$toDate", "$DataJson.FormData.date") },
                    }),
                    new BsonDocument("$sort", new BsonDocument
                    {
                        { "date", -1 }
                    }),
                    new BsonDocument("$project", new BsonDocument
                    {
                        { "_id", 0 },
                        { "RefiningCost", new BsonDocument("$ifNull", new BsonArray
                            {
                                "$DataJson.FormData.refiningCost",
                                0
                            })
                        },
                        { "CnfCharges", new BsonDocument("$ifNull", new BsonArray
                            {
                                "$DataJson.FormData.cnfCharges",
                                0
                            })
                        }
                    })
                };
                var profitandloss4 = datasetCollection.Aggregate<BsonDocument>(pipelinePandL4, aggregateOptions).FirstOrDefault();
                decimal refiningCost = profitandloss4 == null ? 0 : profitandloss4.TryGetValue("RefiningCost", out BsonValue refiningCostValue) &&
                                                   refiningCostValue.RawValue != null ? refiningCostValue.ToDecimal() : 0;
                decimal cnfCharges = profitandloss4 == null ? 0 : profitandloss4.TryGetValue("CnfCharges", out BsonValue cnfChargesValue) &&
                                                   cnfChargesValue.RawValue != null ? cnfChargesValue.ToDecimal() : 0;

                var _PandLList = CommodityGroups["PAndL"];

                foreach (var record in _PandLList)
                {
                    ProfitAndLossModel dataRecord = new ProfitAndLossModel();
                    decimal test = profitandlossList.Sum(x => x.RealisedCostYTD);
                    decimal realisedPandL = totalRecord.RealisedValue + profitandlossList.Sum(x => x.RealisedCostYTD);
                    decimal unRealisedPandL = totalRecord.UnRealisedValue + profitandlossList.Sum(x => x.UnRealisedCost);

                    if (!(inputModel?.ProductType?.ToLower() == "local"))
                    {
                        if (record.Name == "DUTY")
                        {
                            dataRecord.Cost = record.DisplayName;
                            dataRecord.RealisedCostYTD = (customsDutyInr + (customsDutyQty * _InrCustomsDutyPerMt))
                                   * (result.TotalSotQuantity == 0 ? 0 : (totalRecord.SoldQuantity / result.TotalSotQuantity));
                            dataRecord.UnRealisedCost = (-1) * ((customsDutyInr + (customsDutyQty * _InrCustomsDutyPerMt))
                                   * (result.TotalSotQuantity == 0 ? 0 : (totalRecord.AvailableBalance / result.TotalSotQuantity)));
                            dataRecord.MtmRate = _InrCustomsDutyPerMt;
                        }
                        else if (record.Name == "FX-PAYMENT-PURCHASE")
                        {
                            dataRecord.Cost = record.DisplayName;
                            dataRecord.RealisedCostYTD = (fxPaymentSettledUsd + (fxPendingRemittance * _USDToInr))
                                         * (result.TotalSotQuantity == 0 ? 0 : (totalRecord.SoldQuantity / result.TotalSotQuantity));
                            dataRecord.UnRealisedCost = (-1) * ((fxPaymentSettledUsd + (fxPendingRemittance * _USDToInr))
                                         * (result.TotalSotQuantity == 0 ? 0 : (totalRecord.AvailableBalance / result.TotalSotQuantity)));
                            dataRecord.MtmRate = _USDToInr;
                        }
                        else if (record.Name == "CNF-CHARGES")
                        {
                            dataRecord.Cost = record.DisplayName;
                            //dataRecord.RealisedCostYTD = totalRecord.SoldQuantity * cnfCharges;
                            //dataRecord.UnRealisedCost = totalRecord.AvailableBalance * refiningCost;
                            dataRecord.UnRealisedCost = (-1) * cnfCharges * (finalQty - result.Utilization);
                        }
                    }

                    if (record.Name == "REFINING-COST")
                    {
                        dataRecord.Cost = record.DisplayName;
                        dataRecord.RealisedCostYTD = (-1) * salesList2.FirstOrDefault(item => item.commodity == "RefiningCost")?.quantity ?? 0;
                    }
                    else if (record.Name == "PAYMENT-PURCHASE" && inputModel?.ProductType?.ToLower() == "local")
                    {
                        dataRecord.Cost = record.DisplayName;
                        dataRecord.RealisedCostYTD = (totalRecord.SoldQuantity / result.TotalContractQuantity) * valueInr;
                        dataRecord.UnRealisedCost = (-1) * (totalRecord.AvailableBalance / result.TotalContractQuantity) * valueInr;
                    }
                    else if (record.Name == "P&L-INR")
                    {
                        dataRecord.Cost = record.DisplayName;
                        dataRecord.RealisedCostYTD = realisedPandL;
                        dataRecord.UnRealisedCost = unRealisedPandL;
                        dataRecord.IsBold = true;
                        result.PandLINR = realisedPandL + unRealisedPandL;
                    }
                    //else
                    //{
                    //    dataRecord.Cost = record.DisplayName;
                    //    dataRecord.IsBackground = true;
                    //}
                    else if (record.Name == "P&L-USD")
                    {
                        dataRecord.Cost = record.DisplayName;
                        dataRecord.RealisedCostYTD = _USDToInr == 0 ? 0 : ((profitandlossList.FirstOrDefault(x => x.Cost == "P&L (INR)")?.RealisedCostYTD ?? 0) / _USDToInr);
                        dataRecord.UnRealisedCost = _USDToInr == 0 ? 0 : ((profitandlossList.FirstOrDefault(x => x.Cost == "P&L (INR)")?.UnRealisedCost ?? 0) / _USDToInr);
                        dataRecord.IsBold = true;
                        result.PandLUSD = dataRecord.RealisedCostYTD + dataRecord.UnRealisedCost;
                        result.PandLRealisedUSD = dataRecord.RealisedCostYTD;
                        result.PandLUnRealisedUSD = dataRecord.UnRealisedCost;
                    }
                    dataRecord.TotalPAndL = dataRecord.RealisedCostYTD + dataRecord.UnRealisedCost + dataRecord.MtmRate;
                    if (!string.IsNullOrWhiteSpace(dataRecord.Cost))
                        profitandlossList.Add(dataRecord);
                }

                result.Productions = productionList;
                result.ProfitAndLosses = profitandlossList;
            }

            return result;
        }

        public List<PositionData> GetPositionsDashboard(PositionsDashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPositionsDashboard", "DashboardRepositoryNew"));
            List<PositionData> positionDataList = new List<PositionData>();
            IMongoCollection<DataSetOutputModel> datasetCollection = GetMongoCollectionObject<DataSetOutputModel>(MongoDBCollectionConstants.DataSet);
            IMongoCollection<DataSetOutputModel> yTDPandLHistoryCollection = GetMongoCollectionObject<DataSetOutputModel>(MongoDBCollectionConstants.YTDPandLHistory);
            var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };

            DateTime fromDate = inputModel.FromDate ?? DateTime.UtcNow;
            DateTime toDate = inputModel.Todate ?? DateTime.UtcNow;
            DateTime toDate1 = toDate;
            int fromDay = fromDate.Day;
            int fromMonth = fromDate.Month;
            int fromYear = fromDate.Year;
            int toMonth = toDate.Month;
            int toYear = toDate.Year;
            toDate = new DateTime(toYear, toMonth, 1).AddMonths(1).AddDays(-1);
            int toDay = toDate.Day;
            string openingBalanceFormId = OpeningBalanceFormId.ToLower();
            var monthsList = new List<MonthYearOrder>();
            List<string> purchageFormIds = new List<string>(PurchaseFormIds.Values);
            List<string> salesFormIds = new List<string>(SalesFormIds.Values);
            List<string> dutyFormIds = new List<string>(CustomsDutyFormIds.Values);
            PurchaseFormIds.TryGetValue("Umiro-INDIA", out string umiroPurchageFormId);
            SalesFormIds.TryGetValue("Umiro-INDIA", out string umiroSalesFormId);
            umiroPurchageFormId = umiroPurchageFormId.ToLower();
            umiroSalesFormId = umiroSalesFormId.ToLower();
            DateTime featureFromDate = toDate.AddDays(1);
            DateTime featureToDate = featureFromDate.AddMonths(8).AddDays(-1);
            int featureFromMonth = featureFromDate.Month;
            int featureFromYear = featureFromDate.Year;
            int featureToMonth = featureToDate.Month;
            int featureToYear = featureToDate.Year;
            int featureToDay = featureToDate.Day;
            int todayYear = toDate1.Year;
            int todayMonth = toDate1.Month;
            int todayDay = toDate1.Day;
            int previousYear = toDate1.AddDays(-1).Year;
            int previousMonth = toDate1.AddDays(-1).Month;
            int previousDay = toDate1.AddDays(-1).Day;
            int pastYear = toDate.AddMonths(-1).Year;
            int pastMonth = toDate.AddMonths(-1).Month;
            int pastDay = toDate.AddMonths(-1).Day;
            string dailyRatesFormId = DailyRatesFormId.ToLower();

            for (int i = 1; i <= 7; i++)
            {
                var nextDate = toDate.AddMonths(i);
                var monthYearOrder = new MonthYearOrder
                {
                    Month = nextDate.Month,
                    Year = nextDate.Year,
                    Order = i
                };
                monthsList.Add(monthYearOrder);
            }

            List<BsonDocument> pipeline1 = new List<BsonDocument>
            {
                new BsonDocument("$match", new BsonDocument
                {
                    { "DataSourceId", openingBalanceFormId },
                    { "IsArchived", false }
                }),
                new BsonDocument("$project", new BsonDocument
                {
                    { "_id", 0 },
                    { "CompanyName", "$DataJson.FormData.entity" },
                    { "Commodity", "$DataJson.FormData.commodity" },
                    { "OpeningBalance", new BsonDocument("$ifNull", new BsonArray
                        {
                            "$DataJson.FormData.openingQuantityMt",
                            0
                        })
                    },
                    { "SGOpeningBalance", new BsonDocument("$ifNull", new BsonArray
                        {
                            "$DataJson.FormData.ytdPricedWithAaaMt",
                            0
                        })
                    }
                })
            };
            var positionSet1 = datasetCollection.Aggregate<BsonDocument>(pipeline1, aggregateOptions).ToList();
            List<PositionList1> positionList1 = BsonHelper.ConvertBsonDocumentListToModel<PositionList1>(positionSet1).ToList();

            List<BsonDocument> pipeline2 = new List<BsonDocument>
            {
                new BsonDocument("$match",
                    new BsonDocument
                    {
                        { "DataSourceId", new BsonDocument("$in", new BsonArray(purchageFormIds)) },
                        { "IsArchived", false }
                    }),
                new BsonDocument("$addFields",
                    new BsonDocument
                    {
                        { "Source", "$DataJson.FormData.commodity" },
                        { "TotalQty", new BsonDocument("$ifNull", new BsonArray
                            {
                                "$DataJson.FormData.netPurchasesSinceJan2023",
                                0
                            })
                        },
                        { "dateFilter",
                            new BsonDocument("$dateFromString",
                                new BsonDocument
                                {
                                    { "dateString", new BsonDocument("$ifNull", new BsonArray { "$DataJson.FormData.deliveryPeriod", "0" }) },
                                    { "onError",
                                        new BsonDocument("$dateFromString",
                                            new BsonDocument
                                            {
                                                { "dateString", "$DataJson.FormData.contractDate" },
                                                { "onError", BsonNull.Value }
                                            }
                                        )
                                    }
                                }
                            )
                        },
                        { "CompanyName",
                            new BsonDocument("$cond",
                                new BsonDocument
                                {
                                    { "if", new BsonDocument("$eq", new BsonArray
                                        {
                                            "$DataSourceId",
                                            umiroPurchageFormId
                                        })
                                    },
                                    { "then", "UMIRO-INDIA" },
                                    { "else", "ANA-INDIA" }
                                })
                        }
                    }),
                new BsonDocument("$match",
                    new BsonDocument
                    {
                        { "Source", new BsonDocument("$nin", new BsonArray
                            {
                                "",
                                BsonNull.Value,
                                " "
                            })
                        },
                        { "dateFilter", new BsonDocument("$gte", new DateTime(fromYear, fromMonth, fromDay))
                                             .Add("$lte", new DateTime(toYear, toMonth, toDay, 23, 59, 59))
                        }
                    }
                ),
                new BsonDocument("$group",
                    new BsonDocument
                    {
                        { "_id", new BsonDocument
                            {
                                { "Company", "$CompanyName" },
                                { "Source", "$Source" }
                            }
                        },
                        { "TotalQty", new BsonDocument("$sum", "$TotalQty") },
                    }
                ),
                new BsonDocument("$project",
                    new BsonDocument
                    {
                        { "_id", 0 },
                        { "CompanyName", "$_id.Company" },
                        { "Commodity", "$_id.Source" },
                        { "TotalQty", new BsonDocument("$round", new BsonArray { "$TotalQty", 4 }) },
                    }
                )
            };
            var positionSet2 = datasetCollection.Aggregate<BsonDocument>(pipeline2, aggregateOptions).ToList();
            List<PositionList2> positionList2 = BsonHelper.ConvertBsonDocumentListToModel<PositionList2>(positionSet2).ToList();

            List<BsonDocument> pipeline3 = new List<BsonDocument>
            {
                new BsonDocument("$match",
                    new BsonDocument
                    {
                        { "DataSourceId", new BsonDocument("$in", new BsonArray(purchageFormIds)) },
                        { "IsArchived", false }
                    }),
                new BsonDocument("$addFields",
                    new BsonDocument
                    {
                        { "Source", "$DataJson.FormData.commodity" },
                        { "TotalQty", new BsonDocument("$ifNull", new BsonArray
                            {
                                "$DataJson.FormData.netPurchasesSinceJan2023",
                                0
                            })
                        },
                        { "dateFilter",
                            new BsonDocument("$dateFromString",
                                new BsonDocument
                                {
                                    { "dateString", new BsonDocument("$ifNull", new BsonArray { "$DataJson.FormData.deliveryPeriod", "0" }) },
                                    { "onError",
                                        new BsonDocument("$dateFromString",
                                            new BsonDocument
                                            {
                                                { "dateString", "$DataJson.FormData.contractDate" },
                                                { "onError", BsonNull.Value }
                                            }
                                        )
                                    }
                                }
                            )
                        },
                        { "CompanyName",
                            new BsonDocument("$cond",
                                new BsonDocument
                                {
                                    { "if", new BsonDocument("$eq", new BsonArray
                                        {
                                            "$DataSourceId",
                                            umiroPurchageFormId
                                        })
                                    },
                                    { "then", "UMIRO-INDIA" },
                                    { "else", "ANA-INDIA" }
                                })
                        }
                    }),
                new BsonDocument("$match",
                    new BsonDocument
                    {
                        { "Source", new BsonDocument("$nin", new BsonArray
                            {
                                "",
                                BsonNull.Value,
                                " "
                            })
                        },
                        { "dateFilter", new BsonDocument("$gte", new DateTime(featureFromYear, featureFromMonth , 1))
                                             .Add("$lte", new DateTime(featureToYear, featureToMonth, featureToDay, 23, 59, 59))
                        }
                    }
                ),
                new BsonDocument("$addFields",
                    new BsonDocument
                    {
                        {
                            "Year", new BsonDocument("$year", "$dateFilter")
                        },
                        {
                            "Month", new BsonDocument("$month", "$dateFilter")
                        }
                    }
                ),
                new BsonDocument("$group",
                    new BsonDocument
                    {
                        { "_id", new BsonDocument
                            {
                                { "Company", "$CompanyName" },
                                { "Source", "$Source" },
                                { "Year", "$Year" },
                                { "Month", "$Month" }
                            }
                        },
                        { "TotalQty", new BsonDocument("$sum", "$TotalQty") }
                    }
                ),
                new BsonDocument("$project",
                    new BsonDocument
                    {
                        { "_id", 0 },
                        { "CompanyName", "$_id.Company" },
                        { "Commodity", "$_id.Source" },
                        { "Year", "$_id.Year" },
                        { "Month", "$_id.Month" },
                        { "TotalQty", new BsonDocument("$round", new BsonArray { "$TotalQty", 4 }) }
                    }
                )
            };
            var positionSet3 = datasetCollection.Aggregate<BsonDocument>(pipeline3, aggregateOptions).ToList();
            List<PositionList2> positionList3 = BsonHelper.ConvertBsonDocumentListToModel<PositionList2>(positionSet2).ToList();

            List<BsonDocument> pipeline4 = new List<BsonDocument>
            {
                new BsonDocument("$match",
                    new BsonDocument
                    {
                        { "DataSourceId", new BsonDocument("$in", new BsonArray(salesFormIds)) },
                        { "IsArchived", false },
                    }),
                new BsonDocument("$addFields",
                    new BsonDocument
                    {
                        { "ParentCommodity", new BsonDocument("$toLower", "$DataJson.FormData.sourceCommodity") },
                        { "Source", "$DataJson.FormData.commodity1" },
                        { "TotalQty", new BsonDocument("$ifNull", new BsonArray
                            {
                                "$DataJson.FormData.quantityMt2",
                                0
                            })
                        },
                        { "RealisedValue", new BsonDocument("$ifNull", new BsonArray
                            {
                                "$DataJson.FormData.valueInr1",
                                0
                            })
                        },
                        { "dateFilter",
                            new BsonDocument("$dateFromString",
                                new BsonDocument
                                {
                                    { "dateString", new BsonDocument("$ifNull", new BsonArray { "$DataJson.FormData.deliveryStartDate", "0" }) },
                                    { "onError",
                                        new BsonDocument("$dateFromString",
                                            new BsonDocument
                                            {
                                                { "dateString", "$DataJson.FormData.tradeDate" },
                                                { "onError", BsonNull.Value }
                                            }
                                        )
                                    }
                                }
                            )
                        },
                        { "CompanyName",
                            new BsonDocument("$cond",
                                new BsonDocument
                                {
                                    { "if", new BsonDocument("$eq", new BsonArray
                                        {
                                            "$DataSourceId",
                                            umiroSalesFormId
                                        })
                                    },
                                    { "then", "UMIRO-INDIA" },
                                    { "else", "ANA-INDIA" }
                                })
                        }
                    }),
                new BsonDocument("$match",
                    new BsonDocument
                    {
                        { "Source", new BsonDocument("$nin", new BsonArray
                            {
                                "",
                                BsonNull.Value,
                                " "
                            })
                        },
                        { "dateFilter", new BsonDocument("$gte", new DateTime(fromYear, fromMonth, fromDay))
                                             .Add("$lte", new DateTime(toYear, toMonth, toDay, 23, 59, 59))
                        }
                    }
                ),
                new BsonDocument("$group",
                    new BsonDocument
                    {
                        { "_id", new BsonDocument
                            {
                                { "Company", "$CompanyName" },
                                { "Source", "$Source" },
                                { "ParentCommodity", "$ParentCommodity" }
                            }
                        },
                        { "TotalQty", new BsonDocument("$sum", "$TotalQty") },
                        { "TodayTotalQty", new BsonDocument("$sum", new BsonDocument
                        {
                            { "$cond", new BsonArray
                                {
                                    new BsonDocument("$and", new BsonArray
                                        {
                                            new BsonDocument("$gte", new BsonArray { new BsonDocument("$year", "$dateFilter"), todayYear }),
                                            new BsonDocument("$gte", new BsonArray { new BsonDocument("$month", "$dateFilter"), todayMonth }),
                                            new BsonDocument("$gte", new BsonArray { new BsonDocument("$dayOfMonth", "$dateFilter"), todayDay })
                                        }),
                                    "$TotalQty",
                                    0
                                }
                            } })
                        }
                    }
                ),
                new BsonDocument("$project",
                    new BsonDocument
                    {
                        { "_id", 0 },
                        { "CompanyName", "$_id.Company" },
                        { "Commodity", "$_id.Source" },
                        { "ParentCommodity", "$_id.ParentCommodity" },
                        { "TotalQty", new BsonDocument("$round", new BsonArray { "$TotalQty", 4 }) },
                        { "TodayTotalQty", new BsonDocument("$round", new BsonArray { "$TodayTotalQty", 4 }) },
                    }
                )
            };
            var positionSet4 = datasetCollection.Aggregate<BsonDocument>(pipeline4, aggregateOptions).ToList();
            List<PositionList3> positionList4 = BsonHelper.ConvertBsonDocumentListToModel<PositionList3>(positionSet4).ToList();

            List<BsonDocument> pipeline5 = new List<BsonDocument>
            {
                new BsonDocument("$match",
                    new BsonDocument
                    {
                        { "DataSourceId", new BsonDocument("$in", new BsonArray(salesFormIds)) },
                        { "IsArchived", false }
                    }),
                new BsonDocument("$addFields",
                    new BsonDocument
                    {
                        { "ParentCommodity", new BsonDocument("$toLower", "$DataJson.FormData.sourceCommodity") },
                        { "Source", "$DataJson.FormData.commodity1" },
                        { "TotalQty", new BsonDocument("$ifNull", new BsonArray
                            {
                                "$DataJson.FormData.quantityMt2",
                                0
                            })
                        },
                        { "RealisedValue", new BsonDocument("$ifNull", new BsonArray
                            {
                                "$DataJson.FormData.valueInr1",
                                0
                            })
                        },
                        { "dateFilter",
                            new BsonDocument("$dateFromString",
                                new BsonDocument
                                {
                                    { "dateString", new BsonDocument("$ifNull", new BsonArray { "$DataJson.FormData.deliveryStartDate", "0" }) },
                                    { "onError",
                                        new BsonDocument("$dateFromString",
                                            new BsonDocument
                                            {
                                                { "dateString", "$DataJson.FormData.tradeDate" },
                                                { "onError", BsonNull.Value }
                                            }
                                        )
                                    }
                                }
                            )
                        },
                        { "CompanyName",
                            new BsonDocument("$cond",
                                new BsonDocument
                                {
                                    { "if", new BsonDocument("$eq", new BsonArray
                                        {
                                            "$DataSourceId",
                                            umiroSalesFormId
                                        })
                                    },
                                    { "then", "UMIRO-INDIA" },
                                    { "else", "ANA-INDIA" }
                                })
                        }
                    }),
                new BsonDocument("$match",
                    new BsonDocument
                    {
                        { "Source", new BsonDocument("$nin", new BsonArray
                            {
                                "",
                                BsonNull.Value,
                                " "
                            })
                        },
                        { "dateFilter", new BsonDocument("$gte", new DateTime(featureFromYear, featureFromMonth , 1))
                                             .Add("$lte", new DateTime(featureToYear, featureToMonth, featureToDay, 23, 59, 59))
                        }
                    }
                ),
                new BsonDocument("$addFields",
                    new BsonDocument
                    {
                        {
                            "Year", new BsonDocument("$year", "$dateFilter")
                        },
                        {
                            "Month", new BsonDocument("$month", "$dateFilter")
                        }
                    }
                ),
                new BsonDocument("$group",
                    new BsonDocument
                    {
                        { "_id", new BsonDocument
                            {
                                { "ParentCommodity", "$ParentCommodity" },
                                { "Company", "$CompanyName" },
                                { "Source", "$Source" },
                                { "Year", "$Year" },
                                { "Month", "$Month" }
                            }
                        },
                        { "TotalQty", new BsonDocument("$sum", "$TotalQty") },
                        { "RealisedValue", new BsonDocument("$sum", "$RealisedValue") },
                    }
                ),
                new BsonDocument("$project",
                    new BsonDocument
                    {
                        { "_id", 0 },
                        { "CompanyName", "$_id.Company" },
                        { "Commodity", "$_id.Source" },
                        { "ParentCommodity", "$_id.ParentCommodity" },
                        { "Year", "$_id.Year" },
                        { "Month", "$_id.Month" },
                        { "TotalQty", 1 },
                        { "RealisedValue", 1 },
                    }
                )
            };
            var positionSet5 = datasetCollection.Aggregate<BsonDocument>(pipeline5, aggregateOptions).ToList();
            List<PositionList3> positionList5 = BsonHelper.ConvertBsonDocumentListToModel<PositionList3>(positionSet5).ToList();

            List<BsonDocument> pipeline6 = new List<BsonDocument>
            {
                new BsonDocument("$match",
                    new BsonDocument
                    {
                        { "DataSourceId", new BsonDocument("$in", new BsonArray(salesFormIds)) },
                        { "IsArchived", false }
                    }),
                new BsonDocument("$addFields",
                    new BsonDocument
                    {
                        { "ParentCommodity", new BsonDocument("$toLower", "$DataJson.FormData.sourceCommodity") },
                        { "Source", "$DataJson.FormData.consumptionCommodity" },
                        { "TotalQty", new BsonDocument("$ifNull", new BsonArray
                            {
                                "$DataJson.FormData.consumedQuantityMt",
                                0
                            })
                        },
                        { "dateFilter",
                            new BsonDocument("$dateFromString",
                                new BsonDocument
                                {
                                    { "dateString", new BsonDocument("$ifNull", new BsonArray { "$DataJson.FormData.deliveryStartDate", "0" }) },
                                    { "onError",
                                        new BsonDocument("$dateFromString",
                                            new BsonDocument
                                            {
                                                { "dateString", "$DataJson.FormData.tradeDate" },
                                                { "onError", BsonNull.Value }
                                            }
                                        )
                                    }
                                }
                            )
                        },
                        { "CompanyName",
                            new BsonDocument("$cond",
                                new BsonDocument
                                {
                                    { "if", new BsonDocument("$eq", new BsonArray
                                        {
                                            "$DataSourceId",
                                            umiroSalesFormId
                                        })
                                    },
                                    { "then", "UMIRO-INDIA" },
                                    { "else", "ANA-INDIA" }
                                })
                        }
                    }),
                new BsonDocument("$match",
                    new BsonDocument
                    {
                        { "Source", new BsonDocument("$nin", new BsonArray
                            {
                                "",
                                BsonNull.Value,
                                " "
                            })
                        },
                        { "dateFilter", new BsonDocument("$gte", new DateTime(fromYear, fromMonth, fromDay))
                                             .Add("$lte", new DateTime(toYear, toMonth, toDay, 23, 59, 59))
                        }
                    }
                ),
                new BsonDocument("$group",
                    new BsonDocument
                    {
                        { "_id", new BsonDocument
                            {
                                { "ParentCommodity", "$ParentCommodity" },
                                { "Company", "$CompanyName" },
                                { "Source", "$Source" }
                            }
                        },
                        { "TotalQty", new BsonDocument("$sum", "$TotalQty") },
                        { "TodayTotalQty", new BsonDocument("$sum", new BsonDocument
                        {
                            { "$cond", new BsonArray
                                {
                                    new BsonDocument("$and", new BsonArray
                                        {
                                            new BsonDocument("$gte", new BsonArray { new BsonDocument("$year", "$dateFilter"), todayYear }),
                                            new BsonDocument("$gte", new BsonArray { new BsonDocument("$month", "$dateFilter"), todayMonth }),
                                            new BsonDocument("$gte", new BsonArray { new BsonDocument("$dayOfMonth", "$dateFilter"), todayDay })
                                        }),
                                    "$TotalQty",
                                    0
                                }
                            } })
                        },
                        { "MonthTotalQty", new BsonDocument("$sum", new BsonDocument
                        {
                            { "$cond", new BsonArray
                                {
                                    new BsonDocument("$and", new BsonArray
                                        {
                                            new BsonDocument("$eq", new BsonArray { new BsonDocument("$year", "$dateFilter"), todayYear }),
                                            new BsonDocument("$eq", new BsonArray { new BsonDocument("$month", "$dateFilter"), todayMonth }),
                                        }),
                                    "$TotalQty",
                                    0
                                }
                            } })
                        }
                    }
                ),
                new BsonDocument("$project",
                    new BsonDocument
                    {
                        { "_id", 0 },
                        { "CompanyName", "$_id.Company" },
                        { "Commodity", "$_id.Source" },
                        { "ParentCommodity", "$_id.ParentCommodity" },
                        { "TotalQty", 1 },
                        { "TodayTotalQty", 1 },
                        { "MonthTotalQty", 1 }
                    }
                )
            };
            var positionSet6 = datasetCollection.Aggregate<BsonDocument>(pipeline6, aggregateOptions).ToList();
            List<PositionList3> positionList6 = BsonHelper.ConvertBsonDocumentListToModel<PositionList3>(positionSet6).ToList();

            List<BsonDocument> pipeline7 = new List<BsonDocument>
            {
                new BsonDocument("$match",
                    new BsonDocument
                    {
                        { "DataSourceId", new BsonDocument("$in", new BsonArray(salesFormIds)) },
                        { "IsArchived", false }
                    }),
                new BsonDocument("$addFields",
                    new BsonDocument
                    {
                        { "ParentCommodity", new BsonDocument("$toLower", "$DataJson.FormData.sourceCommodity") },
                        { "Source", "$DataJson.FormData.consumptionCommodity" },
                        { "TotalQty", new BsonDocument("$ifNull", new BsonArray
                            {
                                "$DataJson.FormData.consumedQuantityMt",
                                0
                            })
                        },
                        { "dateFilter",
                            new BsonDocument("$dateFromString",
                                new BsonDocument
                                {
                                    { "dateString", new BsonDocument("$ifNull", new BsonArray { "$DataJson.FormData.deliveryStartDate", "0" }) },
                                    { "onError",
                                        new BsonDocument("$dateFromString",
                                            new BsonDocument
                                            {
                                                { "dateString", "$DataJson.FormData.tradeDate" },
                                                { "onError", BsonNull.Value }
                                            }
                                        )
                                    }
                                }
                            )
                        },
                        { "CompanyName",
                            new BsonDocument("$cond",
                                new BsonDocument
                                {
                                    { "if", new BsonDocument("$eq", new BsonArray
                                        {
                                            "$DataSourceId",
                                            umiroSalesFormId
                                        })
                                    },
                                    { "then", "UMIRO-INDIA" },
                                    { "else", "ANA-INDIA" }
                                })
                        }
                    }),
                new BsonDocument("$match",
                    new BsonDocument
                    {
                        { "Source", new BsonDocument("$nin", new BsonArray
                            {
                                "",
                                BsonNull.Value,
                                " "
                            })
                        },
                        { "dateFilter", new BsonDocument("$gte", new DateTime(featureFromYear, featureFromMonth , 1))
                                             .Add("$lte", new DateTime(featureToYear, featureToMonth, featureToDay, 23, 59, 59))
                        }
                    }
                ),
                new BsonDocument("$addFields",
                    new BsonDocument
                    {
                        {
                            "Year", new BsonDocument("$year", "$dateFilter")
                        },
                        {
                            "Month", new BsonDocument("$month", "$dateFilter")
                        }
                    }
                ),
                new BsonDocument("$group",
                    new BsonDocument
                    {
                        { "_id", new BsonDocument
                            {
                                { "Company", "$CompanyName" },
                                { "ParentCommodity", "$ParentCommodity" },
                                { "Source", "$Source" },
                                { "Year", "$Year" },
                                { "Month", "$Month" }
                            }
                        },
                        { "TotalQty", new BsonDocument("$sum", "$TotalQty") }
                    }
                ),
                new BsonDocument("$project",
                    new BsonDocument
                    {
                        { "_id", 0 },
                        { "CompanyName", "$_id.Company" },
                        { "Commodity", "$_id.Source" },
                        { "ParentCommodity", "$_id.ParentCommodity" },
                        { "Year", "$_id.Year" },
                        { "Month", "$_id.Month" },
                        { "TotalQty", 1 }
                    }
                )
            };
            var positionSet7 = datasetCollection.Aggregate<BsonDocument>(pipeline7, aggregateOptions).ToList();
            List<PositionList3> positionList7 = BsonHelper.ConvertBsonDocumentListToModel<PositionList3>(positionSet7).ToList();

            positionList4.AddRange(positionList6);
            positionList5.AddRange(positionList7);

            List<BsonDocument> pipeline8 = new List<BsonDocument>
                {
                    new BsonDocument("$match",
                        new BsonDocument
                        {
                            { "DataSourceId", dailyRatesFormId },
                            { "IsArchived", false },
                            { "DataJson.FormData.sourceCommodity",new BsonDocument("$nin",new BsonArray{BsonNull.Value,""}) },
                            //{ "DataJson.FormData.derivedUsdRate",new BsonDocument("$nin",new BsonArray{BsonNull.Value,""}) },
                        }
                    ),
                    new BsonDocument("$addFields",
                        new BsonDocument
                        {
                            { "location", new BsonDocument("$toLower", "$DataJson.FormData.location") },
                            { "date", new BsonDocument("$toDate", "$DataJson.FormData.entryDate") }
                        }
                    ),
                    //new BsonDocument("$match",
                    //    new BsonDocument
                    //    {
                    //        { "date", new BsonDocument("$lte", BsonDateTime.Create(new DateTime(previousYear, previousMonth, previousDay, 23, 59, 59))) }
                    //    }
                    //),
                    new BsonDocument("$sort",
                        new BsonDocument("date", -1)
                    ),
                    new BsonDocument("$group",
                        new BsonDocument
                        {
                            { "_id", new BsonDocument
                                {
                                    { "commodity1", "$DataJson.FormData.commodity1" },
                                    { "location", "$location" } // Include location in the grouping
                                }
                            },
                            {"OldMTMRate", new BsonDocument("$push", "$DataJson.FormData.rateInr") },
                            { "OldDerivedUsdRate", new BsonDocument("$push", "$DataJson.FormData.derivedUsdRate") },
                            { "OldCnfRateUsd", new BsonDocument("$push", "$DataJson.FormData.cnfRateUsd") },
                            { "OldDerivedMdexRateUsd", new BsonDocument("$push", "$DataJson.FormData.derivedMdexRateUsd") },
                            { "OldSpotRateUsdMyr", new BsonDocument("$push", "$DataJson.FormData.spotRateUsdMyr") },
                            { "OldUSDToInr", new BsonDocument("$push", "$DataJson.FormData.usdToInr") },
                            { "MTMRate", new BsonDocument("$first", "$DataJson.FormData.rateInr") },
                            { "DerivedUsdRate", new BsonDocument("$first", "$DataJson.FormData.derivedUsdRate") },
                            { "CnfRateUsd", new BsonDocument("$first", "$DataJson.FormData.cnfRateUsd") },
                            { "DerivedMdexRateUsd", new BsonDocument("$first", "$DataJson.FormData.derivedMdexRateUsd") },
                            { "SpotRateUsdMyr", new BsonDocument("$first", "$DataJson.FormData.spotRateUsdMyr") },
                            { "USDToInr", new BsonDocument("$first", "$DataJson.FormData.usdToInr") },
                        }
                    ),
                    new BsonDocument("$project",
                        new BsonDocument
                        {
                            { "_id", 0 },
                            { "Commodity", new BsonDocument("$toLower", "$_id.commodity1") },
                            { "CompanyName", "$_id.location" },
                            { "MTMRate", new BsonDocument("$ifNull", new BsonArray { new BsonDocument("$round", new BsonArray { "$MTMRate", 4 }), 0 }) },
                            { "DerivedUsdRate", new BsonDocument("$ifNull", new BsonArray { new BsonDocument("$round", new BsonArray { "$DerivedUsdRate", 4 }), 0 }) },
                            { "CnfRateUsd", new BsonDocument("$ifNull", new BsonArray { new BsonDocument("$round", new BsonArray { "$CnfRateUsd", 4 }), 0 }) },
                            { "SpotRateUsdMyr", new BsonDocument("$ifNull", new BsonArray { new BsonDocument("$round", new BsonArray { "$SpotRateUsdMyr", 4 }), 0 }) },
                            { "DerivedMdexRateUsd", new BsonDocument("$ifNull", new BsonArray { new BsonDocument("$round", new BsonArray { "$DerivedMdexRateUsd", 4 }), 0 }) },
                            { "USDToInr", new BsonDocument("$ifNull", new BsonArray { new BsonDocument("$round", new BsonArray { "$USDToInr", 4 }), 0 }) },
                            { "OldMTMRate", new BsonDocument("$round", new BsonArray { new BsonDocument("$arrayElemAt", new BsonArray { "$OldMTMRate", 1 }), 4 }) },
                            { "OldDerivedUsdRate", new BsonDocument("$round", new BsonArray { new BsonDocument("$arrayElemAt", new BsonArray { "$OldDerivedUsdRate", 1 }), 4 }) },
                            { "OldCnfRateUsd", new BsonDocument("$round", new BsonArray { new BsonDocument("$arrayElemAt", new BsonArray { "$OldCnfRateUsd", 1 }), 4 }) },
                            { "OldSpotRateUsdMyr", new BsonDocument("$round", new BsonArray { new BsonDocument("$arrayElemAt", new BsonArray { "$OldSpotRateUsdMyr", 1 }), 4 }) },
                            { "OldDerivedMdexRateUsd", new BsonDocument("$round", new BsonArray { new BsonDocument("$arrayElemAt", new BsonArray { "$OldDerivedMdexRateUsd", 1 }), 4 }) },
                            { "OldUSDToInr", new BsonDocument("$round", new BsonArray { new BsonDocument("$arrayElemAt", new BsonArray { "$OldUSDToInr", 1 }), 4 }) },
                        }
                    )
                };
            var positionSet8 = datasetCollection.Aggregate<BsonDocument>(pipeline8, aggregateOptions).ToList();
            List<PositionList7> positionList8 = BsonHelper.ConvertBsonDocumentListToModel<PositionList7>(positionSet8).ToList();

            //MTM for all commodities
            List<BsonDocument> pipeline10 = new List<BsonDocument>
            {
                new BsonDocument("$match",
                    new BsonDocument
                    {
                        { "DataSourceId", dailyRatesFormId },
                        { "IsArchived", false },
                    }
                ),
                new BsonDocument("$addFields",
                    new BsonDocument
                    {
                        { "location", new BsonDocument("$toLower", "$DataJson.FormData.location") },
                        { "date", new BsonDocument("$toDate", "$DataJson.FormData.entryDate") }
                    }
                ),
                new BsonDocument("$match",
                    new BsonDocument
                    {
                        { "date", new BsonDocument("$lte", BsonDateTime.Create(new DateTime(previousYear, previousMonth, previousDay, 23, 59, 59))) }
                    }
                ),
                new BsonDocument("$sort",
                    new BsonDocument("date", -1)
                ),
                new BsonDocument("$group",
                    new BsonDocument
                    {
                        { "_id", new BsonDocument
                            {
                                { "commodity1", "$DataJson.FormData.commodity1" },
                                { "location", "$location" }
                            }
                        },
                        { "MTMRate", new BsonDocument("$first", "$DataJson.FormData.rateInr") },
                        { "USDToInr", new BsonDocument("$first", "$DataJson.FormData.usdToInr") }
                    }
                ),
                new BsonDocument("$project",
                    new BsonDocument
                    {
                        { "_id", 0 },
                        { "Commodity", new BsonDocument("$toLower", "$_id.commodity1") },
                        { "CompanyName", "$_id.location" },
                        { "MTMRate", new BsonDocument("$ifNull", new BsonArray { "$MTMRate", 0 }) },
                        { "USDToInr", new BsonDocument("$ifNull", new BsonArray { "$USDToInr", 0 }) }
                    }
                )
            };
            var positionSet10 = datasetCollection.Aggregate<BsonDocument>(pipeline10, aggregateOptions).ToList();
            List<salesList3> positionList10 = BsonHelper.ConvertBsonDocumentListToModel<salesList3>(positionSet10).ToList();

            List<BsonDocument> pipeline11 = new List<BsonDocument>
            {
                new BsonDocument("$match",
                    new BsonDocument
                    {
                        { "DataSourceId", dailyRatesFormId },
                        { "IsArchived", false },
                    }
                ),
                new BsonDocument("$addFields",
                    new BsonDocument
                    {
                        { "location", new BsonDocument("$toLower", "$DataJson.FormData.location") },
                        { "date", new BsonDocument("$toDate", "$DataJson.FormData.entryDate") }
                    }
                ),
                new BsonDocument("$match",
                    new BsonDocument
                    {
                        { "date", new BsonDocument("$lte", BsonDateTime.Create(new DateTime(toYear, toMonth, toDay, 23, 59, 59))) }
                    }
                ),
                new BsonDocument("$sort",
                    new BsonDocument("date", -1)
                ),
                new BsonDocument("$group",
                    new BsonDocument
                    {
                        { "_id", new BsonDocument
                            {
                                { "commodity1", "$DataJson.FormData.commodity1" },
                                { "location", "$location" }
                            }
                        },
                        { "MTMRate", new BsonDocument("$first", "$DataJson.FormData.rateInr") },
                        { "USDToInr", new BsonDocument("$first", "$DataJson.FormData.usdToInr") }
                    }
                ),
                new BsonDocument("$project",
                    new BsonDocument
                    {
                        { "_id", 0 },
                        { "Commodity", new BsonDocument("$toLower", "$_id.commodity1") },
                        { "CompanyName", "$_id.location" },
                        { "MTMRate", new BsonDocument("$ifNull", new BsonArray { "$MTMRate", 0 }) },
                        { "USDToInr", new BsonDocument("$ifNull", new BsonArray { "$USDToInr", 0 }) }
                    }
                )
            };
            var positionSet11 = datasetCollection.Aggregate<BsonDocument>(pipeline11, aggregateOptions).ToList();
            List<salesList3> positionList11 = BsonHelper.ConvertBsonDocumentListToModel<salesList3>(positionSet11).ToList();

            //Produced qty for all commodities
            List<BsonDocument> pipeline12 = new List<BsonDocument>
            {
                new BsonDocument("$match", new BsonDocument
                {
                    { "DataSourceId", new BsonDocument("$in", new BsonArray(salesFormIds)) },
                    { "IsArchived", false },
                }),
                new BsonDocument("$addFields", new BsonDocument
                {
                    { "sourceCommodity", new BsonDocument("$toLower", "$DataJson.FormData.sourceCommodity") },
                    { "dateFilter",
                        new BsonDocument("$dateFromString",
                            new BsonDocument
                            {
                                { "dateString", new BsonDocument("$ifNull", new BsonArray { "$DataJson.FormData.deliveryStartDate", "0" }) },
                                { "onError",
                                    new BsonDocument("$dateFromString",
                                        new BsonDocument
                                        {
                                            { "dateString", "$DataJson.FormData.tradeDate" },
                                            { "onError", BsonNull.Value }
                                        }
                                    )
                                }
                            }
                        )
                    },
                    { "CompanyName",
                            new BsonDocument("$cond",
                                new BsonDocument
                                {
                                    { "if", new BsonDocument("$eq", new BsonArray
                                        {
                                            "$DataSourceId",
                                            umiroSalesFormId
                                        })
                                    },
                                    { "then", "UMIRO-INDIA" },
                                    { "else", "ANA-INDIA" }
                                })
                        }
                }),
                new BsonDocument("$match", new BsonDocument("dateFilter", new BsonDocument
                {
                    { "$gte", BsonDateTime.Create(new DateTime(fromYear, fromMonth, fromDay, 0, 0, 0)) },
                    { "$lte", BsonDateTime.Create(new DateTime(toYear, toMonth, toDay, 23, 59, 59)) }
                })),
                new BsonDocument("$group", new BsonDocument
                {
                    { "_id", new BsonDocument
                        {
                            { "CompanyName", "$CompanyName" },
                            { "SourceCommodity", "$sourceCommodity" }
                        }
                    },
                    { "cpo", new BsonDocument("$sum", "$DataJson.FormData.cpoMt") },
                    { "cpo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.cpoTradingMt") },
                    { "rbd-palm-olein", new BsonDocument("$sum", "$DataJson.FormData.rbdOleinMt") },
                    { "refined-palm-oil", new BsonDocument("$sum", "$DataJson.FormData.rpoMt") },
                    { "stearin", new BsonDocument("$sum", "$DataJson.FormData.stearinMt") },
                    { "soft-stearin", new BsonDocument("$sum", "$DataJson.FormData.softStearinMt") },
                    { "hard-stearin", new BsonDocument("$sum", "$DataJson.FormData.hardStearinMt") },
                    { "pfad", new BsonDocument("$sum", "$DataJson.FormData.pfadMt") },
                    { "white-olein", new BsonDocument("$sum", "$DataJson.FormData.whiteOleinMt") },
                    { "calcium-soap", new BsonDocument("$sum", "$DataJson.FormData.calciumSoapMt") },
                    { "loss", new BsonDocument("$sum", "$DataJson.FormData.lossMt") },
                    { "rbd-palm-olein-trading", new BsonDocument("$sum", "$DataJson.FormData.rbdPalmoleinImportMt") },
                    { "rbd-palm-olein-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.rbdPalmoleinTradingMt") },
                    { "refined-palm-oil-trading", new BsonDocument("$sum", "$DataJson.FormData.rpoMt1") },
                    { "refined-palm-oil-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.rpoMt2") },
                    { "csfo", new BsonDocument("$sum", "$DataJson.FormData.csfoMt") },
                    { "csfo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.csfoTradingMt") },
                    { "rsfo", new BsonDocument("$sum", "$DataJson.FormData.rsfoMt") },
                    { "sunflower-fatty-acid", new BsonDocument("$sum", "$DataJson.FormData.sunflowerFattyAcidMt") },
                    { "rsfo-trading", new BsonDocument("$sum", "$DataJson.FormData.rsfoLocalMt") },
                    { "rsfo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.rsfoTradingMt") },
                    { "crbo", new BsonDocument("$sum", "$DataJson.FormData.crboMt") },
                    { "crbo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.crboTradingMt") },
                    { "rrbo", new BsonDocument("$sum", "$DataJson.FormData.rrboMt") },
                    { "rb-fatty-acid", new BsonDocument("$sum", "$DataJson.FormData.rbFattyAcidMt") },
                    { "rb-oil-wax", new BsonDocument("$sum", "$DataJson.FormData.rbOilWaxMt") },
                    { "rrbo-trading", new BsonDocument("$sum", "$DataJson.FormData.rrboLocalMt") },
                    { "rrbo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.rrboTradingMt") },
                    { "cdsbo", new BsonDocument("$sum", "$DataJson.FormData.cdsboMt") },
                    { "cdsbo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.cdsboTradingMt") },
                    { "rsbo", new BsonDocument("$sum", "$DataJson.FormData.rsboMt") },
                    { "soy-acid-oil", new BsonDocument("$sum", "$DataJson.FormData.soyAcidOilMt") },
                    { "rsbo-trading", new BsonDocument("$sum", "$DataJson.FormData.rsboLocalMt") },
                    { "rsbo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.rsboTradingMt") },
                    { "crude-glycerin", new BsonDocument("$sum", "$DataJson.FormData.crudeGlycerinMt") },
                    { "refined-glycerin", new BsonDocument("$sum", "$DataJson.FormData.refinedGycerinMt") },
                    { "refined-glycerin-trading", new BsonDocument("$sum", "$DataJson.FormData.refinedGlycerinLocalMt1") },
                    { "refined-glycerin-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.refinedGlycerinTradingMt") }
                }),
                new BsonDocument("$addFields", new BsonDocument
                {
                    { "data", new BsonDocument("$map", new BsonDocument
                    {
                        { "input", new BsonDocument("$objectToArray", "$$ROOT") },
                        { "as", "item" },
                        { "in", new BsonDocument
                        {
                            { "k", "$$item.k" },
                            { "v", new BsonDocument("$cond", new BsonDocument
                            {
                                { "if", new BsonDocument("$gt", new BsonArray { "$$item.v", 0 }) },
                                { "then", "$$item.v" },
                                { "else", 0 }
                            })}
                        }}
                    })}
                }),
                new BsonDocument("$unwind", "$data"),
                new BsonDocument("$match", new BsonDocument("data.k", new BsonDocument("$ne", "_id"))),
                new BsonDocument("$project", new BsonDocument
                {
                    { "_id", 0 },
                    { "CompanyName", "$_id.CompanyName" },
                    { "ParentCommodity", "$_id.SourceCommodity" },
                    { "Commodity", "$data.k" },
                    { "TotalQty", new BsonDocument("$convert", new BsonDocument
                        {
                            { "input", "$data.v" },
                            { "to", "decimal" } // Convert to decimal data type
                        })
                    }
                })
            };
            var positionSet12 = datasetCollection.Aggregate<BsonDocument>(pipeline12, aggregateOptions).ToList();
            List<PositionList3> positionList12 = BsonHelper.ConvertBsonDocumentListToModel<PositionList3>(positionSet12).ToList();

            List<BsonDocument> pipeline13 = new List<BsonDocument>
            {
                new BsonDocument("$match", new BsonDocument
                {
                    { "DataSourceId", new BsonDocument("$in", new BsonArray(salesFormIds)) },
                    { "IsArchived", false },
                }),
                new BsonDocument("$addFields", new BsonDocument
                {
                    { "sourceCommodity", new BsonDocument("$toLower", "$DataJson.FormData.sourceCommodity") },
                    { "dateFilter",
                        new BsonDocument("$dateFromString",
                            new BsonDocument
                            {
                                { "dateString", new BsonDocument("$ifNull", new BsonArray { "$DataJson.FormData.deliveryStartDate", "0" }) },
                                { "onError",
                                    new BsonDocument("$dateFromString",
                                        new BsonDocument
                                        {
                                            { "dateString", "$DataJson.FormData.tradeDate" },
                                            { "onError", BsonNull.Value }
                                        }
                                    )
                                }
                            }
                        )
                    },
                    { "CompanyName",
                            new BsonDocument("$cond",
                                new BsonDocument
                                {
                                    { "if", new BsonDocument("$eq", new BsonArray
                                        {
                                            "$DataSourceId",
                                            umiroSalesFormId
                                        })
                                    },
                                    { "then", "UMIRO-INDIA" },
                                    { "else", "ANA-INDIA" }
                                })
                        }
                }),
                new BsonDocument("$match", new BsonDocument("dateFilter", new BsonDocument
                {
                    { "$gte", BsonDateTime.Create(new DateTime(previousYear, previousMonth, previousDay, 23, 59, 59)) },
                    { "$lte", BsonDateTime.Create(new DateTime(todayYear, todayMonth, todayDay, 23, 59, 59)) }

                })),
                new BsonDocument("$group", new BsonDocument
                {
                    { "_id", new BsonDocument
                        {
                            { "CompanyName", "$CompanyName" },
                            { "SourceCommodity", "$sourceCommodity" }
                        }
                    },
                    { "cpo", new BsonDocument("$sum", "$DataJson.FormData.cpoMt") },
                    { "cpo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.cpoTradingMt") },
                    { "rbd-palm-olein", new BsonDocument("$sum", "$DataJson.FormData.rbdOleinMt") },
                    { "refined-palm-oil", new BsonDocument("$sum", "$DataJson.FormData.rpoMt") },
                    { "stearin", new BsonDocument("$sum", "$DataJson.FormData.stearinMt") },
                    { "soft-stearin", new BsonDocument("$sum", "$DataJson.FormData.softStearinMt") },
                    { "hard-stearin", new BsonDocument("$sum", "$DataJson.FormData.hardStearinMt") },
                    { "pfad", new BsonDocument("$sum", "$DataJson.FormData.pfadMt") },
                    { "white-olein", new BsonDocument("$sum", "$DataJson.FormData.whiteOleinMt") },
                    { "calcium-soap", new BsonDocument("$sum", "$DataJson.FormData.calciumSoapMt") },
                    { "loss", new BsonDocument("$sum", "$DataJson.FormData.lossMt") },
                    { "rbd-palm-olein-trading", new BsonDocument("$sum", "$DataJson.FormData.rbdPalmoleinImportMt") },
                    { "rbd-palm-olein-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.rbdPalmoleinTradingMt") },
                    { "refined-palm-oil-trading", new BsonDocument("$sum", "$DataJson.FormData.rpoMt1") },
                    { "refined-palm-oil-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.rpoMt2") },
                    { "csfo", new BsonDocument("$sum", "$DataJson.FormData.csfoMt") },
                    { "csfo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.csfoTradingMt") },
                    { "rsfo", new BsonDocument("$sum", "$DataJson.FormData.rsfoMt") },
                    { "sunflower-fatty-acid", new BsonDocument("$sum", "$DataJson.FormData.sunflowerFattyAcidMt") },
                    { "rsfo-trading", new BsonDocument("$sum", "$DataJson.FormData.rsfoLocalMt") },
                    { "rsfo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.rsfoTradingMt") },
                    { "crbo", new BsonDocument("$sum", "$DataJson.FormData.crboMt") },
                    { "crbo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.crboTradingMt") },
                    { "rrbo", new BsonDocument("$sum", "$DataJson.FormData.rrboMt") },
                    { "rb-fatty-acid", new BsonDocument("$sum", "$DataJson.FormData.rbFattyAcidMt") },
                    { "rb-oil-wax", new BsonDocument("$sum", "$DataJson.FormData.rbOilWaxMt") },
                    { "rrbo-trading", new BsonDocument("$sum", "$DataJson.FormData.rrboLocalMt") },
                    { "rrbo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.rrboTradingMt") },
                    { "cdsbo", new BsonDocument("$sum", "$DataJson.FormData.cdsboMt") },
                    { "cdsbo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.cdsboTradingMt") },
                    { "rsbo", new BsonDocument("$sum", "$DataJson.FormData.rsboMt") },
                    { "soy-acid-oil", new BsonDocument("$sum", "$DataJson.FormData.soyAcidOilMt") },
                    { "rsbo-trading", new BsonDocument("$sum", "$DataJson.FormData.rsboLocalMt") },
                    { "rsbo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.rsboTradingMt") },
                    { "crude-glycerin", new BsonDocument("$sum", "$DataJson.FormData.crudeGlycerinMt") },
                    { "refined-glycerin", new BsonDocument("$sum", "$DataJson.FormData.refinedGycerinMt") },
                    { "refined-glycerin-trading", new BsonDocument("$sum", "$DataJson.FormData.refinedGlycerinLocalMt1") },
                    { "refined-glycerin-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.refinedGlycerinTradingMt") }
                }),
                new BsonDocument("$addFields", new BsonDocument
                {
                    { "data", new BsonDocument("$map", new BsonDocument
                    {
                        { "input", new BsonDocument("$objectToArray", "$$ROOT") },
                        { "as", "item" },
                        { "in", new BsonDocument
                        {
                            { "k", "$$item.k" },
                            { "v", new BsonDocument("$cond", new BsonDocument
                            {
                                { "if", new BsonDocument("$gt", new BsonArray { "$$item.v", 0 }) },
                                { "then", "$$item.v" },
                                { "else", 0 }
                            })}
                        }}
                    })}
                }),
                new BsonDocument("$unwind", "$data"),
                new BsonDocument("$match", new BsonDocument("data.k", new BsonDocument("$ne", "_id"))),
                new BsonDocument("$project", new BsonDocument
                {
                    { "_id", 0 },
                    { "CompanyName", "$_id.CompanyName" },
                    { "ParentCommodity", "$_id.SourceCommodity" },
                    { "Commodity", "$data.k" },
                    { "TotalQty", new BsonDocument("$convert", new BsonDocument
                        {
                            { "input", "$data.v" },
                            { "to", "decimal" } // Convert to decimal data type
                        })
                    }
                })
            };
            var positionSet13 = datasetCollection.Aggregate<BsonDocument>(pipeline13, aggregateOptions).ToList();
            List<PositionList3> positionList13 = BsonHelper.ConvertBsonDocumentListToModel<PositionList3>(positionSet13).ToList();

            List<BsonDocument> pipeline14 = new List<BsonDocument>
            {
                new BsonDocument("$match", new BsonDocument
                {
                    { "DataSourceId", new BsonDocument("$in", new BsonArray(salesFormIds)) },
                    { "IsArchived", false },
                }),
                new BsonDocument("$addFields", new BsonDocument
                {
                    { "sourceCommodity", new BsonDocument("$toLower", "$DataJson.FormData.sourceCommodity") },
                    { "dateFilter",
                        new BsonDocument("$dateFromString",
                            new BsonDocument
                            {
                                { "dateString", new BsonDocument("$ifNull", new BsonArray { "$DataJson.FormData.deliveryStartDate", "0" }) },
                                { "onError",
                                    new BsonDocument("$dateFromString",
                                        new BsonDocument
                                        {
                                            { "dateString", "$DataJson.FormData.tradeDate" },
                                            { "onError", BsonNull.Value }
                                        }
                                    )
                                }
                            }
                        )
                    },
                    { "CompanyName",
                            new BsonDocument("$cond",
                                new BsonDocument
                                {
                                    { "if", new BsonDocument("$eq", new BsonArray
                                        {
                                            "$DataSourceId",
                                            umiroSalesFormId
                                        })
                                    },
                                    { "then", "UMIRO-INDIA" },
                                    { "else", "ANA-INDIA" }
                                })
                        }
                }),
                new BsonDocument("$match", new BsonDocument("dateFilter", new BsonDocument
                {
                    { "$gte", BsonDateTime.Create(new DateTime(toYear, toMonth, 1, 0, 0, 0)) },
                    { "$lte", BsonDateTime.Create(new DateTime(toYear, toMonth, todayDay, 23, 59, 59)) }

                })),
                new BsonDocument("$group", new BsonDocument
                {
                    { "_id", new BsonDocument
                        {
                            { "CompanyName", "$CompanyName" },
                            { "SourceCommodity", "$sourceCommodity" }
                        }
                    },
                    { "cpo", new BsonDocument("$sum", "$DataJson.FormData.cpoMt") },
                    { "cpo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.cpoTradingMt") },
                    { "rbd-palm-olein", new BsonDocument("$sum", "$DataJson.FormData.rbdOleinMt") },
                    { "refined-palm-oil", new BsonDocument("$sum", "$DataJson.FormData.rpoMt") },
                    { "stearin", new BsonDocument("$sum", "$DataJson.FormData.stearinMt") },
                    { "soft-stearin", new BsonDocument("$sum", "$DataJson.FormData.softStearinMt") },
                    { "hard-stearin", new BsonDocument("$sum", "$DataJson.FormData.hardStearinMt") },
                    { "pfad", new BsonDocument("$sum", "$DataJson.FormData.pfadMt") },
                    { "white-olein", new BsonDocument("$sum", "$DataJson.FormData.whiteOleinMt") },
                    { "calcium-soap", new BsonDocument("$sum", "$DataJson.FormData.calciumSoapMt") },
                    { "loss", new BsonDocument("$sum", "$DataJson.FormData.lossMt") },
                    { "rbd-palm-olein-trading", new BsonDocument("$sum", "$DataJson.FormData.rbdPalmoleinImportMt") },
                    { "rbd-palm-olein-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.rbdPalmoleinTradingMt") },
                    { "refined-palm-oil-trading", new BsonDocument("$sum", "$DataJson.FormData.rpoMt1") },
                    { "refined-palm-oil-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.rpoMt2") },
                    { "csfo", new BsonDocument("$sum", "$DataJson.FormData.csfoMt") },
                    { "csfo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.csfoTradingMt") },
                    { "rsfo", new BsonDocument("$sum", "$DataJson.FormData.rsfoMt") },
                    { "sunflower-fatty-acid", new BsonDocument("$sum", "$DataJson.FormData.sunflowerFattyAcidMt") },
                    { "rsfo-trading", new BsonDocument("$sum", "$DataJson.FormData.rsfoLocalMt") },
                    { "rsfo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.rsfoTradingMt") },
                    { "crbo", new BsonDocument("$sum", "$DataJson.FormData.crboMt") },
                    { "crbo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.crboTradingMt") },
                    { "rrbo", new BsonDocument("$sum", "$DataJson.FormData.rrboMt") },
                    { "rb-fatty-acid", new BsonDocument("$sum", "$DataJson.FormData.rbFattyAcidMt") },
                    { "rb-oil-wax", new BsonDocument("$sum", "$DataJson.FormData.rbOilWaxMt") },
                    { "rrbo-trading", new BsonDocument("$sum", "$DataJson.FormData.rrboLocalMt") },
                    { "rrbo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.rrboTradingMt") },
                    { "cdsbo", new BsonDocument("$sum", "$DataJson.FormData.cdsboMt") },
                    { "cdsbo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.cdsboTradingMt") },
                    { "rsbo", new BsonDocument("$sum", "$DataJson.FormData.rsboMt") },
                    { "soy-acid-oil", new BsonDocument("$sum", "$DataJson.FormData.soyAcidOilMt") },
                    { "rsbo-trading", new BsonDocument("$sum", "$DataJson.FormData.rsboLocalMt") },
                    { "rsbo-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.rsboTradingMt") },
                    { "crude-glycerin", new BsonDocument("$sum", "$DataJson.FormData.crudeGlycerinMt") },
                    { "refined-glycerin", new BsonDocument("$sum", "$DataJson.FormData.refinedGycerinMt") },
                    { "refined-glycerin-trading", new BsonDocument("$sum", "$DataJson.FormData.refinedGlycerinLocalMt1") },
                    { "refined-glycerin-ex-tank", new BsonDocument("$sum", "$DataJson.FormData.refinedGlycerinTradingMt") }
                }),
                new BsonDocument("$addFields", new BsonDocument
                {
                    { "data", new BsonDocument("$map", new BsonDocument
                    {
                        { "input", new BsonDocument("$objectToArray", "$$ROOT") },
                        { "as", "item" },
                        { "in", new BsonDocument
                        {
                            { "k", "$$item.k" },
                            { "v", new BsonDocument("$cond", new BsonDocument
                            {
                                { "if", new BsonDocument("$gt", new BsonArray { "$$item.v", 0 }) },
                                { "then", "$$item.v" },
                                { "else", 0 }
                            })}
                        }}
                    })}
                }),
                new BsonDocument("$unwind", "$data"),
                new BsonDocument("$match", new BsonDocument("data.k", new BsonDocument("$ne", "_id"))),
                new BsonDocument("$project", new BsonDocument
                {
                    { "_id", 0 },
                    { "CompanyName", "$_id.CompanyName" },
                    { "ParentCommodity", "$_id.SourceCommodity" },
                    { "Commodity", "$data.k" },
                    { "TotalQty", new BsonDocument("$convert", new BsonDocument
                        {
                            { "input", "$data.v" },
                            { "to", "decimal" } // Convert to decimal data type
                        })
                    }
                })
            };
            var positionSet14 = datasetCollection.Aggregate<BsonDocument>(pipeline14, aggregateOptions).ToList();
            List<PositionList3> positionList14 = BsonHelper.ConvertBsonDocumentListToModel<PositionList3>(positionSet14).ToList();
             
            List<BsonDocument> pipeline19 = new List<BsonDocument>
            {
                new BsonDocument("$match", new BsonDocument
                {
                    { "DataSourceId", new BsonDocument("$in", new BsonArray{ UmiroAdjFormId.ToLower(), ANAAdjFormId.ToLower() }) },
                    { "IsArchived", false }
                }),
                new BsonDocument("$addFields", new BsonDocument
                {
                    { "ProductGroup", new BsonDocument("$toLower", "$DataJson.FormData.sourceCommodity") },
                    { "dateFilter", new BsonDocument("$toDate", "$DataJson.FormData.tradeDate") },
                    { "CompanyName", new BsonDocument("$cond", new BsonDocument
                        {
                            { "if", new BsonDocument("$eq", new BsonArray
                                {
                                    "$DataSourceId",
                                    UmiroAdjFormId.ToLower()
                                })
                            },
                            { "then", "UMIRO-INDIA" },
                            { "else", "ANA-INDIA" }
                        })
                    }
                }),
                new BsonDocument("$match", new BsonDocument("dateFilter", new BsonDocument
                {
                    { "$gte", BsonDateTime.Create(new DateTime(fromYear, fromMonth, fromDay)) },
                    { "$lte", BsonDateTime.Create(new DateTime(toYear, toMonth, toDay, 23, 59, 59)) }
                })),
                new BsonDocument("$group", new BsonDocument
                {
                    { "_id", new BsonDocument
                        {
                            { "ProductGroup", "$ProductGroup" },
                            { "CompanyName", "$CompanyName" }
                        }
                    },
                    { "Cancellation", new BsonDocument("$sum", "$DataJson.FormData.quantityMt2") },
                    { "TodayCancellation", new BsonDocument("$sum", new BsonDocument("$cond", new BsonArray
                        {
                            new BsonDocument("$and", new BsonArray
                            {
                                new BsonDocument("$eq", new BsonArray
                                {
                                    new BsonDocument("$year", "$dateFilter"),todayYear
                                }),
                                new BsonDocument("$eq", new BsonArray
                                {
                                    new BsonDocument("$month", "$dateFilter"),todayMonth
                                }),
                                new BsonDocument("$eq", new BsonArray
                                {
                                    new BsonDocument("$dayOfMonth", "$dateFilter"),todayDay
                                })
                            }),
                            "$DataJson.FormData.quantityMt2",
                            0
                        })
                    )}
                }),
                new BsonDocument("$project", new BsonDocument
                {
                    { "_id", 0 },
                    { "ProductGroup", "$_id.ProductGroup" },
                    { "CompanyName", "$_id.CompanyName" },
                    { "Cancellation", new BsonDocument("$round", new BsonArray { "$Cancellation", 4 }) },
                    { "TodayCancellation", new BsonDocument("$round", new BsonArray { "$TodayCancellation", 4 }) }
                })
            };
            var positionSet19 = datasetCollection.Aggregate<BsonDocument>(pipeline19, aggregateOptions).ToList();
            List<PositionList6> positionList19 = BsonHelper.ConvertBsonDocumentListToModel<PositionList6>(positionSet19).ToList();

            List<BsonDocument> pipeline20 = new List<BsonDocument>
            {
                new BsonDocument("$match", new BsonDocument
                {
                    { "DataSourceId", new BsonDocument("$in", new BsonArray
                        {
                            FO_BuyFormId.ToLower(),
                            FO_SellFormId.ToLower()
                        })
                    },
                    { "IsArchived", false }
                }),
                new BsonDocument("$addFields", new BsonDocument
                {
                    { "sourceCommodity", new BsonDocument("$toLower", new BsonDocument("$concat", new BsonArray
                        {
                            "$DataJson.FormData.exchange",
                            new BsonString("-"),
                            "$DataJson.FormData.commodity"
                        })
                    ) },
                    { "dateFilter",
                        new BsonDocument("$dateFromString",
                            new BsonDocument
                            {
                                { "dateString", new BsonDocument("$ifNull", new BsonArray { "$DataJson.FormData.deliveryMonth", "0" }) },
                                { "onError",
                                    new BsonDocument("$dateFromString",
                                        new BsonDocument
                                        {
                                            { "dateString", "$DataJson.FormData.entryDate" },
                                            { "onError", BsonNull.Value }
                                        }
                                    )
                                }
                            }
                        )
                    },
                    { "CompanyName", new BsonDocument("$toLower", "$DataJson.FormData.productGroup") },
                    { "quantity", new BsonDocument("$cond", new BsonArray
                        {
                            new BsonDocument("$eq", new BsonArray
                            {
                                "$DataSourceId", FO_SellFormId.ToLower()
                            }),
                            new BsonDocument("$multiply", new BsonArray
                            {
                                "$DataJson.FormData.quantityInMt", -1
                            }),
                            "$DataJson.FormData.quantityInMt"
                        })
                    }
                }),
                new BsonDocument("$match", new BsonDocument("dateFilter", new BsonDocument
                {
                    { "$gte", BsonDateTime.Create(new DateTime(fromYear, fromMonth, fromDay)) },
                    { "$lte", BsonDateTime.Create(new DateTime(toYear, toMonth, toDay, 23, 59, 59)) }
                })),
                new BsonDocument("$group", new BsonDocument
                {
                    { "_id", new BsonDocument
                        {
                            { "SourceCommodity", "$sourceCommodity" },
                            { "CompanyName", "$CompanyName" }
                        }
                    },
                    { "TotalQty", new BsonDocument("$sum", "$quantity") }
                }),
                new BsonDocument("$project", new BsonDocument
                {
                    { "_id", 0 },
                    { "ParentCommodity", "$_id.SourceCommodity" },
                    { "CompanyName", "$_id.CompanyName" },
                    { "TotalQty", new BsonDocument("$round", new BsonArray { "$TotalQty", 4 }) }
                })
            };
            var positionSet20 = datasetCollection.Aggregate<BsonDocument>(pipeline20, aggregateOptions).ToList();
            List<PositionList3> positionList20 = BsonHelper.ConvertBsonDocumentListToModel<PositionList3>(positionSet20).ToList();

            List<BsonDocument> pipeline21 = new List<BsonDocument>
            {
                new BsonDocument("$match", new BsonDocument
                {
                    { "DataSourceId", new BsonDocument("$in", new BsonArray
                        {
                            FO_BuyFormId.ToLower(),
                            FO_SellFormId.ToLower()
                        })
                    },
                    { "IsArchived", false }
                }),
                new BsonDocument("$addFields", new BsonDocument
                {
                    { "sourceCommodity", new BsonDocument("$toLower", new BsonDocument("$concat", new BsonArray
                        {
                            "$DataJson.FormData.exchange",
                            new BsonString("-"),
                            "$DataJson.FormData.commodity"
                        })
                    ) },
                    { "dateFilter",
                        new BsonDocument("$dateFromString",
                            new BsonDocument
                            {
                                { "dateString", new BsonDocument("$ifNull", new BsonArray { "$DataJson.FormData.deliveryMonth", "0" }) },
                                { "onError",
                                    new BsonDocument("$dateFromString",
                                        new BsonDocument
                                        {
                                            { "dateString", "$DataJson.FormData.entryDate" },
                                            { "onError", BsonNull.Value }
                                        }
                                    )
                                }
                            }
                        )
                    },
                    { "CompanyName", new BsonDocument("$toLower", "$DataJson.FormData.productGroup") },
                    { "quantity", new BsonDocument("$cond", new BsonArray
                        {
                            new BsonDocument("$eq", new BsonArray
                            {
                                "$DataSourceId", FO_SellFormId.ToLower()
                            }),
                            new BsonDocument("$multiply", new BsonArray
                            {
                                "$DataJson.FormData.quantityInMt", -1
                            }),
                            "$DataJson.FormData.quantityInMt"
                        })
                    }
                }),
                new BsonDocument("$match", new BsonDocument("dateFilter", new BsonDocument
                {
                    { "$gte", BsonDateTime.Create(new DateTime(featureFromYear, featureFromMonth, 1)) },
                    { "$lte", BsonDateTime.Create(new DateTime(featureToYear, featureToMonth, featureToDay, 23, 59, 59)) }
                })),
                new BsonDocument("$group", new BsonDocument
                {
                    { "_id", new BsonDocument
                        {
                            { "SourceCommodity", "$sourceCommodity" },
                            { "CompanyName", "$CompanyName" },
                            { "Year", new BsonDocument("$year", "$dateFilter") },
                            { "Month", new BsonDocument("$month", "$dateFilter") }
                        }
                    },
                    { "TotalQty", new BsonDocument("$sum", "$quantity") },
                }),
                new BsonDocument("$project", new BsonDocument
                {
                    { "_id", 0 },
                    { "ParentCommodity", "$_id.SourceCommodity" },
                    { "CompanyName", "$_id.CompanyName" },
                    { "TotalQty", 1 },
                    { "Year", "$_id.Year" },
                    { "Month", "$_id.Month" },
                })
            };
            var positionSet21 = datasetCollection.Aggregate<BsonDocument>(pipeline21, aggregateOptions).ToList();
            List<PositionList3> positionList21 = BsonHelper.ConvertBsonDocumentListToModel<PositionList3>(positionSet21).ToList();

            //Paper&feature - unrealised >> sell form  part && - realised >> sell form  part
            List<BsonDocument> pipeline22 = new List<BsonDocument>
            {
                new BsonDocument("$match", new BsonDocument
                {
                    { "DataSourceId", new BsonDocument("$in", new BsonArray
                        {
                            FO_SellFormId.ToLower()
                        })
                    },
                    { "IsArchived", false }
                }),
                new BsonDocument("$addFields", new BsonDocument
                {
                    { "sourceCommodity", new BsonDocument("$toLower", new BsonDocument("$concat", new BsonArray
                        {
                            "$DataJson.FormData.exchange",
                            new BsonString("-"),
                            "$DataJson.FormData.commodity"
                        })
                    ) },
                    { "dateFilter",
                        new BsonDocument("$dateFromString",
                            new BsonDocument
                            {
                                { "dateString", new BsonDocument("$ifNull", new BsonArray { "$DataJson.FormData.deliveryMonth", "0" }) },
                                { "onError",
                                    new BsonDocument("$dateFromString",
                                        new BsonDocument
                                        {
                                            { "dateString", "$DataJson.FormData.entryDate" },
                                            { "onError", BsonNull.Value }
                                        }
                                    )
                                }
                            }
                        )
                    },
                    { "CompanyName", new BsonDocument("$toLower", "$DataJson.FormData.productGroup") }
                }),
                new BsonDocument("$match", new BsonDocument("dateFilter", new BsonDocument
                {
                    { "$gte", BsonDateTime.Create(new DateTime(fromYear, fromMonth, fromDay)) },
                    { "$lte", BsonDateTime.Create(new DateTime(featureToYear, featureToMonth, featureToDay, 23, 59, 59)) }
                })),
                new BsonDocument("$group", new BsonDocument
                {
                    { "_id", new BsonDocument
                        {
                            { "CompanyName", "$CompanyName" },
                            { "sourceCommodity", "$sourceCommodity" }
                        }
                    },
                    { "UnRealizedValue", new BsonDocument("$sum", "$DataJson.FormData.unRealizedValueMyr") },
                    { "UnRealizedQty", new BsonDocument("$sum", "$DataJson.FormData.unrealizedQuantityMt") },
                    { "RealizedQty", new BsonDocument("$sum", "$DataJson.FormData.realisedPnl") },
                }),
                new BsonDocument("$project", new BsonDocument
                {
                    { "_id", 0 },
                    { "SourceCommodity", "$_id.sourceCommodity" },
                    { "CompanyName", "$_id.CompanyName" },
                    { "UnRealizedValue", new BsonDocument("$round", new BsonArray { "$UnRealizedValue", 4 }) },
                    { "UnRealizedQty", new BsonDocument("$round", new BsonArray { "$UnRealizedQty", 4 }) },
                    { "RealizedQty", new BsonDocument("$round", new BsonArray { "$RealizedQty", 4 }) },
                })
            };
            var positionSet22 = datasetCollection.Aggregate<BsonDocument>(pipeline22, aggregateOptions).ToList();
            List<PositionList8> positionList22 = BsonHelper.ConvertBsonDocumentListToModel<PositionList8>(positionSet22).ToList();

            //SG-ana YTD & P&L
            List<BsonDocument> pipeline24 = new List<BsonDocument>
            {
                new BsonDocument("$match", new BsonDocument
                {
                    { "DataSourceId", new BsonDocument("$in", new BsonArray
                        {
                            SGVCFormId.ToLower(),
                            SGTBAPFormId.ToLower()
                        })
                    },
                    { "IsArchived", false },
                    { "DataJson.FormData.tradeDate", new BsonDocument("$nin", new BsonArray { "", BsonNull.Value, " " }) }
                }),
                new BsonDocument("$addFields", new BsonDocument
                {
                    { "dateFilter",
                        new BsonDocument("$dateFromString",
                            new BsonDocument
                            {
                                { "dateString", new BsonDocument("$ifNull", new BsonArray { "$DataJson.FormData.deliveryPeriod", "0" }) },
                                { "onError",
                                    new BsonDocument("$dateFromString",
                                        new BsonDocument
                                        {
                                            { "dateString", "$DataJson.FormData.tradeDate" },
                                            { "onError", BsonNull.Value }
                                        }
                                    )
                                }
                            }
                        )
                    },
                }),
                new BsonDocument("$match", new BsonDocument("dateFilter", new BsonDocument
                {
                    { "$gte", BsonDateTime.Create(new DateTime(fromYear, fromMonth, fromDay)) },
                    { "$lte", BsonDateTime.Create(new DateTime(toYear, toMonth, toDay, 23, 59, 59)) }
                })),
                new BsonDocument("$addFields",
                                new BsonDocument
                                    {
                                        { "adjTotalPricedQuantityMtOrimu",
                                new BsonDocument("$ifNull",
                                new BsonArray
                                            {
                                                "$DataJson.FormData.adjTotalPricedQuantityMtOrimu",
                                                0
                                            }) },
                                        { "tradeTicketQuantityMt",
                                new BsonDocument("$ifNull",
                                new BsonArray
                                            {
                                                "$DataJson.FormData.tradeTicketQuantityMt",
                                                0
                                            }) }
                                    }),
                new BsonDocument("$group", new BsonDocument
                {
                    { "_id", "$DataJson.FormData.commodity" },
                    { "TotalQty", new BsonDocument
                        {
                            { "$sum", new BsonDocument
                                {
                                    { "$add", new BsonArray
                                        {
                                            new BsonDocument("$toDecimal", "$adjTotalPricedQuantityMtOrimu"),
                                            new BsonDocument("$toDecimal", "$tradeTicketQuantityMt")
                                        }
                                    }
                                }
                            }
                        }
                    },
                    { "UnRealized", new BsonDocument("$sum", "$DataJson.FormData.unRealizedPLUsd") },
                    { "Realized", new BsonDocument("$sum", "$DataJson.FormData.adjRealizedPLOrimuUsd") },
                }),
                new BsonDocument("$project", new BsonDocument
                {
                    { "_id", 0 },
                    { "SourceCommodity", "$_id" },
                    { "TotalQty", new BsonDocument("$round", new BsonArray { "$TotalQty", 4 }) },
                    { "UnRealized", new BsonDocument("$round", new BsonArray { "$UnRealized", 4 }) },
                    { "Realized", new BsonDocument("$round", new BsonArray { "$Realized", 4 }) },
                })
            };
            var positionSet24 = datasetCollection.Aggregate<BsonDocument>(pipeline24, aggregateOptions).ToList();
            List<PositionList9> positionList24 = BsonHelper.ConvertBsonDocumentListToModel<PositionList9>(positionSet24).ToList();

            //Orimu YTD
            List<BsonDocument> pipeline25 = new List<BsonDocument>
            {
                new BsonDocument("$match", new BsonDocument
                {
                    { "DataSourceId", new BsonDocument("$in", new BsonArray
                        {
                            SGVCFormId.ToLower(),
                            OrimuTBAPFormId.ToLower()
                        })
                    },
                    { "IsArchived", false },
                    { "DataJson.FormData.tradeDate", new BsonDocument("$nin", new BsonArray { "", BsonNull.Value, " " }) }
                }),
                new BsonDocument("$addFields", new BsonDocument
                {
                    { "dateFilter",
                        new BsonDocument("$dateFromString",
                            new BsonDocument
                            {
                                { "dateString", new BsonDocument("$ifNull", new BsonArray { "$DataJson.FormData.deliveryPeriod", "0" }) },
                                { "onError",
                                    new BsonDocument("$dateFromString",
                                        new BsonDocument
                                        {
                                            { "dateString", "$DataJson.FormData.tradeDate" },
                                            { "onError", BsonNull.Value }
                                        }
                                    )
                                }
                            }
                        )
                    },
                    { "orimutotalPricedquantity", new BsonDocument("$ifNull",
                        new BsonArray
                                    {
                                        "$DataJson.FormData.orimutotalPricedquantity",
                                        0
                                    }) },
                     { "tradeTicketQuantityMt", new BsonDocument("$ifNull",
                                new BsonArray
                                            {
                                                "$DataJson.FormData.tradeTicketQuantityMt",
                                                0
                                            }) }
                }),
                new BsonDocument("$match", new BsonDocument("dateFilter", new BsonDocument
                {
                    { "$gte", BsonDateTime.Create(new DateTime(fromYear, fromMonth, fromDay)) },
                    { "$lte", BsonDateTime.Create(new DateTime(toYear, toMonth, toDay, 23, 59, 59)) }
                })),
                new BsonDocument("$group", new BsonDocument
                {
                    { "_id", "$DataJson.FormData.commodity" },
                    { "TotalQty", new BsonDocument
                        {
                            { "$sum", new BsonDocument
                                {
                                    { "$add", new BsonArray
                                        {
                                            new BsonDocument("$toDecimal", "$orimutotalPricedquantity"),
                                            new BsonDocument("$toDecimal", "$tradeTicketQuantityMt")
                                        }
                                    }
                                }
                            }
                        }
                    },
                    { "Realized", new BsonDocument("$sum", "$DataJson.FormData.orimuSgTotalPLUsd") },
                    { "UnRealized", new BsonDocument("$sum", new BsonDocument("$cond", new BsonArray
                        {
                            new BsonDocument("$eq", new BsonArray
                            {
                                "$DataSourceId", OrimuTBAPFormId.ToLower()
                            }),
                            "$DataJson.FormData.unrealizedPLUsd",
                            0
                        })
                    )},
                }),
                new BsonDocument("$project", new BsonDocument
                {
                    { "_id", 0 },
                    { "SourceCommodity", "$_id" },
                    { "TotalQty", new BsonDocument("$round", new BsonArray { "$TotalQty", 4 }) },
                    { "Realized", new BsonDocument("$round", new BsonArray { "$Realized", 4 }) },
                    { "UnRealized", new BsonDocument("$round", new BsonArray { "$UnRealized", 4 }) }
                })
            };
            var positionSet25 = datasetCollection.Aggregate<BsonDocument>(pipeline25, aggregateOptions).ToList();
            List<PositionList9> positionList25 = BsonHelper.ConvertBsonDocumentListToModel<PositionList9>(positionSet25).ToList();

            //SG & Orimu sales
            List<BsonDocument> pipeline26 = new List<BsonDocument>
            {
                new BsonDocument("$match",
                    new BsonDocument
                    {
                        { "DataSourceId", SGSalesFormId.ToLower() },
                        { "IsArchived", false }
                    }),
                new BsonDocument("$addFields",
                    new BsonDocument
                    {
                        { "Commodity", "$DataJson.FormData.commodity" },
                        { "TotalQty", new BsonDocument("$ifNull", new BsonArray
                            {
                                "$DataJson.FormData.salesSinceJan2023Mt",
                                0
                            })
                        },
                        { "dateFilter",
                            new BsonDocument("$dateFromString",
                                new BsonDocument
                                {
                                    { "dateString", new BsonDocument("$ifNull", new BsonArray { "$DataJson.FormData.deliveryPeriod", "0" }) },
                                    { "onError",
                                        new BsonDocument("$dateFromString",
                                            new BsonDocument
                                            {
                                                { "dateString", "$DataJson.FormData.tradeDate" },
                                                { "onError", BsonNull.Value }
                                            }
                                        )
                                    }
                                }
                            )
                        },
                    }),
                new BsonDocument("$match",
                    new BsonDocument
                    {
                        //{ "Source", new BsonDocument("$nin", new BsonArray
                        //    {
                        //        "",
                        //        BsonNull.Value,
                        //        " "
                        //    })
                        //},
                        { "dateFilter", new BsonDocument("$gte", new DateTime(fromYear, fromMonth, fromDay))
                                             .Add("$lte", new DateTime(toYear, toMonth, toDay, 23, 59, 59))
                        }
                    }
                ),
                new BsonDocument("$group",
                    new BsonDocument
                    {
                        { "_id", new BsonDocument
                            {
                                { "Commodity", "$Commodity" },
                                { "Company", "$DataJson.FormData.buyerIdenity" },
                            }
                        },
                        { "TotalQty",  new BsonDocument("$sum", "$TotalQty") },
                        { "TodayTotalQty", new BsonDocument("$sum", new BsonDocument
                        {
                            { "$cond", new BsonArray
                                {
                                    new BsonDocument("$and", new BsonArray
                                        {
                                            new BsonDocument("$lte", new BsonArray { new BsonDocument("$year", "$dateFilter"), todayYear }),
                                            new BsonDocument("$lte", new BsonArray { new BsonDocument("$month", "$dateFilter"), todayMonth }),
                                            new BsonDocument("$lte", new BsonArray { new BsonDocument("$dayOfMonth", "$dateFilter"), todayDay })
                                        }),
                                    "$TotalQty",
                                    0
                                }
                            } })
                        },
                    }
                ),
                new BsonDocument("$project",
                    new BsonDocument
                    {
                        { "_id", 0 },
                        { "CompanyName", "$_id.Company" },
                        { "Commodity", "$_id.Commodity" },
                        { "TotalQty", new BsonDocument("$round", new BsonArray { "$TotalQty", 4 }) },
                        { "TodayTotalQty", new BsonDocument("$round", new BsonArray { "$TodayTotalQty", 4 }) },
                    }
                )
            };
            var positionSet26 = datasetCollection.Aggregate<BsonDocument>(pipeline26, aggregateOptions).ToList();
            List<PositionList3> positionList26 = BsonHelper.ConvertBsonDocumentListToModel<PositionList3>(positionSet26).ToList();

            //Papers&features Unrealised sales form
            List<BsonDocument> pipeline27 = new List<BsonDocument>
            {
                new BsonDocument("$match",
                new BsonDocument
                    {
                        { "DataSourceId",
                new BsonDocument("$in",
                new BsonArray
                            {
                                FO_SellFormId.ToLower()
                            }) },
                        { "IsArchived", false }
                    }),
                new BsonDocument("$addFields",
                new BsonDocument
                    {
                        { "sourceCommodity",
                new BsonDocument("$toLower",
                new BsonDocument("$concat",
                new BsonArray
                                {
                                    "$DataJson.FormData.exchange",
                                    "-",
                                    "$DataJson.FormData.commodity"
                                })) },
                        { "dateFilter",
                new BsonDocument("$dateFromString",
                new BsonDocument
                            {
                                { "dateString",
                new BsonDocument("$ifNull",
                new BsonArray
                                    {
                                        "$DataJson.FormData.deliveryMonth",
                                        "0"
                                    }) },
                                { "onError",
                new BsonDocument("$dateFromString",
                new BsonDocument
                                    {
                                        { "dateString", "$DataJson.FormData.entryDate" },
                                        { "onError", BsonNull.Value }
                                    }) }
                            }) },
                        { "CompanyName",
                new BsonDocument("$toLower", "$DataJson.FormData.productGroup") }
                    }),
                new BsonDocument("$match",
                new BsonDocument("dateFilter",
                new BsonDocument
                        {
                            { "$gte",
                new DateTime(toYear, toMonth, 1, 0, 0, 0) },
                            { "$lte",
                new DateTime(featureToYear, featureToMonth, featureToDay, 23, 59, 59) }
                        })),
                new BsonDocument("$group",
                new BsonDocument
                    {
                        { "_id",
                new BsonDocument
                        {
                            { "CompanyName", "$CompanyName" },
                            { "sourceCommodity", "$sourceCommodity" },
                            { "month",
                new BsonDocument("$month", "$dateFilter") },
                            { "year",
                new BsonDocument("$year", "$dateFilter") }
                        } },
                        { "UnRealizedValue",
                new BsonDocument("$sum", "$DataJson.FormData.unRealizedValueMyr") },
                        { "UnRealizedQty",
                new BsonDocument("$sum", "$DataJson.FormData.unrealizedQuantityMt") }
                    }),
                new BsonDocument("$project",
                new BsonDocument
                    {
                        { "_id", 0 },
                        { "Commodity", "$_id.sourceCommodity" },
                        { "CompanyName", "$_id.CompanyName" },
                        { "Month", "$_id.month" },
                        { "Year", "$_id.year" },
                        { "UnRealizedValue",
                new BsonDocument("$round",
                new BsonArray
                            {
                                "$UnRealizedValue",
                                4
                            }) },
                        { "UnRealizedQty",
                new BsonDocument("$round",
                new BsonArray
                            {
                                "$UnRealizedQty",
                                4
                            }) }
                    })
            };
            var positionSet27 = datasetCollection.Aggregate<BsonDocument>(pipeline27, aggregateOptions).ToList();
            List<PositionList10> positionList27 = BsonHelper.ConvertBsonDocumentListToModel<PositionList10>(positionSet27).ToList();

            //Papers&features Unrealised buy form
            List<BsonDocument> pipeline28 = new List<BsonDocument>
            {
                new BsonDocument("$match",
                new BsonDocument
                    {
                        { "DataSourceId",
                new BsonDocument("$in",
                new BsonArray
                            {
                                FO_BuyFormId.ToLower()
                            }) },
                        { "IsArchived", false }
                    }),
                new BsonDocument("$addFields",
                new BsonDocument
                    {
                        { "sourceCommodity",
                new BsonDocument("$toLower",
                new BsonDocument("$concat",
                new BsonArray
                                {
                                    "$DataJson.FormData.exchange",
                                    "-",
                                    "$DataJson.FormData.commodity"
                                })) },
                        { "dateFilter",
                new BsonDocument("$dateFromString",
                new BsonDocument
                            {
                                { "dateString",
                new BsonDocument("$ifNull",
                new BsonArray
                                    {
                                        "$DataJson.FormData.deliveryMonth",
                                        "0"
                                    }) },
                                { "onError",
                new BsonDocument("$dateFromString",
                new BsonDocument
                                    {
                                        { "dateString", "$DataJson.FormData.entryDate" },
                                        { "onError", BsonNull.Value }
                                    }) }
                            }) },
                        { "CompanyName",
                new BsonDocument("$toLower", "$DataJson.FormData.productGroup") }
                    }),
                new BsonDocument("$match",
                new BsonDocument("dateFilter",
                new BsonDocument
                        {
                            { "$gte",
                new DateTime(toYear, toMonth, 1, 0, 0, 0) },
                            { "$lte",
                new DateTime(featureToYear,featureToMonth, featureToDay, 23, 59, 59) }
                        })),
                new BsonDocument("$group",
                new BsonDocument
                    {
                        { "_id",
                new BsonDocument
                        {
                            { "CompanyName", "$CompanyName" },
                            { "sourceCommodity", "$sourceCommodity" },
                            { "month",
                new BsonDocument("$month", "$dateFilter") },
                            { "year",
                new BsonDocument("$year", "$dateFilter") }
                        } },
                        { "UnRealizedValue",
                new BsonDocument("$sum", "$DataJson.FormData.quantityInMt") },
                        { "UnRealizedQty",
                new BsonDocument("$sum", "$DataJson.FormData.boughtValue") }
                    }),
                new BsonDocument("$project",
                new BsonDocument
                    {
                        { "_id", 0 },
                        { "Commodity", "$_id.sourceCommodity" },
                        { "CompanyName", "$_id.CompanyName" },
                        { "Month", "$_id.month" },
                        { "Year", "$_id.year" },
                        { "UnRealizedValue",
                new BsonDocument("$round",
                new BsonArray
                            {
                                "$UnRealizedValue",
                                4
                            }) },
                        { "UnRealizedQty",
                new BsonDocument("$round",
                new BsonArray
                            {
                                "$UnRealizedQty",
                                4
                            }) }
                    })
            };
            var positionSet28 = datasetCollection.Aggregate<BsonDocument>(pipeline28, aggregateOptions).ToList();
            List<PositionList10> positionList28 = BsonHelper.ConvertBsonDocumentListToModel<PositionList10>(positionSet28).ToList();

            //Papers&features Unrealised rates
            List<BsonDocument> pipeline29 = new List<BsonDocument>
            {
                new BsonDocument("$match",
                new BsonDocument
                    {
                        { "DataSourceId",
                new BsonDocument("$in",
                new BsonArray
                            {
                                FO_DailyRatesFormId.ToLower()
                            }) },
                        { "IsArchived", false }
                    }),
                new BsonDocument("$addFields",
                new BsonDocument
                    {
                        { "sourceCommodity",
                new BsonDocument("$toLower", "$DataJson.FormData.commodity1") },
                        { "dateFilter",
                new BsonDocument("$dateFromString",
                new BsonDocument
                            {
                                { "dateString",
                new BsonDocument("$ifNull",
                new BsonArray
                                    {
                                        "$DataJson.FormData.deliveryMonth",
                                        "0"
                                    }) },
                                { "onError",
                new BsonDocument("$dateFromString",
                new BsonDocument
                                    {
                                        { "dateString", "$DataJson.FormData.entryDate" },
                                        { "onError", BsonNull.Value }
                                    }) }
                            }) }
                    }),
                new BsonDocument("$match",
                new BsonDocument("dateFilter",
                new BsonDocument
                        {
                            { "$gte",
                new DateTime(toYear, toMonth, 1, 0, 0, 0) },
                            { "$lte",
                new DateTime(featureToYear, featureToMonth, featureToDay, 23, 59, 59) }
                        })),
                new BsonDocument("$sort",
                new BsonDocument
                {
                    { "sourceCommodity", 1 },
                    { "dateFilter", -1 }
                }),
                new BsonDocument("$group",
                new BsonDocument
                    {
                        { "_id",
                new BsonDocument
                        {
                            { "sourceCommodity", "$sourceCommodity" },
                            { "month",
                new BsonDocument("$month", "$dateFilter") },
                            { "year",
                new BsonDocument("$year", "$dateFilter") }
                        } },
                        { "derivedMdexRateUsd",
                new BsonDocument("$first", "$DataJson.FormData.derivedMdexRateUsd") },
                        { "cnfRateUsd",
                new BsonDocument("$first", "$DataJson.FormData.cnfRateUsd") },
                        { "spotRateUsdMyr",
                new BsonDocument("$first", "$DataJson.FormData.spotRateUsdMyr") }
                    }),
                new BsonDocument("$project",
                new BsonDocument
                    {
                        { "_id", 0 },
                        { "Commodity", "$_id.sourceCommodity" },
                        { "Month", "$_id.month" },
                        { "Year", "$_id.year" },
                        { "DerivedMdexRateUsd",
                new BsonDocument("$round",
                new BsonArray
                            {
                                new BsonDocument("$ifNull", new BsonArray { "$derivedMdexRateUsd", 0 }),
                                4
                            }) },
                        { "CnfRateUsd",
                new BsonDocument("$round",
                new BsonArray
                            {
                                new BsonDocument("$ifNull", new BsonArray { "$cnfRateUsd", 0 }),
                                4
                            }) },
                        { "SpotRateUsdMyr",
                new BsonDocument("$round",
                new BsonArray
                            {
                                new BsonDocument("$ifNull", new BsonArray { "$spotRateUsdMyr", 0 }),
                                4
                            }) }
                    })
            };
            var positionSet29 = datasetCollection.Aggregate<BsonDocument>(pipeline29, aggregateOptions).ToList();
            List<PositionList11> positionList29 = BsonHelper.ConvertBsonDocumentListToModel<PositionList11>(positionSet29).ToList();

            var joinedData = from A in positionList27
                             join C in positionList29
                             on new { A.Commodity, A.Month, A.Year } equals new { C.Commodity, C.Month, C.Year }
                             select new
                             {
                                 A.Commodity,
                                 A.CompanyName,
                                 TotalValue = (C.SpotRateUsdMyr == 0 ? 0 : (A.UnRealizedValue) / C.SpotRateUsdMyr)
                                 - (A.UnRealizedQty * (A.Commodity.Contains("pkpg-") ? C.CnfRateUsd : C.DerivedMdexRateUsd)),
                             };

            var joinedData1 = from B in positionList28
                              join C in positionList29
                              on new { B.Commodity, B.Month, B.Year } equals new { C.Commodity, C.Month, C.Year }
                              select new
                              {
                                  B.Commodity,
                                  B.CompanyName,
                                  TotalValue = (C.SpotRateUsdMyr == 0 ? 0 : ((-1) * B.UnRealizedQty) / C.SpotRateUsdMyr)
                                  + (B.UnRealizedValue * (B.Commodity.Contains("pkpg-") ? C.CnfRateUsd : C.DerivedMdexRateUsd))
                              };

            var combinedData = joinedData.Concat(joinedData1);

            var pipeline30 = new List<BsonDocument> {
                                new BsonDocument("$match",
                                new BsonDocument("Date",
                                new BsonDocument("$lte", BsonDateTime.Create(new DateTime(previousYear, previousMonth, previousDay))))),
                                new BsonDocument("$sort", new BsonDocument("Date", -1)),
                                new BsonDocument("$group",
                                new BsonDocument
                                    {
                                        { "_id",
                                new BsonDocument
                                        {
                                            { "Name", "$Name" },
                                            { "CompanyName", "$CompanyName" }
                                        } },
                                        { "YTDTotalPAndL",
                                new BsonDocument("$first", "$YTDTotalPAndL") },
                                        { "NetClosing",
                                new BsonDocument("$first", "$NetClosing") }
                                    }),
                                new BsonDocument("$project",
                                new BsonDocument
                                    {
                                        { "_id", 0 },
                                        { "Name", "$_id.Name" },
                                        { "CompanyName", "$_id.CompanyName" },
                                        { "YTDTotalPAndL",
                                new BsonDocument("$round",
                                new BsonArray
                                            {
                                                new BsonDocument("$toDecimal", "$YTDTotalPAndL"),
                                                3
                                            }) },
                                        { "NetClosing",
                                new BsonDocument("$round",
                                new BsonArray
                                            {
                                                new BsonDocument("$toDecimal", "$NetClosing"),
                                                3
                                            }) }
                                    })
                            };
            var positionSet30 = yTDPandLHistoryCollection.Aggregate<BsonDocument>(pipeline30, aggregateOptions).ToList();
            List<YTDPandLHistory> positionList30 = BsonHelper.ConvertBsonDocumentListToModel<YTDPandLHistory>(positionSet30).ToList();

            var pipeline31 = new List<BsonDocument> {
                                new BsonDocument("$match",
                                new BsonDocument("Date",
                                new BsonDocument("$lte", BsonDateTime.Create(new DateTime(pastYear, pastMonth, pastDay))))),
                                new BsonDocument("$sort", new BsonDocument("Date", -1)),
                                new BsonDocument("$group",
                                new BsonDocument
                                    {
                                        { "_id",
                                new BsonDocument
                                        {
                                            { "Name", "$Name" },
                                            { "CompanyName", "$CompanyName" }
                                        } },
                                        { "YTDTotalPAndL",
                                new BsonDocument("$first", "$YTDTotalPAndL") },
                                        { "NetClosing",
                                new BsonDocument("$first", "$NetClosing") }
                                    }),
                                new BsonDocument("$project",
                                new BsonDocument
                                    {
                                        { "_id", 0 },
                                        { "Name", "$_id.Name" },
                                        { "CompanyName", "$_id.CompanyName" },
                                        { "YTDTotalPAndL",
                                new BsonDocument("$round",
                                new BsonArray
                                            {
                                                new BsonDocument("$toDecimal", "$YTDTotalPAndL"),
                                                3
                                            }) },
                                        { "NetClosing",
                                new BsonDocument("$round",
                                new BsonArray
                                            {
                                                new BsonDocument("$toDecimal", "$NetClosing"),
                                                3
                                            }) }
                                    })
                            };
            var positionSet31 = yTDPandLHistoryCollection.Aggregate<BsonDocument>(pipeline31, aggregateOptions).ToList();
            List<YTDPandLHistory> positionList31 = BsonHelper.ConvertBsonDocumentListToModel<YTDPandLHistory>(positionSet31).ToList();

            var vesselsQuery = new List<BsonDocument>
            {
                new BsonDocument("$match",
                new BsonDocument
                    {
                        { "DataSourceId",
                new BsonDocument("$in",
                new BsonArray(purchageFormIds)) },
                        { "IsArchived", false },
                    { "DataJson.FormData.uniqueIdImportLocal", new BsonDocument("$nin", new BsonArray{ "", BsonNull.Value ," "}) }
                    }),
                new BsonDocument("$project",
                new BsonDocument
                    {
                        { "_id", 0 },
                        { "UniqueIdImportLocal", "$DataJson.FormData.uniqueIdImportLocal" },
                        { "Commodity", "$DataJson.FormData.commodity" },
                        { "Type",  new BsonDocument("$cond",
                        new BsonArray {
                                        new BsonDocument("$or",
                                        new BsonArray {
                                                new BsonDocument("$eq",
                                                new BsonArray
                                                    {
                                                        "$DataJson.FormData.uniqueIdLocal",
                                                        BsonNull.Value
                                                    }),
                                                new BsonDocument("$eq",
                                                new BsonArray
                                                    {
                                                        "$DataJson.FormData.uniqueIdLocal",
                                                        ""
                                                    }),
                                                new BsonDocument("$eq",
                                                new BsonArray
                                                    {
                                                        "$DataJson.FormData.uniqueIdLocal",
                                                        " "
                                                    })
                                            }),
                                        "IMPORTED",
                                        "LOCAL"
                                    }) },
                        { "CompanyName", "$DataJson.FormData.entity" }
                    })
            };
            var vesselsList = datasetCollection.Aggregate<BsonDocument>(vesselsQuery, aggregateOptions).ToList();
            List<VesselLoopModel> vessels = BsonHelper.ConvertBsonDocumentListToModel<VesselLoopModel>(vesselsList).ToList();
            List<string> comapnies = new List<string>(Companies.Values);
            var vstodate = new List<VesselDashboardOutputModel>();
            foreach (var v in vessels)
            {
                try
                {
                    var cn = v.CompanyName == "UMIRO" || v.CompanyName == "UMIRO-INDIA" ? "Umiro-INDIA" : v.CompanyName;
                    Companies.TryGetValue(cn, out string cid);
                    loggedInContext.CompanyGuid = Guid.Parse(cid);
                    var vessel = GetVesselDashboard(new VesselDashboardInputModel
                    {
                        ProductType = v.Type,
                        CompanyName = v.CompanyName == "UMIRO" || v.CompanyName == "UMIRO-INDIA" ? "Umiro-INDIA" : v.CompanyName,
                        ContractUniqueId = v.UniqueIdImportLocal,
                        FromDate = fromDate,
                        Todate = toDate1
                    }, loggedInContext, new List<ValidationMessage>(), true);
                    vessel.CompanyName = v.CompanyName == "UMIRO" || v.CompanyName == "UMIRO-INDIA" ? "Umiro-INDIA" : "ANA-INDIA";
                    vstodate.Add(vessel);
                }
                catch (Exception exception)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPositionsDashboard", "DashboardRepositoryNew", exception));
                    SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionGetQueryData);
                }
            }

            foreach (var parent in PositionCommodities.Where(x => x.ParentId == 0).OrderBy(x => x.Order))
            {
                try
                {
                    decimal usdToInr = positionList11.FirstOrDefault(x => x.CompanyName == parent.CompanyName?.ToLower() && x.Commodity == parent.NameLower)?.USDToInr ?? 0;
                    decimal usdToInr_MTM = positionList8.FirstOrDefault(x => x.USDToInr > 0)?.USDToInr ?? 0;
                    decimal oldUsdToInr = positionList8.FirstOrDefault(x => x.USDToInr > 0)?.OldUSDToInr ?? 0;
                    decimal dayChangeMtm = (oldUsdToInr == 0) ? 0 : (usdToInr_MTM - oldUsdToInr) * 100 / oldUsdToInr;
                    List<PositionData> positionDataChilds = new List<PositionData>();

                    PositionList7 dailyMTM = positionList8.FirstOrDefault(x => x.CompanyName?.ToLower() == parent.CompanyName?.ToLower() && x.Commodity?.ToLower() == parent.Name?.ToLower());
                    PositionList7 previousDayMTM = positionList8.FirstOrDefault(x => x.CompanyName?.ToLower() == parent.CompanyName?.ToLower() && x.Commodity?.ToLower() == parent.Name?.ToLower());
                    PositionList1 openingBalance = positionList1.FirstOrDefault(x => (x.Commodity?.ToLower() == parent.Name?.ToLower()) && (x.CompanyName?.ToLower() == parent.CompanyName?.ToLower()));
                    PositionData positionData = new PositionData();
                    var previousDayaData = positionList30.FirstOrDefault(x => x.CompanyName.ToLower() == parent.CompanyName?.ToLower() && x.Name?.ToLower() == parent.NameLower?.ToLower());
                    decimal prevDayNetClosing = previousDayaData?.NetClosing ?? 0;
                    decimal daypnl = previousDayaData?.YTDTotalPAndL ?? 0;
                    decimal mpnl = positionList31.FirstOrDefault(x => x.CompanyName.ToLower() == parent.CompanyName?.ToLower() && x.Name?.ToLower() == parent.NameLower?.ToLower())?.YTDTotalPAndL ?? 0;

                    positionData.PositionName = parent.Position;
                    positionData.Commodity = parent.DisplayName;
                    positionData.CommodityKey = parent.Name;
                    positionData.Order = parent.Order;
                    positionData.Id = parent.Id;
                    positionData.IsGroupBy = parent.IsGroupBy;
                    positionData.CompanyName = parent.CompanyName;
                    positionData.Position = parent.Position;
                    positionData.IsBold = parent.DisplayName?.Contains("Total") ?? false;
                    positionData.OpeningBalance = openingBalance?.OpeningBalance ?? 0;

                    if (parent.Position == "PAPER & FUTURES")
                    {
                        positionData.YTDgross = positionList20.FirstOrDefault(x => x.CompanyName?.ToLower() == parent.CompanyName?.ToLower() && x.ParentCommodity?.ToLower() == parent.NameLower?.ToLower())?.TotalQty ?? 0;
                        positionData.YTDgross1 = positionList21.FirstOrDefault(x =>
                                                    x.CompanyName.ToLower() == parent.CompanyName.ToLower() &&
                                                    x.ParentCommodity == parent.NameLower &&
                                                    x.Month == monthsList.First(x => x.Order == 1).Month &&
                                                    x.Year == monthsList.First(x => x.Order == 1).Year)?.TotalQty ?? 0;
                        positionData.YTDgross2 = positionList21.FirstOrDefault(x =>
                                                    x.CompanyName.ToLower() == parent.CompanyName.ToLower() &&
                                                    x.ParentCommodity == parent.NameLower &&
                                                    x.Month == monthsList.First(x => x.Order == 2).Month &&
                                                    x.Year == monthsList.First(x => x.Order == 2).Year)?.TotalQty ?? 0;
                        positionData.YTDgross3 = positionList21.FirstOrDefault(x =>
                                                    x.CompanyName.ToLower() == parent.CompanyName.ToLower() &&
                                                    x.ParentCommodity == parent.NameLower &&
                                                    x.Month == monthsList.First(x => x.Order == 3).Month &&
                                                    x.Year == monthsList.First(x => x.Order == 3).Year)?.TotalQty ?? 0;
                        positionData.YTDgross4 = positionList21.FirstOrDefault(x =>
                                                    x.CompanyName.ToLower() == parent.CompanyName.ToLower() &&
                                                    x.ParentCommodity == parent.NameLower &&
                                                    x.Month == monthsList.First(x => x.Order == 4).Month &&
                                                    x.Year == monthsList.First(x => x.Order == 4).Year)?.TotalQty ?? 0;
                        positionData.YTDgross5 = positionList21.FirstOrDefault(x =>
                                                    x.CompanyName.ToLower() == parent.CompanyName.ToLower() &&
                                                    x.ParentCommodity == parent.NameLower &&
                                                    x.Month == monthsList.First(x => x.Order == 5).Month &&
                                                    x.Year == monthsList.First(x => x.Order == 5).Year)?.TotalQty ?? 0;
                        positionData.YTDgross6 = positionList21.FirstOrDefault(x =>
                                                    x.CompanyName.ToLower() == parent.CompanyName.ToLower() &&
                                                    x.ParentCommodity == parent.NameLower &&
                                                    x.Month == monthsList.First(x => x.Order == 6).Month &&
                                                    x.Year == monthsList.First(x => x.Order == 6).Year)?.TotalQty ?? 0;
                        positionData.YTDgross7 = positionList21.FirstOrDefault(x =>
                                                    x.CompanyName.ToLower() == parent.CompanyName.ToLower() &&
                                                    x.ParentCommodity == parent.NameLower &&
                                                    x.Month == monthsList.First(x => x.Order == 7).Month &&
                                                    x.Year == monthsList.First(x => x.Order == 7).Year)?.TotalQty ?? 0;
                        positionData.TotalGross = positionData.YTDgross + positionData.YTDgross2 + positionData.YTDgross3 +
                                                  positionData.YTDgross4 + positionData.YTDgross5 + positionData.YTDgross6 + positionData.YTDgross7;
                        positionData.NetClosing = positionData.TotalGross;
                        positionData.NetOpening = prevDayNetClosing;
                        positionData.DayChange = positionData.NetClosing - positionData.NetOpening;
                        positionData.DailyMTM = parent.Name?.Contains("PKPG-") == true ? dailyMTM?.CnfRateUsd ?? 0 : dailyMTM?.DerivedMdexRateUsd ?? 0;
                        positionData.DayChangeMtm = parent.Name?.Contains("PKPG-") == true ?
                                                     (previousDayMTM?.OldCnfRateUsd ?? 0) == 0 ? 0 : (positionData.DailyMTM - previousDayMTM?.OldCnfRateUsd ?? 0) * 100 / previousDayMTM?.OldCnfRateUsd ?? 0
                                                    : (previousDayMTM?.OldDerivedMdexRateUsd ?? 0) == 0 ? 0 : (positionData.DailyMTM - previousDayMTM?.OldDerivedMdexRateUsd ?? 0) * 100 / previousDayMTM?.OldDerivedMdexRateUsd ?? 0;
                        positionData.YTDRealisedPAndL = positionData.OpeningBalance + ((dailyMTM?.SpotRateUsdMyr ?? 0) == 0 ? 0
                                                           : (decimal)(positionList22.FirstOrDefault(x => x.SourceCommodity == parent.NameLower && x.CompanyName == parent.CompanyName.ToLower())?.RealizedQty ?? 0) / (dailyMTM?.SpotRateUsdMyr ?? 0));
                        positionData.YTDUnRealisedPAndL = combinedData.Where(x => x.Commodity.ToLower() == parent.NameLower && x.CompanyName.ToLower() == parent.CompanyName.ToLower()).Sum(item => item.TotalValue);
                        positionData.YTDTotalPAndL = positionData.YTDRealisedPAndL + positionData.YTDUnRealisedPAndL;
                        positionData.DayPAndL = positionData.YTDTotalPAndL - daypnl;
                        positionData.MTDPAndL = positionData.YTDTotalPAndL - mpnl;
                        positionData.OpeningBalance = 0;
                    }
                    else if (parent.CompanyName == "SG-ANA" || parent.CompanyName == "ORIMU-SG")
                    {
                        PositionList9 sgData = positionList24.FirstOrDefault(x => x.SourceCommodity.ToLower() == parent.NameLower);
                        PositionList9 orimuData = positionList25.FirstOrDefault(x => x.SourceCommodity.ToLower() == parent.NameLower);
                        var cName = parent.CompanyName == "SG-ANA" ? "ANA-INDIA" : "UMIRO-INDIA";
                        positionData.OpeningBalance = -999999;
                        positionData.YTDgross7 = -88888;
                        positionData.YTDgross = parent.CompanyName == "SG-ANA" ? sgData?.TotalQty ?? 0 : orimuData?.TotalQty ?? 0;
                        positionData.TotalGross = (-1) * positionList26.FirstOrDefault(x => x.CompanyName == cName && x.Commodity.ToLower() == parent.NameLower)?.TotalQty ?? 0;
                        positionData.NetClosing = positionData.YTDgross + positionData.TotalGross;
                        positionData.NetOpening = prevDayNetClosing;
                        positionData.DayChange = positionData.NetClosing - positionData.NetOpening;
                        positionData.DailyMTM = dailyMTM?.CnfRateUsd ?? 0;
                        positionData.DayChangeMtm = (previousDayMTM?.OldCnfRateUsd ?? 0) == 0 ? 0 : (positionData.DailyMTM - previousDayMTM?.OldCnfRateUsd ?? 0) * 100 / previousDayMTM?.OldCnfRateUsd ?? 0;
                        positionData.YTDRealisedPAndL = parent.CompanyName == "SG-ANA" ? sgData?.Realized ?? 0 : orimuData?.Realized ?? 0;
                        positionData.YTDUnRealisedPAndL = parent.CompanyName == "SG-ANA" ? sgData?.UnRealized ?? 0 : orimuData?.UnRealized ?? 0;
                        positionData.YTDTotalPAndL = positionData.YTDRealisedPAndL + positionData.YTDUnRealisedPAndL;
                        positionData.DayPAndL = positionData.YTDTotalPAndL - daypnl;
                        positionData.MTDPAndL = positionData.YTDTotalPAndL - mpnl;
                    }
                    else
                    {
                        positionData.YTDgross = positionData.OpeningBalance + positionList2.FirstOrDefault(x => x.CompanyName == parent.CompanyName && x.Commodity == parent.Name)?.TotalQty ?? 0;
                        positionData.YTDgross1 = positionList3.FirstOrDefault(x =>
                                                    x.CompanyName == parent.CompanyName &&
                                                    x.Commodity == parent.Name &&
                                                    x.Month == monthsList.First(x => x.Order == 1).Month &&
                                                    x.Year == monthsList.First(x => x.Order == 1).Year)?.TotalQty ?? 0;
                        positionData.YTDgross2 = positionList3.FirstOrDefault(x =>
                                                    x.CompanyName == parent.CompanyName &&
                                                    x.Commodity == parent.Name &&
                                                    x.Month == monthsList.First(x => x.Order == 2).Month &&
                                                    x.Year == monthsList.First(x => x.Order == 2).Year)?.TotalQty ?? 0;
                        positionData.YTDgross3 = positionList3.FirstOrDefault(x =>
                                                    x.CompanyName == parent.CompanyName &&
                                                    x.Commodity == parent.Name &&
                                                    x.Month == monthsList.First(x => x.Order == 3).Month &&
                                                    x.Year == monthsList.First(x => x.Order == 3).Year)?.TotalQty ?? 0;
                        positionData.YTDgross4 = positionList3.FirstOrDefault(x =>
                                                    x.CompanyName == parent.CompanyName &&
                                                    x.Commodity == parent.Name &&
                                                    x.Month == monthsList.First(x => x.Order == 4).Month &&
                                                    x.Year == monthsList.First(x => x.Order == 4).Year)?.TotalQty ?? 0;
                        positionData.YTDgross5 = positionList3.FirstOrDefault(x =>
                                                    x.CompanyName == parent.CompanyName &&
                                                    x.Commodity == parent.Name &&
                                                    x.Month == monthsList.First(x => x.Order == 5).Month &&
                                                    x.Year == monthsList.First(x => x.Order == 5).Year)?.TotalQty ?? 0;
                        positionData.YTDgross6 = positionList3.FirstOrDefault(x =>
                                                    x.CompanyName == parent.CompanyName &&
                                                    x.Commodity == parent.Name &&
                                                    x.Month == monthsList.First(x => x.Order == 6).Month &&
                                                    x.Year == monthsList.First(x => x.Order == 6).Year)?.TotalQty ?? 0;
                        positionData.YTDgross7 = positionList3.FirstOrDefault(x =>
                                                    x.CompanyName == parent.CompanyName &&
                                                    x.Commodity == parent.Name &&
                                                    x.Month == monthsList.First(x => x.Order == 7).Month &&
                                                    x.Year == monthsList.First(x => x.Order == 7).Year)?.TotalQty ?? 0;
                        positionData.TotalGross = positionData.YTDgross + positionData.YTDgross2 + positionData.YTDgross3 +
                                                  positionData.YTDgross4 + positionData.YTDgross5 + positionData.YTDgross6 + positionData.YTDgross7;
                        positionData.DailyMTM = parent.Id == 1 ? usdToInr_MTM : dailyMTM?.DerivedUsdRate ?? 0;
                        positionData.DayChangeMtm = parent.Id == 1 ? dayChangeMtm : ((previousDayMTM?.OldDerivedUsdRate ?? 0) == 0 ? 0 : (positionData.DailyMTM - previousDayMTM?.OldDerivedUsdRate ?? 0) * 100 / previousDayMTM?.OldDerivedUsdRate ?? 0);
                        positionData.YTDRealisedPAndL = (decimal)vstodate.Where(x => x.CompanyName.ToLower() == parent.CompanyName?.ToLower() && x.SourceCommodity?.ToLower() == parent.NameLower?.ToLower())?.Sum(x => x.PandLRealisedUSD);
                        var testc = vstodate.Where(x => x.CompanyName.ToLower() == parent.CompanyName?.ToLower() && x.SourceCommodity?.ToLower() == parent.NameLower?.ToLower());
                        foreach (var child in PositionCommodities.Where(x => x.ParentId == parent.Id))
                        {
                            PositionData positionDataChild = new PositionData();
                            positionDataChild.PositionName = child.Position;
                            positionDataChild.Order = child.Order;
                            positionDataChild.Commodity = child.DisplayName;
                            positionDataChild.CommodityKey = child.Name;
                            positionDataChild.CompanyName = child.CompanyName;
                            positionDataChild.Position = child.Position;
                            positionDataChild.Id = child.Id;
                            positionDataChild.YTDgross = child.NameLower == "loss" ?
                                                         (-1) * positionList12.FirstOrDefault(x => x.CompanyName?.ToLower() == parent.CompanyName?.ToLower() && x.Commodity?.ToLower() == child.NameKey.ToLower() && x.ParentCommodity.ToLower() == parent.NameKey.ToLower())?.TotalQty ?? 0
                                                              : child.NameLower == "cancellation" ?
                                                                 positionList19.FirstOrDefault(x => x.CompanyName?.ToLower() == parent.CompanyName?.ToLower() && x.ProductGroup?.ToLower() == parent.Name?.ToLower())?.Cancellation ?? 0
                                                                   : (-1) * positionList4.Where(x => x.CompanyName?.ToLower() == parent.CompanyName?.ToLower()
                                                                         && x.ParentCommodity.ToLower() == parent.NameLower && x.Commodity.ToLower() == child.NameLower?.ToLower())?.Sum(x => x.TotalQty) ?? 0;
                            positionDataChild.YTDgross1 = (-1) * positionList5.Where(x =>
                                                        x.CompanyName == parent.CompanyName &&
                                                        x.Commodity.ToLower() == child.NameLower &&
                                                        x.ParentCommodity.ToLower() == parent.NameLower &&
                                                        x.Month == monthsList.First(x => x.Order == 1).Month &&
                                                        x.Year == monthsList.First(x => x.Order == 1).Year)?.Sum(x => x.TotalQty) ?? 0;
                            positionDataChild.YTDgross2 = (-1) * positionList5.Where(x =>
                                                        x.CompanyName == parent.CompanyName &&
                                                        x.Commodity.ToLower() == child.NameLower &&
                                                        x.ParentCommodity.ToLower() == parent.NameLower &&
                                                        x.Month == monthsList.First(x => x.Order == 2).Month &&
                                                        x.Year == monthsList.First(x => x.Order == 2).Year)?.Sum(x => x.TotalQty) ?? 0;
                            positionDataChild.YTDgross3 = (-1) * positionList5.Where(x =>
                                                        x.CompanyName == parent.CompanyName &&
                                                        x.Commodity.ToLower() == child.NameLower &&
                                                        x.ParentCommodity.ToLower() == parent.NameLower &&
                                                        x.Month == monthsList.First(x => x.Order == 3).Month &&
                                                        x.Year == monthsList.First(x => x.Order == 3).Year)?.Sum(x => x.TotalQty) ?? 0;
                            positionDataChild.YTDgross4 = (-1) * positionList5.Where(x =>
                                                        x.CompanyName == parent.CompanyName &&
                                                        x.Commodity.ToLower() == child.NameLower &&
                                                        x.ParentCommodity.ToLower() == parent.NameLower &&
                                                        x.Month == monthsList.First(x => x.Order == 4).Month &&
                                                        x.Year == monthsList.First(x => x.Order == 4).Year)?.Sum(x => x.TotalQty) ?? 0;
                            positionDataChild.YTDgross5 = (-1) * positionList5.Where(x =>
                                                        x.CompanyName == parent.CompanyName &&
                                                        x.Commodity.ToLower() == child.NameLower &&
                                                        x.ParentCommodity.ToLower() == parent.NameLower &&
                                                        x.Month == monthsList.First(x => x.Order == 5).Month &&
                                                        x.Year == monthsList.First(x => x.Order == 5).Year)?.Sum(x => x.TotalQty) ?? 0;
                            positionDataChild.YTDgross6 = (-1) * positionList5.Where(x =>
                                                        x.CompanyName == parent.CompanyName &&
                                                        x.Commodity.ToLower() == child.NameLower &&
                                                        x.ParentCommodity.ToLower() == parent.NameLower &&
                                                        x.Month == monthsList.First(x => x.Order == 6).Month &&
                                                        x.Year == monthsList.First(x => x.Order == 6).Year)?.Sum(x => x.TotalQty) ?? 0;
                            positionDataChild.YTDgross7 = (-1) * positionList5.Where(x =>
                                                        x.CompanyName == parent.CompanyName &&
                                                        x.Commodity.ToLower() == child.NameLower &&
                                                        x.ParentCommodity.ToLower() == parent.NameLower &&
                                                        x.Month == monthsList.First(x => x.Order == 7).Month &&
                                                        x.Year == monthsList.First(x => x.Order == 7).Year)?.Sum(x => x.TotalQty) ?? 0;
                            positionDataChild.TotalGross = positionDataChild.YTDgross + positionDataChild.YTDgross2 + positionDataChild.YTDgross3 +
                                                  positionDataChild.YTDgross4 + positionDataChild.YTDgross5 + positionDataChild.YTDgross6 + positionDataChild.YTDgross7;
                            positionDataChild.DayChange = (child.NameLower == "loss" ?
                                                             (-1) * positionList13.FirstOrDefault(x => x.CompanyName == parent.CompanyName && x.Commodity == child.NameKey)?.TotalQty ?? 0
                                                              : child.NameLower == "cancellation" ?
                                                                 positionList19.FirstOrDefault(x => x.CompanyName == parent.CompanyName && x.ProductGroup == parent.ProductGroup)?.Cancellation ?? 0
                                                                   : (-1) * positionList4.Where(x => x.CompanyName == parent.CompanyName
                                                                                  && x.ParentCommodity.ToLower() == parent.NameLower && x.Commodity.ToLower() == child.NameLower)?
                                                                       .Sum(x => x.TodayTotalQty) ?? 0);

                            positionDataChilds.Add(positionDataChild);
                        }
                        positionData.Children = positionDataChilds;
                        positionData.NetClosing = positionData.TotalGross + positionDataChilds.Sum(x => x.TotalGross);
                        positionData.NetOpening = prevDayNetClosing;
                        positionData.DayChange = positionData.NetClosing - positionData.NetOpening;
                        positionData.YTDUnRealisedPAndL = (decimal)vstodate.Where(x => x.CompanyName.ToLower() == parent.CompanyName?.ToLower() && x.SourceCommodity?.ToLower() == parent.NameLower?.ToLower())?.Sum(x => x.PandLUnRealisedUSD);
                        positionData.YTDTotalPAndL = positionData.YTDRealisedPAndL + positionData.YTDUnRealisedPAndL;
                        positionData.DayPAndL = positionData.YTDTotalPAndL - daypnl;
                        positionData.MTDPAndL = positionData.YTDTotalPAndL - mpnl;
                    }
                    positionDataList.Add(positionData);

                }
                catch (Exception exception)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPositionsDashboard", "DashboardRepositoryNew", exception));
                    continue;
                }
            }
            return positionDataList;
        }
    }
}
