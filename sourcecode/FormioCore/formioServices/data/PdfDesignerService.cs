using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web.Http;
using formioCommon.Constants;
using formioHelpers;
using formioHelpers.Data;
using formioModels;
using formioModels.Data;
using formioModels.PDFDocumentEditorModel;
using formioRepo.DataSet;
using formioRepo.PdfDesigner;
using Models.DeletePDFHTMLDesigner;
using MongoDB.Bson;
using PDFHTMLDesignerModels.HTMLDocumentEditorModel;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;

namespace formioServices.data
{
    public class PdfDesignerService : IPdfDesignerService
    {
        private readonly IPdfDesignerRepository _pdfDesignerRepository;

        public PdfDesignerService(IPdfDesignerRepository iPdfDesignerRepository)
        {
            _pdfDesignerRepository = iPdfDesignerRepository;
        }


        public HTMLDatasetOutputModel InsertHTMLDataSet(HTMLDatasetInputModel htmlDatasetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertHTMLDataSet", "PdfDesignerService"));
            return _pdfDesignerRepository.InsertHTMLDataSet(htmlDatasetInputModel, loggedInContext, validationMessages);
        }

        public string UpdateHTMLDataSetById(HTMLDatasetEditModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateHTMLDataSetById", "HTMLDataSetService"));
            return _pdfDesignerRepository.UpdateHTMLDataSetById(inputModel, loggedInContext, validationMessages);
        }

