using Models.DeletePDFHTMLDesigner;
using MongoDB.Bson;
using MongoDB.Driver;
using PDFHTMLDesignerModels;
using PDFHTMLDesignerModels.DocumentModel;
using PDFHTMLDesignerModels.DocumentOutputModel;
using PDFHTMLDesignerModels.HTMLDocumentEditorModel;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PDFHTMLDesignerRepo.HTMLDataSet
{
    public interface IHTMLDataSetRepository
    {
        //HTMLDatasetOutputModel InsertHTMLDataSet(HTMLDatasetInputModel htmlDatasetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        //string UpdateHTMLDataSetById(HTMLDatasetEditModel inputModel,string HTMLFile, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        //Guid? RemoveHTMLDataSetById(RemoveByIdInputModel removeById, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        //List<TemplateOutputModel> GetHTMLDataSetById(Guid id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        //List<TemplateOutputModel> GetAllHTMLDataSet(bool IsArchived, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        //string SaveDataSource(DataSourceDetailsInputModel dataSourceDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        //string SaveMenuDataSet(MenuDatasetInputModel menuDatasetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        //string UpdateMenuDataSet(MenuDatasetInputModel menuDatasetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
