using formioModels;
using formioModels.PDFDocumentEditorModel;
using Models.DeletePDFHTMLDesigner;
using PDFHTMLDesignerModels.HTMLDocumentEditorModel;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioServices.data
{
    public interface IPdfDesignerService
    {
        HTMLDatasetOutputModel InsertHTMLDataSet(HTMLDatasetInputModel htmlDatasetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string UpdateHTMLDataSetById(HTMLDatasetEditModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? RemoveHTMLDataSetById(RemoveByIdInputModel removeById, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        TemplateOutputModel GetHTMLDataSetById(Guid id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        TemplateOutputModel GetHTMLDataSetByIdUnAuth(Guid id, List<ValidationMessage> validationMessages);
        List<TemplateOutputModel> GetAllHTMLDataSet(bool IsArchived, string SearchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages); 
        List<MenuDatasetInputModel> SaveDataSource(DataSourceDetailsInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<object> ValidateAndRunMongoQuery(List<MongoQueryInputModel> mongoQueryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<string> ValidateAndRunMongoQueryUnAuth(List<MongoQueryInputModel> mongoQueryInputModel, List<ValidationMessage> validationMessages);
        List<PDFDesignerDatasetOutputModel> GetAllPDFMenuDataSet(string TemplateId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PDFDesignerDatasetOutputModel> GetAllPDFMenuDataSetUnAuth(string TemplateId, List<ValidationMessage> validationMessages);
        public WebPageViewerModel SaveWebPageView(WebPageViewerModel webPageViewerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public List<WebPageViewerModel> GetWebPageView(string path, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public List<string> StoreDownloadedTemplates(List<GenerateCompleteTemplatesOutputModel> downloadedTemplates, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GenerateCompleteTemplatesOutputModel> GetGeneratedInvoices(Guid GenericFormSubmittedId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

    }
}
