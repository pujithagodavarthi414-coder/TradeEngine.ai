using System;
using System.Collections.Generic;
using System.Configuration;
using BTrak.Common;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using CamundaClient.Dto;
using CamundaClient.Worker;
using Btrak.Models.GenericForm;
using Btrak.Services.Email;
using Btrak.Services.WorkFlow;
using Unity;
using Btrak.Models.FormDataServices;
using Btrak.Services.FormDataServices;
using Newtonsoft.Json;
using Btrak.Models.File;
using Btrak.Services.DocumentStorageServices;
using System.Linq;
using Newtonsoft.Json.Linq;

namespace BTrak.Workflow.Activities.Host.ActivityLibrary
{
    [ExternalTaskTopic("fieldupdate_activity")]
    public class FieldUpdateActivity : IExternalTaskAdapter
    {
        public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
        {
            try
            {
                LoggingManager.Info("Entering into Sync form : " + DateTime.Now.ToString());
                var dataSetService = Unity.UnityContainer.Resolve<DataSetService>();
                var dataSourceService = Unity.UnityContainer.Resolve<DataSourceService>();
                var documentStorageService = Unity.UnityContainer.Resolve<DocumentStorageService>();
                var authorization = (string)externalTask.Variables["authorization"].Value;
                var documentBaseURL = (string)externalTask.Variables["documentBaseURL"].Value;
                var mongoBaseURL = (string)externalTask.Variables["mongoBaseURL"].Value;
                var companyId = (string)externalTask.Variables["companyId"].Value;
                var loggedUserId = (string)externalTask.Variables["loggedUserId"].Value;
                var fieldUniqueId = (string)externalTask.Variables["fieldUniqueId"].Value;
                var dataSetId = (string)externalTask.Variables["dataSetId"].Value;
                var dataSourceIdString = (string)externalTask.Variables["submittedFromId"].Value;
                var fieldUpdateModelJson = (string)externalTask.Variables["fieldUpdateModelJson"].Value;

                Console.WriteLine("mongoBaseURL" + mongoBaseURL);
                Console.WriteLine("loggedUserId" + loggedUserId);

                LoggingManager.Debug("authorization" + authorization);
                LoggingManager.Debug("companyId" + companyId);
                LoggingManager.Debug("loggedUserId" + loggedUserId);
                var loggedInUser = new LoggedInContext
                {
                    authorization = authorization,
                    LoggedInUserId = new Guid(loggedUserId),
                    CompanyGuid = new Guid(companyId)
                };

                /*File Uploads in fieldUpdate Start 
                 * Note: Seding the uploaded file names to update in forms */
                Guid? dataSourceId = new Guid(dataSourceIdString);
                Guid? referenceId = new Guid("fd45f921-48f0-4b0b-b76e-cd2a92880437");
                Guid? parentReferenceTypeId = new Guid(dataSetId);
                var validationMessages = new List<ValidationMessage>();
                List<FieldUpdateModel> updatedFields = new List<FieldUpdateModel>();
                updatedFields = JsonConvert.DeserializeObject<List<FieldUpdateModel>>(fieldUpdateModelJson);
                var keysDetailList = dataSourceService.GetDataSourceKeys(null, dataSourceId, "myfileuploads", mongoBaseURL, null, true, loggedInUser, validationMessages).GetAwaiter().GetResult();
                var uniqueKeysDetailList = dataSourceService.GetDataSourceKeys(null, dataSourceId, null, mongoBaseURL, null, true, loggedInUser, validationMessages).GetAwaiter().GetResult();
                var dataSetDetails = dataSetService.SearchDataSets(parentReferenceTypeId, null, null, null, false, false, 1, 20, loggedInUser, validationMessages, null, null, null, null, null, null, null, mongoBaseURL).GetAwaiter().GetResult();
                DataSetOutputModel dataSetByIdDetails = dataSetDetails[0];
                if (keysDetailList != null && keysDetailList.Count > 0)
                {
                    List<FileApiServiceReturnModel> fileApiReturnModels = documentStorageService.SearchFiles(referenceId, parentReferenceTypeId, null, documentBaseURL,null, loggedInUser, validationMessages).GetAwaiter().GetResult();
                    if (fileApiReturnModels != null && fileApiReturnModels.Count > 0)
                    {
                        List<FileModel> filesList = new List<FileModel>();

                        updatedFields = updatedFields.Where(x => x.FieldName != null).ToList();
                        var uniqueFieldModel = uniqueKeysDetailList.Where(x => x.Key == fieldUniqueId).FirstOrDefault();
                        foreach (FieldUpdateModel field in updatedFields)
                        {
                            string key = field.FieldName?.ToLower();
                            Guid? syncId = field.SyncForm;
                            var jsonData = JsonConvert.SerializeObject(dataSetByIdDetails.DataJson.FormData);
                            List<ParamsKeyModel> paramsModel = new List<ParamsKeyModel>();
                            dynamic formData = JsonConvert.DeserializeObject<dynamic>(jsonData);
                            var uniqueFieldValue = (string)formData[fieldUniqueId];
                            paramsModel.Add(new ParamsKeyModel()
                            {
                                KeyName = fieldUniqueId,
                                KeyValue = uniqueFieldValue,
                                Type = uniqueFieldModel?.Type,
                                IsFormData = true
                            });
                            string dataJsonModels = JsonConvert.SerializeObject(paramsModel);

                            var records = dataSetService.SearchDataSets(null, syncId, null, dataJsonModels, false, false, 1, 20, loggedInUser, validationMessages,null,null,null,null,null,null,null,mongoBaseURL).GetAwaiter().GetResult();
                            var updatedFieldIds = records.Select(x => x.Id);
                            
                            foreach(var updatedFieldId in updatedFieldIds)
                            {
                                if (fileApiReturnModels.Select(x => x.ReferenceTypeName).Contains(key))
                                {
                                    var parentFolderNames = new List<string>
                                {
                                    "formuploads"
                                };

                                    foreach (var fileApiReturnModel in fileApiReturnModels.Where(x => x.ReferenceTypeName.ToLower() == key).ToList())
                                    {
                                        var fileModel = new FileModel();
                                        fileModel.FileExtension = fileApiReturnModel.FileExtension;
                                        fileModel.FilePath = fileApiReturnModel.FilePath;
                                        fileModel.FileName = fileApiReturnModel.FileName;
                                        fileModel.FileSize = fileApiReturnModel.FileSize;
                                        fileModel.IsArchived = false;
                                        fileModel.Description = fileApiReturnModel.Description;
                                        filesList.Add(fileModel);
                                    }
                                    var fileUpsertInputModel = new UpsertFileInputModel();
                                    fileUpsertInputModel.ReferenceId = referenceId;
                                    fileUpsertInputModel.ReferenceTypeId = updatedFieldId;
                                    fileUpsertInputModel.ReferenceTypeName = field.FieldName;
                                    fileUpsertInputModel.FilesList = filesList;
                                    fileUpsertInputModel.StoreId = null;
                                    fileUpsertInputModel.ParentFolderNames = parentFolderNames;
                                    fileUpsertInputModel.IsFromFeedback = false;
                                    fileUpsertInputModel.DocumentUrl = documentBaseURL;
                                    var fileIds = documentStorageService.UpsertMultipleFiles(fileUpsertInputModel, loggedInUser, validationMessages).GetAwaiter().GetResult();
                                    field.FieldValue = string.Join(",", fileApiReturnModels.Select(x => x.FileName));

                                }
                                else
                                    continue;
                            }
                           
                        }
                    }
                }

                /*File Uploads in fieldUpdate End*/

                FieldUpdateWorkFlowModel dataModel = new FieldUpdateWorkFlowModel
                {
                    FieldUniqueId = fieldUniqueId,
                    FieldUpdateModelJson = JsonConvert.SerializeObject(updatedFields),
                    MongoBaseURL = mongoBaseURL,
                    DataSetId = new Guid(dataSetId)
                };

                dataSetService.FieldUpdateWorkFlow(dataModel, loggedInUser);
                LoggingManager.Info("Exit from Sync form : " + DateTime.Now.ToString());
            }
            catch (Exception ex)
            {
                LoggingManager.Debug("Sync form Exception" + ex);
                LoggingManager.Error("Sync form Exception" + ex);
                Console.WriteLine(ex.Message);
            }
        }
    }
}
