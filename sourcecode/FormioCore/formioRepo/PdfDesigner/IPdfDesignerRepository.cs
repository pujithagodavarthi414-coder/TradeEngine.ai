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

namespace formioRepo.PdfDesigner
{
    public interface IPdfDesignerRepository
    {
        HTMLDatasetOutputModel InsertHTMLDataSet(HTMLDatasetInputModel htmlDatasetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string UpdateHTMLDataSetById(HTMLDatasetEditModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? RemoveHTMLDataSetById(RemoveByIdInputModel removeById, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TemplateOutputModel> GetHTMLDataSetById(Guid id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TemplateOutputModel> GetHTMLDataSetByIdUnAuth(Guid id, List<ValidationMessage> validationMessages);
        List<TemplateOutputModel> GetAllHTMLDataSet(bool IsArchived, string SearchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        //string SaveDataSource(DataSourceDetailsInputModel dataSourceDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<object> ValidateAndRunMongoQuery(string MongoQuery, string MongoCollectionName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string ValidateAndRunMongoQueryUnAuth(string MongoQuery, string MongoCollectionName, List<ValidationMessage> validationMessages);
        string SaveMenuDataSet(MenuDatasetInputModel menuDatasetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string UpdateMenuDataSet(MenuDatasetInputModel menuDatasetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PDFDesignerDatasetOutputModel> GetAllPDFMenuDataSet(string TemplateId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PDFDesignerDatasetOutputModel> GetAllPDFMenuDataSetUnAuth(string TemplateId, List<ValidationMessage> validationMessages);
        public WebPageViewerModel SaveWebPageView(WebPageViewerModel webPageViewerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public List<WebPageViewerModel> GetWebPageView(string path, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public string StoreDownloadedTemplates(GenerateCompleteTemplatesOutputModel template,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GenerateCompleteTemplatesOutputModel> GetGeneratedInvoices(Guid GenericFormSubmittedId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public string UpdatePdfGeneratedValue(Guid GenericFormSubmittedId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

    }
}
