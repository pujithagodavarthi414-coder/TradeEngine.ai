using BTrak.Common;
using Btrak.Models;
using Btrak.Services.FormDataServices;
using CamundaClient.Dto;
using CamundaClient.Worker;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unity;
using Btrak.Models.FormDataServices;
using Btrak.Models.GenericForm;
using Newtonsoft.Json;
using System.Data;
using Btrak.Models.WorkflowManagement;
using Btrak.Models.Widgets;
using Btrak.Services.DocumentStorageServices;
using Btrak.Models.File;

namespace BTrak.Workflow.Activities.Host.ActivityLibrary
{
    [ExternalTaskTopic("createdataset_activity")]
    public class CreateDataSetActivity : IExternalTaskAdapter
    {
        public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
        {
            try
            {
                LoggingManager.Info("Entering into create dataset : " + DateTime.Now.ToString());
                var dataSetService = Unity.UnityContainer.Resolve<DataSetService>();
                var dataSourceService = Unity.UnityContainer.Resolve<DataSourceService>();
                var documentStorageService = Unity.UnityContainer.Resolve<DocumentStorageService>();
                var dataSourceId = (string)externalTask.Variables["submittedFromId"].Value;
                var fromDataJson = (string)externalTask.Variables["fromDataJson"].Value;
                var authorization = (string)externalTask.Variables["authorization"].Value;
                var mongoBaseURL = (string)externalTask.Variables["mongoBaseURL"].Value;
                var documentBaseURL = (string)externalTask.Variables["documentBaseURL"].Value;
                var companyId = (string)externalTask.Variables["companyId"].Value;
                var loggedUserId = (string)externalTask.Variables["loggedUserId"].Value;
                var dataSetId = (string)externalTask.Variables["dataSetId"].Value;
                var jsonObject = JsonConvert.DeserializeObject<FormDataModel>((string)externalTask.Variables["jsonObject"].Value);

                Console.WriteLine("mongoBaseURL" + mongoBaseURL);
                Console.WriteLine("loggedUserId" + loggedUserId);
                Console.WriteLine("dataSourceId" + dataSourceId);
                Console.WriteLine("jsonObject" + jsonObject);

                LoggingManager.Debug("authorization" + authorization);
                LoggingManager.Debug("companyId" + companyId);
                LoggingManager.Debug("loggedUserId" + loggedUserId);
                var loggedInUser = new LoggedInContext
                {
                    authorization = authorization,
                    LoggedInUserId = new Guid(loggedUserId),
                    CompanyGuid = new Guid(companyId)
                };

                List<RecordCreationWorkflowModel> records = JsonConvert.DeserializeObject<List<RecordCreationWorkflowModel>>(fromDataJson);

                if(records != null && records.Count > 0)
                {
                    foreach(RecordCreationWorkflowModel record in records)
                    {
                        DataSetUpsertInputModel dataSetUpsertInputModel = new DataSetUpsertInputModel();
                        var dataSetModel = new DataSetConversionModel();
                        Guid insertionDataSetId = Guid.NewGuid();
                        dataSetModel.CustomApplicationId = record.CustomApplicationId;
                        dataSetModel.ContractType = "Form";
                        dataSetModel.InvoiceType = "CustomApplication";
                        dataSetModel.Status = "submitted";
                        dataSetModel.FormData = jsonObject;
                        //dataSetModel.FormData = JsonConvert.DeserializeObject<object>(dataJson);
                        dataSetUpsertInputModel.DataJson = JsonConvert.SerializeObject(dataSetModel);
                        dataSetUpsertInputModel.CompanyId = loggedInUser.CompanyGuid;
                        dataSetUpsertInputModel.DataSourceId = record.DataSourceId;
                        dataSetUpsertInputModel.IsNewRecord = true;
                        dataSetUpsertInputModel.Id = insertionDataSetId;

                        List<Dictionary<string, string>> keyValueList = JsonConvert.DeserializeObject<List<Dictionary<string, string>>>(record.DataJsonKeys);
                        
                        Dictionary<string, string> mergedkeyValueDictionary = new Dictionary<string, string>();

                        foreach (var dictionary in keyValueList)
                        {
                            foreach (var pair in dictionary)
                            {
                                mergedkeyValueDictionary[pair.Key] = pair.Value;
                            }
                        }

                        UpdateDataSetWorkflowModel dataModel = new UpdateDataSetWorkflowModel
                        {
                            DataSetUpsertInputModel = dataSetUpsertInputModel,
                            KeyValueList = mergedkeyValueDictionary,
                            MongoBaseURL = mongoBaseURL,
                            DataSetId = new Guid(dataSetId),
                            DataSourceId = new Guid(dataSourceId),
                            NewRecordDataSetId = insertionDataSetId,
                            NewRecordDataSourceId = record.DataSourceId
                        };

                        var newRecordId =  dataSetService.UpdateDataSetWorkflow(dataModel, loggedInUser).GetAwaiter().GetResult();
                        LoggingManager.Info("Exit from create dataset : " + DateTime.Now.ToString());
                        
                        //calling documents

                        if (record.IsFileUpload == true)
                        {
                            Guid? parentDataSourceId = new Guid(dataSourceId);
                            Guid? childDataSourceId = record.DataSourceId;
                            Guid? referenceId = new Guid("fd45f921-48f0-4b0b-b76e-cd2a92880437");
                            Guid? parentReferenceTypeId = new Guid(dataSetId);
                            var validationMessages = new List<ValidationMessage>();
                            var childKeys = dataSourceService.GetDataSourceKeys(null, childDataSourceId, "myfileuploads", mongoBaseURL, null, null, loggedInUser, validationMessages).GetAwaiter().GetResult();
                            List<FileApiServiceReturnModel> fileApiReturnModels = documentStorageService.SearchFiles(referenceId, parentReferenceTypeId, null, documentBaseURL,null, loggedInUser, validationMessages).GetAwaiter().GetResult();

                            if (childKeys != null && childKeys.Count > 0)
                            {
                                if (record.FileUploadKey == childKeys[0].Key)
                                {
                                    List<FileModel> filesList = new List<FileModel>();
                                    var parentFolderNames = new List<string>();
                                    parentFolderNames.Add("formuploads");

                                    foreach(var fileApiReturnModel in fileApiReturnModels)
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
                                    fileUpsertInputModel.ReferenceTypeId = insertionDataSetId;
                                    fileUpsertInputModel.ReferenceTypeName = childKeys[0].Key;
                                    fileUpsertInputModel.FilesList = filesList;
                                    fileUpsertInputModel.StoreId = null;
                                    fileUpsertInputModel.ParentFolderNames = parentFolderNames;
                                    fileUpsertInputModel.IsFromFeedback = false;
                                    fileUpsertInputModel.DocumentUrl = documentBaseURL;
                                    
                                    var fileIds = documentStorageService.UpsertMultipleFiles(fileUpsertInputModel, loggedInUser, validationMessages).GetAwaiter().GetResult();
                                }
                            }
                            
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                LoggingManager.Debug("create dataset Exception" + ex);
                LoggingManager.Error("create dataset Exception" + ex);
                Console.WriteLine(ex.Message);
            }
        }
    }
}