        public Guid? RemoveHTMLDataSetById(RemoveByIdInputModel removeById, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "RemoveHTMLDataSetById", "HTMLDataSetService"));
            return _pdfDesignerRepository.RemoveHTMLDataSetById(removeById, loggedInContext, validationMessages);
        }

        public TemplateOutputModel GetHTMLDataSetById(Guid id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetHTMLDataSetById", "HTMLDataSetService"));
            return _pdfDesignerRepository.GetHTMLDataSetById(id, loggedInContext, validationMessages).FirstOrDefault();
        }
        public TemplateOutputModel GetHTMLDataSetByIdUnAuth(Guid id, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetHTMLDataSetById", "HTMLDataSetService"));
            return _pdfDesignerRepository.GetHTMLDataSetByIdUnAuth(id, validationMessages).FirstOrDefault();
        }
        
        public List<TemplateOutputModel> GetAllHTMLDataSet(bool IsArchived, string SearchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllHTMLDataSet", "HTMLDataSetService"));
            

            var templates = _pdfDesignerRepository.GetAllHTMLDataSet(IsArchived, SearchText, loggedInContext, validationMessages).OrderByDescending(template =>  template.UpdatedDateTime!=null ? template.UpdatedDateTime : template.CreatedDateTime).ToList();
            
            return templates;
        }
        

        public List<MenuDatasetInputModel> SaveDataSource(DataSourceDetailsInputModel dataSourceDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SaveDataSource", "HTMLDataSetService"));

                //to replace the tags im mongoQuery
                if (dataSourceDetailsInputModel.DataSourceMongoQuery != null && dataSourceDetailsInputModel.DataSourceDummyParamValues != null)
                {
                    dataSourceDetailsInputModel.DataSourceMongoQuery.MongoQueryWithDummyValues = dataSourceDetailsInputModel.DataSourceMongoQuery.MongoQuery;
                    foreach (var param in dataSourceDetailsInputModel.DataSourceDummyParamValues)
                    {
                        dataSourceDetailsInputModel.DataSourceMongoQuery.MongoQueryWithDummyValues = dataSourceDetailsInputModel.DataSourceMongoQuery.MongoQueryWithDummyValues.Replace('%' + param.Name + '%', param.Value);
                    }

                }
                List<object> resultsData = _pdfDesignerRepository.ValidateAndRunMongoQuery(dataSourceDetailsInputModel.DataSourceMongoQuery.MongoQueryWithDummyValues,null, loggedInContext, validationMessages);
                MenuDatasetInputModel menuDatasetInputModel = new MenuDatasetInputModel();
                List<MenuDatasetInputModel> result = new List<MenuDatasetInputModel>();

                if (resultsData != null && resultsData.Count>0)
                {
                    menuDatasetInputModel.MongoResult = resultsData[0].ToJson();
                    menuDatasetInputModel._id = dataSourceDetailsInputModel._id;
                    menuDatasetInputModel.TemplateId = dataSourceDetailsInputModel.TemplateId;
                    menuDatasetInputModel.DataSource = dataSourceDetailsInputModel.DataSourceMongoQuery.DataSource;
                    menuDatasetInputModel.MongoQuery = dataSourceDetailsInputModel.DataSourceMongoQuery.MongoQuery;
                    menuDatasetInputModel.MongoParamsType = dataSourceDetailsInputModel.DataSorceParamsType;
                    menuDatasetInputModel.MongoDummyParams = dataSourceDetailsInputModel.DataSourceDummyParamValues;
                    menuDatasetInputModel.Archive = dataSourceDetailsInputModel.Archive;
                    string saveMenuDataSetResult = null;
                    if (dataSourceDetailsInputModel.Update)
                    {
                        menuDatasetInputModel.UpdatedByUserId = loggedInContext.LoggedInUserId;
                        menuDatasetInputModel.UpdatedDateTime = DateTime.UtcNow;
                        saveMenuDataSetResult = _pdfDesignerRepository.UpdateMenuDataSet(menuDatasetInputModel, loggedInContext, validationMessages);
                    }
                    else
                    {
                        menuDatasetInputModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                        menuDatasetInputModel.CreatedDateTime = DateTime.UtcNow;
                        menuDatasetInputModel.UpdatedByUserId = null;
                        menuDatasetInputModel.UpdatedDateTime = null;
                        saveMenuDataSetResult = _pdfDesignerRepository.SaveMenuDataSet(menuDatasetInputModel, loggedInContext, validationMessages);
                    }

                    if (saveMenuDataSetResult != null)
                    {
                        result.Add(menuDatasetInputModel);
                        return result;
                    }
                }

                return null;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SaveDataSource", "HTMLDataSetRepository", exception.Message), exception);
                return null;
            }
        }

        public List<object> ValidateAndRunMongoQuery(List <MongoQueryInputModel> mongoQueryInputModelList, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ValidateAndRunMongoQuery", "HTMLDataSetService"));
                List<object> mongoQueriesResult = new List<object>();
                foreach (var mongoQueryInputModel in mongoQueryInputModelList)
                {
                    //to replace the tags im mongoQuery
                    if (mongoQueryInputModel.MongoQuery != null )
                    {
                        if (mongoQueryInputModel.DataSourceParamValues!=null && mongoQueryInputModel.DataSourceParamValues.Length>0)
                        {
                            foreach (var param in mongoQueryInputModel.DataSourceParamValues)
                            {
                                mongoQueryInputModel.MongoQuery = mongoQueryInputModel.MongoQuery.Replace('%' + param.Name + '%', param.Value);
                            }
                        }

                    }
                    mongoQueriesResult = _pdfDesignerRepository.ValidateAndRunMongoQuery(mongoQueryInputModel.MongoQuery, mongoQueryInputModel.MongoCollectionName, loggedInContext, validationMessages);
                }

                return mongoQueriesResult;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ValidateAndRunMongoQuery", "HTMLDataSetRepository", exception.Message), exception);
                return null;
            }
        }
        
        public List<string> ValidateAndRunMongoQueryUnAuth(List <MongoQueryInputModel> mongoQueryInputModelList, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ValidateAndRunMongoQueryUnAuth", "HTMLDataSetService"));
                List<string> mongoQueriesResult = new List<string>();
                foreach (var mongoQueryInputModel in mongoQueryInputModelList)
                {
                    //to replace the tags im mongoQuery
                    if (mongoQueryInputModel.MongoQuery != null )
                    {
                        if (mongoQueryInputModel.DataSourceParamValues!=null && mongoQueryInputModel.DataSourceParamValues.Length>0)
                        {
                            foreach (var param in mongoQueryInputModel.DataSourceParamValues)
                            {
                                mongoQueryInputModel.MongoQuery = mongoQueryInputModel.MongoQuery.Replace('%' + param.Name + '%', param.Value);
                            }
                        }

                    }
                    string resultsData = _pdfDesignerRepository.ValidateAndRunMongoQueryUnAuth(mongoQueryInputModel.MongoQuery, mongoQueryInputModel.MongoCollectionName, validationMessages);
                    mongoQueriesResult.Add(resultsData);
                }

                return mongoQueriesResult;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ValidateAndRunMongoQueryUnAuth", "HTMLDataSetRepository", exception.Message), exception);
                return null;
            }
        }

        public List<PDFDesignerDatasetOutputModel> GetAllPDFMenuDataSet(string TemplateId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllPDFMenuDataSet", "PDFMenuDataSetService"));
            return _pdfDesignerRepository.GetAllPDFMenuDataSet(TemplateId, loggedInContext, validationMessages);
        }

        public List<PDFDesignerDatasetOutputModel> GetAllPDFMenuDataSetUnAuth(string TemplateId, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPDFTemplateUnAuth", "PDFMenuDataSetService"));
            return _pdfDesignerRepository.GetAllPDFMenuDataSetUnAuth(TemplateId, validationMessages);
        }

        public WebPageViewerModel SaveWebPageView(WebPageViewerModel webPageViewerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SaveWebPageView", "HTMLDataSetService"));

                return _pdfDesignerRepository.SaveWebPageView(webPageViewerModel, loggedInContext, validationMessages);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SaveWebPageView", "HTMLDataSetRepository", exception.Message), exception);
                return null;
            }
        }
        public List<WebPageViewerModel> GetWebPageView(string path, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWebPageView", "HTMLDataSetService"));

                return _pdfDesignerRepository.GetWebPageView(path, loggedInContext, validationMessages);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWebPageView", "HTMLDataSetRepository", exception.Message), exception);
                return null;
            }
        }

        public List<string> StoreDownloadedTemplates(List<GenerateCompleteTemplatesOutputModel> downloadedTemplates, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                List<string> downloadTemplateIds = new List<string>();
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "StoreDownloadedTemplates", "HTMLDataSetService"));
                foreach (var template in downloadedTemplates)
                {

                    var templateId =  _pdfDesignerRepository.StoreDownloadedTemplates(template, loggedInContext, validationMessages);
                    if (templateId != null)
                    {
                        downloadTemplateIds.Add(templateId);
                    }
                }
                var genericFormSubmittedId = _pdfDesignerRepository.UpdatePdfGeneratedValue(downloadedTemplates[0].GenericFormSubmittedId, loggedInContext, validationMessages);

                return downloadTemplateIds;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "StoreDownloadedTemplates", "HTMLDataSetRepository", exception.Message), exception);
                return null;
            }
        }

        public List<GenerateCompleteTemplatesOutputModel> GetGeneratedInvoices(Guid GenericFormSubmittedId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllHTMLDataSet", "HTMLDataSetService"));


            var generatedInvoices = _pdfDesignerRepository.GetGeneratedInvoices(GenericFormSubmittedId, loggedInContext, validationMessages).OrderByDescending(template => template.UpdatedDateTime != null ? template.UpdatedDateTime : template.CreatedDateTime).ToList();

            return generatedInvoices;
        }


    }
}
