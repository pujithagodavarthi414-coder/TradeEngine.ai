using formioCommon.Constants;
using formioModels;
using formioModels.Data;
using formioModels.PDFDocumentEditorModel;
using formioRepo.Helpers;
using Microsoft.AspNetCore.Authorization;
using Microsoft.Extensions.Configuration;
using Microsoft.VisualBasic.FileIO;
using Models.DeletePDFHTMLDesigner;
using MongoDB.Bson;
using MongoDB.Bson.Serialization;
using MongoDB.Driver;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using PDFHTMLDesignerModels.HTMLDocumentEditorModel;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;
using SharpCompress.Archives;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace formioRepo.PdfDesigner
{
    public class PdfDesignerRepository : IPdfDesignerRepository
    {
        private IConfiguration _iconfiguration;
        public PdfDesignerRepository(IConfiguration iconfiguration)
        {
            _iconfiguration = iconfiguration;
        }

        public HTMLDatasetOutputModel InsertHTMLDataSet(HTMLDatasetInputModel htmlDatasetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertHTMLDataSet", "HTMLDataSetRepository"));
                //var dynamicObject = JsonConvert.DeserializeObject<JObject>(htmlDatasetInputModel.TemplateTagStyles.ToString());

                var templateTagStylesBson = ConvertTemplateTagStylesListToBson(htmlDatasetInputModel.TemplateTagStyles);
                var templatePermissions = ConvertTemplatePermissionsListToBson(htmlDatasetInputModel.TemplatePermissions);

                var template = new
                {
                    _id = htmlDatasetInputModel._id.ToString(),
                    FileType = htmlDatasetInputModel.FileType,
                    FileName = htmlDatasetInputModel.FileName,
                    TemplateType = htmlDatasetInputModel.TemplateType,
                    HTMLFile = htmlDatasetInputModel.HTMLFile,
                    SfdtJson = htmlDatasetInputModel.SfdtJson,
                    DataSources = htmlDatasetInputModel.DataSources,
                    CreatedByUserId = htmlDatasetInputModel.CreatedByUserId,
                    CreatedDateTime = htmlDatasetInputModel.CreatedDateTime,
                    UpdatedByUserId = htmlDatasetInputModel.UpdatedByUserId,
                    UpdatedDateTime = htmlDatasetInputModel.UpdatedDateTime,
                    ArchivedByUserId = htmlDatasetInputModel.ArchivedByUserId,
                    ArchivedDateTime = htmlDatasetInputModel.ArchivedDateTime,
                    TemplateTagStyles = templateTagStylesBson,
                    TemplatePermissions = templatePermissions,
                    AllowAnonymous = htmlDatasetInputModel.AllowAnonymous,
                    IsArchived = htmlDatasetInputModel.IsArchived,
                };

                IMongoCollection<BsonDocument> fileCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.HTMLDataSetCollection);
                fileCollections.InsertOne(template.ToBsonDocument());

                //var documents = fileCollections.Find(new BsonDocument()).ToList();
                //var output = BsonHelper.ConvertBsonDocumentListToModel<HTMLDatasetInputModel>(documents);
                //var filteredResult = output.AsQueryable<HTMLDatasetInputModel>().LastOrDefault();
                HTMLDatasetOutputModel hTMLDatasetOutput = new HTMLDatasetOutputModel();
                hTMLDatasetOutput._id = htmlDatasetInputModel._id;
                hTMLDatasetOutput.HTMLFile = htmlDatasetInputModel.HTMLFile;
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertHTMLDataSet", "HTMLDataSetRepository"));
                return hTMLDatasetOutput;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertHTMLDataSet", "HTMLDataSetRepository", exception.Message), exception);
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.FileIdNotExists
                });
                return null;
            }
        }

        public string UpdateHTMLDataSetById(HTMLDatasetEditModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateHTMLDataSetById", "HTMLDataSetRepository"));

                IMongoCollection<BsonDocument> htmlDatasetCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.HTMLDataSetCollection);
                var currentUtcTime = DateTime.UtcNow;

                var templateTagStylesBson = ConvertTemplateTagStylesListToBson(inputModel.TemplateTagStyles);
                var templatePermissions = ConvertTemplatePermissionsListToBson(inputModel.TemplatePermissions);

                var fBuilder = Builders<BsonDocument>.Filter;
                var filterObject = fBuilder.Eq("_id", inputModel._id.ToString());
                var unixDateTime = DateTimeOffset.Now.ToUnixTimeMilliseconds();
                string filename = inputModel.FileName;
                var updateList = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("FileId", inputModel._id),
                    Builders<BsonDocument>.Update.Set("TemplateType", inputModel.TemplateType),
                    Builders<BsonDocument>.Update.Set("FileName", filename),
                    Builders<BsonDocument>.Update.Set("HTMLFile", inputModel.HtmlJson),
                    Builders<BsonDocument>.Update.Set("SfdtJson", inputModel.SfdtJson),
                    Builders<BsonDocument>.Update.Set("TemplateTagStyles", templateTagStylesBson),
                    Builders<BsonDocument>.Update.Set("TemplatePermissions", templatePermissions),
                    Builders<BsonDocument>.Update.Set("AllowAnonymous", inputModel.AllowAnonymous),
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", currentUtcTime),
                    Builders<BsonDocument>.Update.Set("DataSources", inputModel.DataSources),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId.ToString()),
                };

                var updateObject = Builders<BsonDocument>.Update.Combine(updateList);

                UpdateResult result = htmlDatasetCollections.UpdateOne(filter: filterObject, update: updateObject);

                if (result == null || result.ModifiedCount < 1)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.ExceptionUpdateDataSet
                    });
                    return null;
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateHTMLDataSetById", "HTMLDataSetRepository"));
                return inputModel._id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateHTMLDataSetById", "HTMLDataSetRepository", exception.Message), exception);
                return null;
            }
        }

        BsonValue ConvertTemplateTagStylesListToBson(List<TemplateTagStylesModel> templateTagStyles)
        {
            if (templateTagStyles == null)
            {
                return BsonNull.Value;
            }

            var bsonList = new List<BsonDocument>();

            foreach (var item in templateTagStyles)
            {
                var bsonDoc = new BsonDocument
        {
            {"TagName", item.TagName},
            {"Type", item.Type},
            {"Style", item.Style}
        };

                bsonList.Add(bsonDoc);
            }

            return new BsonArray(bsonList);
        }

        BsonValue ConvertTemplatePermissionsListToBson(List<TemplatePermissionsModel> templatePermissions)
        {
            if (templatePermissions == null)
            {
                return BsonNull.Value;
            }

            var bsonList = new List<BsonDocument>();

            foreach (var item in templatePermissions)
            {
                        var bsonDoc = new BsonDocument
                {
                    { "RoleId", item.RoleId != null ? item.RoleId.ToString() : BsonNull.Value },
                    { "RoleName", item.RoleName != null ? item.RoleName : BsonNull.Value },
                    { "UserId", item.UserId != null ? item.UserId.ToString() : BsonNull.Value },
                    { "UserName", item.UserName != null ? item.UserName : BsonNull.Value },
                    { "Permission", item.Permission != null ? item.Permission : BsonNull.Value }
                };

                bsonList.Add(bsonDoc);
            }

            return new BsonArray(bsonList);
        }

        public Guid? RemoveHTMLDataSetById(RemoveByIdInputModel removeById, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "RemoveHTMLDataSetById", "HTMLDataSetRepository"));
                IMongoCollection<BsonDocument> htmlDatasetCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.HTMLDataSetCollection);

                var currentUtcTime = DateTime.UtcNow;

                var fBuilder = Builders<BsonDocument>.Filter;
                var filterObject = fBuilder.Eq("_id", removeById._id.ToString());
                filterObject &= fBuilder.Eq("IsArchived", removeById.status);

                if (removeById.status == false)
                {
                    var updateList = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", DateTime.UtcNow),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId),
                    Builders<BsonDocument>.Update.Set("IsArchived", true),
                    Builders<BsonDocument>.Update.Set("ArchivedDateTime", DateTime.UtcNow),
                    Builders<BsonDocument>.Update.Set("ArchivedByUserId", loggedInContext.LoggedInUserId),
                };
                    var updateObject = Builders<BsonDocument>.Update.Combine(updateList);

                    UpdateResult result = htmlDatasetCollections.UpdateOne(filter: filterObject, update: updateObject);

                    if (result == null || result.ModifiedCount < 1)
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = ValidationMessages.ExceptionUpdateDataSet
                        });
                        return null;
                    }
                    else
                    {
                        return removeById._id;
                    }
                }
                else if (removeById.status == true)
                {
                    var updateList = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", DateTime.UtcNow),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId),
                    Builders<BsonDocument>.Update.Set("IsArchived", false),

                };
                    var updateObject = Builders<BsonDocument>.Update.Combine(updateList);

                    UpdateResult result = htmlDatasetCollections.UpdateOne(filter: filterObject, update: updateObject);

                    if (result == null || result.ModifiedCount < 1)
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = ValidationMessages.ExceptionUpdateDataSet
                        });
                        return null;
                    }
                    else
                    {
                        return removeById._id;
                    }

                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "RemoveHTMLDataSetById", "HTMLDataSetRepository"));
                return removeById._id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "RemoveHTMLDataSetById", "HTMLDataSetRepository", exception.Message), exception);
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.FileIdNotExists
                });
                return null;
            }
        }

        public List<TemplateOutputModel> GetHTMLDataSetById(Guid id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetHTMLDataSetById", "HTMLDataSetRepository"));
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.HTMLDataSetCollection);

                var pipeline = new List<BsonDocument>
                                                {
                                new BsonDocument("$match",
                                new BsonDocument("_id", id.ToString())),
                                new BsonDocument("$project",
                                new BsonDocument
                                    {
                                        { "_id", 1 },
                                        { "FileName", 1 },
                                        { "TemplateType", 1 },
                                        { "HTMLFile", 1 },
                                        { "DataSources", 1 },
                                        { "CreatedDateTime", 1 },
                                        { "UpdatedDateTime", 1 },
                                        { "IsArchived", 1 },
                                        { "SfdtJson", 1 },
                                        { "TemplateTagStyles" ,1 },
                                        { "TemplatePermissions" ,1 },
                                        { "AllowAnonymous" ,1 }
                                    })
                            };

                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = dataCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                var templates = BsonHelper.ConvertBsonDocumentListToModel<TemplateOutputModel>(aggregateDataList);


                var htmloutput = BsonHelper.ConvertBsonDocumentListToModel<TemplateOutputModel>(aggregateDataList);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetHTMLDataSetById", "HTMLDataSetRepository"));
                return htmloutput;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetHTMLDataSetById", "HTMLDataSetRepository", exception.Message), exception);
                return null;
            }
        }
        
        public List<TemplateOutputModel> GetHTMLDataSetByIdUnAuth(Guid id, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetHTMLDataSetById", "HTMLDataSetRepository"));
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.HTMLDataSetCollection);

                var pipeline = new List<BsonDocument>
                                                {
                                new BsonDocument("$match", new BsonDocument
                                    {
                                        { "_id", id.ToString() },
                                        { "AllowAnonymous", true } 
                                    }),
                                new BsonDocument("$project",
                                new BsonDocument
                                    {
                                        { "_id", 1 },
                                        { "FileName", 1 },
                                        { "TemplateType", 1 },
                                        { "HTMLFile", 1 },
                                        { "DataSources", 1 },
                                        { "CreatedDateTime", 1 },
                                        { "UpdatedDateTime", 1 },
                                        { "IsArchived", 1 },
                                        { "SfdtJson", 1 },
                                        { "TemplateTagStyles" ,1 },
                                        { "AllowAnonymous" ,1 }
    })
                            };

                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = dataCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                var templates = BsonHelper.ConvertBsonDocumentListToModel<TemplateOutputModel>(aggregateDataList);


                var htmloutput = BsonHelper.ConvertBsonDocumentListToModel<TemplateOutputModel>(aggregateDataList);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetHTMLDataSetById", "HTMLDataSetRepository"));
                return htmloutput;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetHTMLDataSetById", "HTMLDataSetRepository", exception.Message), exception);
                return null;
            }
        }

        public List<TemplateOutputModel> GetAllHTMLDataSet(bool IsArchived, string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                IsArchived = IsArchived ? IsArchived : false;
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllHTMLDataSet", "HTMLDataSetRepository"));
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.HTMLDataSetCollection);

                var matchFilter = new BsonDocument("$match", new BsonDocument
                    {
                        { "IsArchived", IsArchived } // Assuming IsArchived is a variable with the desired value
                    });

                if (!string.IsNullOrEmpty(searchText))
                {
                    matchFilter["$match"].AsBsonDocument.Add("FileName", new BsonDocument("$regex", new BsonRegularExpression(searchText, "i")));
                }

                var projectFields = new BsonDocument
                    {
                        { "_id", 1 },
                        { "FileName", 1 },
                        { "TemplateType", 1 },
                        { "HTMLFile", 1 },
                        { "DataSources", 1 },
                        { "CreatedDateTime", 1 },
                        { "UpdatedDateTime", 1 },
                        { "IsArchived", 1 },
                        { "SfdtJson", 1 },
                        { "TemplateTagStyles", 1 },
                        { "TemplatePermissions", 1 },
                        {"AllowAnonymous",1 }
                    };

                var projectFilter = new BsonDocument("$project", projectFields);

                var pipeline = new List<BsonDocument> { matchFilter, projectFilter };
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = dataCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                var templates = BsonHelper.ConvertBsonDocumentListToModel<TemplateOutputModel>(aggregateDataList);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllHTMLDataSet", "HTMLDataSetRepository"));
                return templates;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllHTMLDataSet", "HTMLDataSetRepository", exception.Message), exception);
                return null;
            }
        }


        public List<object> ValidateAndRunMongoQuery(string MongoQuery, string MongoCollectionName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ValidateAndRunMongoQuery", "HTMLDataSetRepository"));
                if (string.IsNullOrEmpty(MongoCollectionName))
                {

                }
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSet);

                var query = BsonSerializer.Deserialize<BsonDocument[]>(MongoQuery).ToList();

                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = dataCollection.Aggregate<BsonDocument>(query, aggregateOptions).ToList();
                var result = BsonHelper.ConvertBsonDocumentListToModel<object>(aggregateDataList);
                if (result == null)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = "No records found for this mongo query, please recheck the mongo parameter values"
                    });
                    return null;
                }
                //string resultJson = result.ToJson();
                return result;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ValidateAndRunMongoQuery", "HTMLDataSetRepository", exception.Message), exception);
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = exception.Message
                });
                return null;
            }
        }
        public string ValidateAndRunMongoQueryUnAuth(string MongoQuery, string MongoCollectionName, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ValidateAndRunMongoQueryUnAuth", "HTMLDataSetRepository"));
                if (string.IsNullOrEmpty(MongoCollectionName))
                {

                }
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSet);

                var query = BsonSerializer.Deserialize<BsonDocument[]>(MongoQuery).ToList();

                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var result = dataCollection.Aggregate<BsonDocument>(query, aggregateOptions).FirstOrDefault();
                if (result == null)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = "No records found for this mongo query, please recheck the mongo parameter values"
                    });
                    return null;
                }
                string resultJson = result.ToJson();
                return resultJson;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ValidateAndRunMongoQueryUnAuth", "HTMLDataSetRepository", exception.Message), exception);
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = exception.Message
                });
                return null;
            }
        }


        public string SaveMenuDataSet(MenuDatasetInputModel menuDatasetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SaveMenuDataSet", "HTMLDataSetRepository"));
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.PdfDataSetCollection);
                dataCollection.InsertOne(menuDatasetInputModel.ToBsonDocument());

                var documents = dataCollection.Find(new BsonDocument()).ToList();
                var output = BsonHelper.ConvertBsonDocumentListToModel<MenuDatasetInputModel>(documents);
                var filteredResult = output.AsQueryable<MenuDatasetInputModel>().LastOrDefault();
                HTMLDatasetOutputModel hTMLDatasetOutput = new HTMLDatasetOutputModel();
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SaveMenuDataSet", "HTMLDataSetRepository"));
                return menuDatasetInputModel.DataSource;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SaveMenuDataSet", "HTMLDataSetRepository", exception.Message), exception);
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.FileIdNotExists
                });
                return null;
            }
        }

        public string UpdateMenuDataSet(MenuDatasetInputModel menuDatasetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSet", "HTMLDataSetRepository"));
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.PdfDataSetCollection);
                var fBuilder = Builders<BsonDocument>.Filter;
                var filterObject = fBuilder.Eq("_id", menuDatasetInputModel._id.ToString());
                var updateList = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("MongoResult",   menuDatasetInputModel.MongoResult),
                    Builders<BsonDocument>.Update.Set("TemplateId", menuDatasetInputModel.TemplateId),
                    Builders<BsonDocument>.Update.Set("DataSource", menuDatasetInputModel.DataSource),
                    Builders<BsonDocument>.Update.Set("MongoQuery", menuDatasetInputModel.MongoQuery),
                    Builders<BsonDocument>.Update.Set("MongoParamsType", menuDatasetInputModel.MongoParamsType),
                    Builders<BsonDocument>.Update.Set("MongoDummyParams", menuDatasetInputModel.MongoDummyParams),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", menuDatasetInputModel.UpdatedByUserId),
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", menuDatasetInputModel.UpdatedDateTime),
                    Builders<BsonDocument>.Update.Set("Archive", menuDatasetInputModel.Archive),

                };

                var updateObject = Builders<BsonDocument>.Update.Combine(updateList);

                UpdateResult result = dataCollection.UpdateOne(filter: filterObject, update: updateObject);

                if (result == null || result.ModifiedCount < 1)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.ExceptionUpdateDataSet
                    });
                    return null;
                }


                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateMenuDataSet", "HTMLDataSetRepository"));
                return menuDatasetInputModel.DataSource;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateMenuDataSet", "HTMLDataSetRepository", exception.Message), exception);
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.FileIdNotExists
                });
                return null;
            }
        }
        public List<PDFDesignerDatasetOutputModel> GetAllPDFMenuDataSet(string TemplateId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchPDFMenuDataSet", "PDFMenuDataSetRepository"));
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.PdfDataSetCollection);
                var fBuilder = Builders<BsonDocument>.Filter;
                var filterObject = fBuilder.Eq("TemplateId", TemplateId);
                filterObject &= fBuilder.Eq("Archive", false);
                var documents = dataCollection.Find(filter: filterObject).ToList();

                var pdfoutput = BsonHelper.ConvertBsonDocumentListToModel<PDFDesignerDatasetOutputModel>(documents);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchPDFMenuDataSet", "PDFMenuDataSetRepository"));
                return pdfoutput;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchPDFMenuDataSet", "PDFMenuDataSetRepository", exception.Message), exception);
                return null;
            }
        }
        public List<PDFDesignerDatasetOutputModel> GetAllPDFMenuDataSetUnAuth(string TemplateId, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPDFTemplateUnAuth", "PDFMenuDataSetRepository"));
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.PdfDataSetCollection);
                var fBuilder = Builders<BsonDocument>.Filter;
                var filterObject = fBuilder.Eq("TemplateId", TemplateId);
                filterObject &= fBuilder.Eq("Archive", false);
                var documents = dataCollection.Find(filter: filterObject).ToList();

                var pdfoutput = BsonHelper.ConvertBsonDocumentListToModel<PDFDesignerDatasetOutputModel>(documents);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPDFTemplateUnAuth", "PDFMenuDataSetRepository"));
                return pdfoutput;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPDFTemplateUnAuth", "PDFMenuDataSetRepository", exception.Message), exception);
                return null;
            }
        }
        public FilterDefinition<BsonDocument> GetUpdateFilter(WebPageViewerModel webPageViewerModel, LoggedInContext loggedInContext)
        {
            var fBuilder = Builders<BsonDocument>.Filter;
            return fBuilder.And(fBuilder.Eq("Path", webPageViewerModel.Path.ToString()),
                         fBuilder.Eq("CompanyId", loggedInContext.CompanyGuid.ToString()),
                         fBuilder.Eq("IsArchived", false)
                         );
        }
        public WebPageViewerModel SaveWebPageView(WebPageViewerModel webPageViewerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWebPageView", "HTMLDataSetRepository"));
                IMongoCollection<BsonDocument> fileCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.WebPageViewerConfiguration);
                var fBuilder = Builders<BsonDocument>.Filter;
                var filterObject = fBuilder.Eq("Path", webPageViewerModel.Path);
                filterObject &= fBuilder.Eq("CompanyId", loggedInContext.CompanyGuid.ToString());
                var documents = fileCollections.Find(filter: filterObject).ToList();
                if (documents.Count > 0)
                {
                    var update = new List<UpdateDefinition<BsonDocument>>
                    {
                        Builders<BsonDocument>.Update.Set("UpdatedDateTime", DateTime.UtcNow),
                        Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId.ToString()),
                        Builders<BsonDocument>.Update.Set("IsArchived", true)
                    };
                    var updateBuilder = GetUpdateFilter(webPageViewerModel, loggedInContext);
                    FilterDefinition<BsonDocument> filter = updateBuilder;
                    var updateFields = Builders<BsonDocument>.Update.Combine(update);
                    fileCollections.UpdateMany(filter: updateBuilder, update: updateFields);
                }
                webPageViewerModel._id = Guid.NewGuid();
                webPageViewerModel.CompanyId = loggedInContext.CompanyGuid;
                webPageViewerModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                webPageViewerModel.CreatedDateTime = DateTime.Now;
                webPageViewerModel.IsArchived = false;
                fileCollections.InsertOne(webPageViewerModel.ToBsonDocument());
                //var documents1 = fileCollections.Find(new BsonDocument()).ToList();
                //var output = BsonHelper.ConvertBsonDocumentListToModel<HTMLDatasetInputModel>(documents1);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SaveWebPageView", "HTMLDataSetRepository"));
                return webPageViewerModel;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SaveWebPageView", "HTMLDataSetRepository", exception.Message), exception);
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.FileIdNotExists
                });
                return null;
            }
        }


        public List<WebPageViewerModel> GetWebPageView(string path, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWebPageView", "HTMLDataSetRepository"));
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.WebPageViewerConfiguration);
                var fBuilder = Builders<BsonDocument>.Filter;
                var filterObject = fBuilder.Eq("Path", path);
                filterObject &= fBuilder.Eq("CompanyId", loggedInContext.CompanyGuid.ToString());
                filterObject &= fBuilder.Eq("IsArchived", false);
                var documents = dataCollection.Find(filter: filterObject).ToList();

                var webPageViewerModelList = BsonHelper.ConvertBsonDocumentListToModel<WebPageViewerModel>(documents);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWebPageView", "PDFMenuDataSetRepository"));
                return webPageViewerModelList;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWebPageView", "HTMLDataSetRepository", exception.Message), exception);
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.FileIdNotExists
                });
                return null;
            }
        }

        public string StoreDownloadedTemplates(GenerateCompleteTemplatesOutputModel template, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "StoreDownloadedTemplates", "HTMLDataSetRepository"));
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.GeneratedInvoices);
                var fBuilder = Builders<BsonDocument>.Filter;
                var filterObject = fBuilder.Eq("GenericFormSubmittedId", template.GenericFormSubmittedId);
                filterObject &= fBuilder.Eq("InvoiceDowloadId", template.InvoiceDowloadId);
                var documents = dataCollection.Find(filter: filterObject).ToList();

                if (documents.Count > 0)
                {
                    var updateList = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("SfdtTemplatesToDownload", template.SfdtTemplatesToDownload),
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", DateTime.Now),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId),

                };

                    var updateObject = Builders<BsonDocument>.Update.Combine(updateList);

                    UpdateResult result = dataCollection.UpdateOne(filter: filterObject, update: updateObject);

                    if (result == null || result.ModifiedCount < 1)
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = ValidationMessages.ExceptionUpdateDataSet
                        });
                        return null;
                    }

                }
                else
                {
                    template._id = Guid.NewGuid();
                    template.CreatedByUserId = loggedInContext.LoggedInUserId;
                    template.CreatedDateTime = DateTime.Now;
                    template.UpdatedByUserId = null;
                    template.UpdatedDateTime = null;
                    dataCollection.InsertOne(template.ToBsonDocument());
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "StoreDownloadedTemplates", "PDFMenuDataSetRepository"));
                return template.InvoiceDowloadId;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "StoreDownloadedTemplates", "HTMLDataSetRepository", exception.Message), exception);
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.FileIdNotExists
                });
                return null;
            }
        }

        public List<GenerateCompleteTemplatesOutputModel> GetGeneratedInvoices(Guid GenericFormSubmittedId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGeneratedInvoices", "HTMLDataSetRepository"));
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.GeneratedInvoices);
                var currentUtcTime = DateTime.UtcNow;

                var filter = new List<BsonDocument>
                {
                    new BsonDocument("GenericFormSubmittedId", GenericFormSubmittedId.ToString())
                };


                var matchStage = new BsonDocument("$match",
                    BsonHelper.GetBsonDocumentWithConditionalObject("$and", filter));
                var stages = new List<BsonDocument>();
                stages.Add(matchStage);
                var pipeline = stages;
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = dataCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                var generatedInvoivces = BsonHelper.ConvertBsonDocumentListToModel<GenerateCompleteTemplatesOutputModel>(aggregateDataList);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGeneratedInvoices", "HTMLDataSetRepository"));
                return generatedInvoivces;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGeneratedInvoices", "HTMLDataSetRepository", exception.Message), exception);
                return null;
            }
        }

        public string UpdatePdfGeneratedValue(Guid GenericFormSubmittedId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdatePdfGeneratedValue", "HTMLDataSetRepository"));

                IMongoCollection<BsonDocument> htmlDatasetCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSet);
                var currentUtcTime = DateTime.UtcNow;

                var fBuilder = Builders<BsonDocument>.Filter;
                var filterObject = fBuilder.Eq("_id", GenericFormSubmittedId.ToString());
                var unixDateTime = DateTimeOffset.Now.ToUnixTimeMilliseconds();

                var updateList = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("IsPdfGenerated", true),

                };

                var updateObject = Builders<BsonDocument>.Update.Combine(updateList);

                UpdateResult result = htmlDatasetCollections.UpdateOne(filter: filterObject, update: updateObject);

                if (result == null || result.ModifiedCount < 1)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.ExceptionUpdateDataSet
                    });
                    return null;
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdatePdfGeneratedValue", "HTMLDataSetRepository"));
                return GenericFormSubmittedId.ToString();
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdatePdfGeneratedValue", "HTMLDataSetRepository", exception.Message), exception);
                return null;
            }
        }




        protected IMongoDatabase GetMongoDbConnection()
        {
            MongoClient client = new MongoClient(_iconfiguration["MongoDBConnectionString"]);
            return client.GetDatabase(_iconfiguration["MongoCommunicatorDB"]);
        }
        protected IMongoCollection<T> GetMongoCollectionObject<T>(string collectionName)
        {
            IMongoDatabase imongoDb = GetMongoDbConnection();
            return imongoDb.GetCollection<T>(collectionName);
        }
    }
}
