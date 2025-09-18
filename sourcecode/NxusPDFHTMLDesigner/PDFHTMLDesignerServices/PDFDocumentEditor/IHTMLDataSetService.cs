using Models.DeletePDFHTMLDesigner;
using MongoDB.Bson;
using PDFHTMLDesignerModels;
using PDFHTMLDesignerModels.DocumentModel;
using PDFHTMLDesignerModels.DocumentOutputModel;
using PDFHTMLDesignerModels.HTMLDocumentEditorModel;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;
using Syncfusion.DocIO.DLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PDFHTMLDesignerServices.DocumentEditor
{
    public interface IHTMLDataSetService
    {
        Task<HTMLDatasetOutputModel> InsertHTMLDataSet( HTMLDatasetsaveModel datasetsaveModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<string> UpdateHTMLDataSetById(HTMLDatasetEditModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<Guid?> RemoveHTMLDataSetById(RemoveByIdInputModel removeById, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<TemplateOutputModel> GetHTMLDataSetById(Guid id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<TemplateOutputModel> GetHTMLDataSetByIdUnAuth(Guid id, List<ValidationMessage> validationMessages);
        Task<List<TemplateOutputModel>> GetAllHTMLDataSet(bool IsArchived,string SearchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages); 
        Task<List<MenuDatasetInputModel>> SaveDataSource(DataSourceDetailsInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<List<dynamic>> ValidateAndRunMongoQuery(List<MongoQueryInputModel> mongoQueryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<List<dynamic>> ValidateAndRunMongoQueryUnAuth(List<MongoQueryInputModel> mongoQueryInputModel, List<ValidationMessage> validationMessages);
        string ConversionFromHtmltoSfdt(HtmlToSfdtConversionModel htmlFile, List<ValidationMessage> validationMessages);
        string DynamicTableCreationInDocx(string paramName, DynamicTableModel dynamicTable, List<TemplateTagStylesModel> templateTagStyles, WordDocument document, List<ValidationMessage> validationMessages);
        Task<List<GenerateCompleteTemplatesOutputModel>> GetGeneratedInvoices(Guid GenericFormSubmittedId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<FileConvertionOutputModel> FileConvertion(List<FileConvertionInputModel> inputModel, List<ValidationMessage> validationMessages);
        string ByteArrayToPDFConvertion(ByteArrayToPDFConvertion inputModel, List<ValidationMessage> validationMessages);
    }
}
