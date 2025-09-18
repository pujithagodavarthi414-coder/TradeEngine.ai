using PDFHTMLDesignerModels;
using PDFHTMLDesignerModels.DocumentModel;
using PDFHTMLDesignerModels.DocumentOutputModel;
using PDFHTMLDesignerModels.HTMLDocumentEditorModel;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;
using PDFHTMLDesignerModels.SFDTParameterModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PDFHTMLDesignerServices.DocumentEditor
{
    public interface IPDFMenuDataSetService
    {
        public Task<List<PDFDesignerDatasetOutputModel>> GetAllPDFMenuDataSet(string templateId,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public Task<List<PDFDesignerDatasetOutputModel>> GetAllPDFMenuDataSetUnAuth(string templateId, List<ValidationMessage> validationMessages);
        //public List<DataSetMenuModel> GetSelectedMenu(string GetSelectedMenu,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public Task<List<string>> GenerateCompleteTemplate(Guid? genericFormSubmittedId,List<PDFDesignerDatasetOutputModel> dataSources, List<object> selectedFormData, string templateSting, List<TemplateTagStylesModel> templateTagStyles, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public Task<List<string>> StoreDownloadedTemplates(List<GenerateCompleteTemplatesOutputModel> downloadedTemplates, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public Task<List<WebHtmlTemplateOutputModel>> GenerateCompleteWebTemplate(TemplateWithDataSourcesOutputModel templateWithDataSources, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public Task<List<WebHtmlTemplateOutputModel>> GenerateCompleteWebTemplateUnAuth(TemplateWithDataSourcesOutputModel templateWithDataSources, List<ValidationMessage> validationMessages);
        void TriggerWorkFlow(Guid? genericFormSublittedId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<bool?> ReplaceImages();

    }
}
